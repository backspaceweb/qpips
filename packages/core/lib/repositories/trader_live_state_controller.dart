import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/account.dart';
import '../domain/account_ownership.dart';
import '../domain/live_performance.dart';
import '../domain/trade_order.dart';
import 'account_repository.dart';
import 'trading_repository.dart';

/// Single source of truth for trader-owned account live state across
/// the user app. Polls the trading API on three cadences:
///
///   * **Open orders → openPnl + equity + openTradesCount — every 3s.**
///     Cheapest tick: one getOpenOrders per account, no history.
///     Detects close events by diffing ticket sets against the previous
///     tick; on a detected close, fires a one-shot history refresh for
///     the affected account so balance + todayPnl reflect the new
///     realised P&L promptly.
///   * **Connection status — every 15s.** Single batched
///     getStatusbyID call regardless of fleet size.
///   * **History fallback — every 2 min.** Catches cases where a
///     trade closed and reopened between two ticks (close detection
///     missed it) by full-refreshing balance + todayPnl across all
///     accounts.
///
/// Multiple screens (AccountsScreen, MyFollowsScreen) consume the
/// controller via `ChangeNotifier` listeners, keeping their visible
/// values in lockstep. No screen runs its own polling.
///
/// Lifecycle:
///   * `initialize()` runs the first fetch + starts timers.
///     Idempotent — calling again is a no-op until `dispose()` runs.
///   * `reloadAccounts()` — call after add/delete/switch master so
///     the controller knows the new fleet.
///   * `refresh()` — manual one-shot full reload (pull-to-refresh).
///   * `dispose()` — cancels timers; safe to call from a Provider's
///     `dispose` callback.
class TraderLiveStateController extends ChangeNotifier {
  final AccountRepository _accountRepo;
  final TradingRepository _trading;

  TraderLiveStateController(this._accountRepo, this._trading);

  // ---- Public state ----
  List<AccountOwnership> _accounts = const [];
  Map<int, SlaveLiveState> _liveStateByAccount = const {};
  Map<int, String> _statusByAccount = const {};
  Map<int, List<TradeOrder>> _openOrdersByAccount = const {};
  DateTime? _lastUpdatedAt;
  bool _initializing = false;
  bool _initialized = false;
  Object? _initialError;

  List<AccountOwnership> get accounts => _accounts;
  Map<int, SlaveLiveState> get liveStateByAccount => _liveStateByAccount;
  Map<int, String> get statusByAccount => _statusByAccount;
  Map<int, List<TradeOrder>> get openOrdersByAccount => _openOrdersByAccount;
  DateTime? get lastUpdatedAt => _lastUpdatedAt;
  bool get initializing => _initializing;
  bool get initialized => _initialized;
  Object? get initialError => _initialError;

  /// Returns the live state for the account with the given serverId,
  /// or [SlaveLiveState.empty] if not yet loaded.
  SlaveLiveState liveFor(int serverId) =>
      _liveStateByAccount[serverId] ?? SlaveLiveState.empty;

  String? statusFor(int serverId) => _statusByAccount[serverId];

  /// Live open-orders list for the account. Empty list if not loaded
  /// or if the account has no open positions.
  List<TradeOrder> openOrdersFor(int serverId) =>
      _openOrdersByAccount[serverId] ?? const [];

  // ---- Internal ----
  final Map<int, Set<int>> _lastSeenTickets = {};
  Timer? _openOrdersTimer;
  Timer? _statusTimer;
  Timer? _historyFallbackTimer;
  bool _disposed = false;

  /// Kicks off the first fetch + starts timers. Safe to call multiple
  /// times — only the first call actually does work.
  Future<void> initialize() async {
    if (_initialized || _initializing || _disposed) return;
    _initializing = true;
    notifyListeners();
    try {
      await _fullReload();
      _initialized = true;
      _startTimers();
    } catch (e) {
      _initialError = e;
    } finally {
      _initializing = false;
      if (!_disposed) notifyListeners();
    }
  }

  /// Re-fetches the trader's account list. Call after add / delete /
  /// switch master so the controller polls the new fleet.
  Future<void> reloadAccounts() async {
    if (!_initialized || _disposed) return;
    await _fullReload();
    if (!_disposed) notifyListeners();
  }

  /// Manual one-shot full reload (pull-to-refresh from any screen).
  Future<void> refresh() async {
    if (_disposed) return;
    await _fullReload();
    if (!_disposed) notifyListeners();
  }

  Future<void> _fullReload() async {
    final accounts = await _accountRepo.listMyAccounts();
    final liveResults = await Future.wait([
      ...[
        for (final a in accounts)
          _trading.getAccountLiveState(account: _accountFor(a)),
      ],
      _trading.getAccountStatuses(
        serverIds: accounts.map((a) => a.tradingAccountId).toList(),
      ),
    ]);
    final liveStates =
        liveResults.sublist(0, accounts.length).cast<SlaveLiveState>();
    final statuses = liveResults.last as Map<int, String>;

    // Seed last-seen tickets from a fresh openOrders snapshot so the
    // first 3s tick has a baseline.
    final initialOpenOrders = await Future.wait([
      for (final a in accounts)
        _trading.getOpenOrders(account: _accountFor(a)),
    ]);

    _accounts = accounts;
    _liveStateByAccount = {
      for (var i = 0; i < accounts.length; i++)
        accounts[i].tradingAccountId: liveStates[i],
    };
    _statusByAccount = statuses;
    _openOrdersByAccount = {
      for (var i = 0; i < accounts.length; i++)
        accounts[i].tradingAccountId: initialOpenOrders[i],
    };
    _lastSeenTickets
      ..clear()
      ..addAll({
        for (var i = 0; i < accounts.length; i++)
          accounts[i].tradingAccountId: {
            for (final o in initialOpenOrders[i]) o.ticket,
          },
      });
    _lastUpdatedAt = DateTime.now();
    _initialError = null;
  }

  void _startTimers() {
    _openOrdersTimer?.cancel();
    _statusTimer?.cancel();
    _historyFallbackTimer?.cancel();
    _openOrdersTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _pollOpenOrders(),
    );
    _statusTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _pollStatus(),
    );
    _historyFallbackTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => _pollHistory(allAccountIds: true),
    );
  }

  Account _accountFor(AccountOwnership a) {
    return Account(
      serverId: a.tradingAccountId,
      loginNumber: a.loginNumber,
      accountName: a.effectiveLabel,
      accountType: a.accountType,
      platform: a.platform,
    );
  }

  Future<void> _pollOpenOrders() async {
    if (_disposed || _accounts.isEmpty) return;
    try {
      final results = await Future.wait([
        for (final a in _accounts)
          _trading.getOpenOrders(account: _accountFor(a)),
      ]);
      if (_disposed) return;

      final closedAccountIds = <int>{};
      final newLive = Map<int, SlaveLiveState>.from(_liveStateByAccount);
      final newOpen = Map<int, List<TradeOrder>>.from(_openOrdersByAccount);

      for (var i = 0; i < _accounts.length; i++) {
        final acct = _accounts[i];
        final orders = results[i];
        final tickets = {for (final o in orders) o.ticket};
        final last = _lastSeenTickets[acct.tradingAccountId] ?? const {};
        if (last.difference(tickets).isNotEmpty) {
          closedAccountIds.add(acct.tradingAccountId);
        }
        _lastSeenTickets[acct.tradingAccountId] = tickets;

        double openPnl = 0;
        for (final o in orders) {
          openPnl += o.profit + o.commission + o.swap;
        }

        final prev = newLive[acct.tradingAccountId] ?? SlaveLiveState.empty;
        newLive[acct.tradingAccountId] = SlaveLiveState(
          balance: prev.balance,
          equity: prev.balance + openPnl,
          openPnl: openPnl,
          todayPnl: prev.todayPnl,
          openTradesCount: orders.length,
        );
        newOpen[acct.tradingAccountId] = orders;
      }

      _liveStateByAccount = newLive;
      _openOrdersByAccount = newOpen;
      _lastUpdatedAt = DateTime.now();
      notifyListeners();

      if (closedAccountIds.isNotEmpty) {
        unawaited(_pollHistory(forAccountIds: closedAccountIds));
      }
    } catch (e) {
      // Swallow; UI keeps last known values. Next tick retries.
      if (kDebugMode) print('LiveStateController _pollOpenOrders: $e');
    }
  }

  Future<void> _pollStatus() async {
    if (_disposed || _accounts.isEmpty) return;
    try {
      final ids = _accounts.map((a) => a.tradingAccountId).toList();
      final newStatuses = await _trading.getAccountStatuses(serverIds: ids);
      if (_disposed) return;
      _statusByAccount = newStatuses;
      _lastUpdatedAt = DateTime.now();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('LiveStateController _pollStatus: $e');
    }
  }

  Future<void> _pollHistory({
    Set<int>? forAccountIds,
    bool allAccountIds = false,
  }) async {
    if (_disposed || _accounts.isEmpty) return;
    final targets = allAccountIds
        ? _accounts
        : _accounts
            .where((a) => forAccountIds!.contains(a.tradingAccountId))
            .toList();
    if (targets.isEmpty) return;

    try {
      final from = DateTime(2020, 1, 1);
      final to = DateTime.now();
      final midnightUtc =
          DateTime.utc(to.toUtc().year, to.toUtc().month, to.toUtc().day);

      final histories = await Future.wait([
        for (final a in targets)
          _trading.getOrderHistory(
            account: _accountFor(a),
            from: from,
            to: to,
          ),
      ]);
      if (_disposed) return;

      final newLive = Map<int, SlaveLiveState>.from(_liveStateByAccount);
      for (var i = 0; i < targets.length; i++) {
        final acct = targets[i];
        final history = histories[i];

        double balance = 0;
        double todayPnl = 0;
        for (final o in history) {
          final pnl = o.profit + o.commission + o.swap;
          balance += pnl;
          if (!o.isBalanceEntry) {
            final closedAt = o.lastUpdateTime ?? o.openTime;
            if (closedAt != null &&
                !closedAt.toUtc().isBefore(midnightUtc)) {
              todayPnl += pnl;
            }
          }
        }

        final prev = newLive[acct.tradingAccountId] ?? SlaveLiveState.empty;
        newLive[acct.tradingAccountId] = SlaveLiveState(
          balance: balance,
          equity: balance + prev.openPnl,
          openPnl: prev.openPnl,
          todayPnl: todayPnl,
          openTradesCount: prev.openTradesCount,
        );
      }

      _liveStateByAccount = newLive;
      _lastUpdatedAt = DateTime.now();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('LiveStateController _pollHistory: $e');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _openOrdersTimer?.cancel();
    _statusTimer?.cancel();
    _historyFallbackTimer?.cancel();
    super.dispose();
  }
}
