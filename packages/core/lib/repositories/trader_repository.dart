import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/account.dart';
import '../domain/active_follow.dart';
import '../domain/follow_config.dart';
import '../domain/master_listing.dart';
import '../domain/trader_slave.dart';
import 'trading_repository.dart';

/// Trader-app reads & writes that aren't pure directory queries.
///
/// Today (D.5, Option A) the only implementation is
/// [MockTraderRepository] which serves a deterministic set of slave
/// accounts + active follows and stubs out the mutation methods as
/// in-memory state changes.
///
/// Phase E will swap in a `SupabaseTraderRepository`:
///   - `listMySlaves()` → join `slave_ownership` (Supabase) with
///     `getAccountDetails` calls scoped to the rows that belong to the
///     current trader.
///   - `submitFollow(...)` → call `updateRiskSettings` +
///     `updateOrderControlSettings` on the trading proxy, then write
///     to `follow_intents` for audit.
///   - `listActiveFollows()` → join `slave_ownership` with live
///     `getOpenOrders` to compute open P&L per follow.
///   - `pauseFollow / resumeFollow / unfollow` → toggle the master
///     binding via the trading API + audit-write on Supabase.
abstract class TraderRepository {
  /// Slaves owned by the currently signed-in trader.
  Future<List<TraderSlaveAccount>> listMySlaves();

  /// Apply [config] to the chosen slave + bind it to the master.
  Future<ActiveFollowSubmission> submitFollow(FollowConfig config);

  /// All currently-active follows for the signed-in trader, with a
  /// live P&L snapshot per row.
  Future<List<ActiveFollow>> listActiveFollows();

  /// Stop mirroring new orders on this slave. Existing open positions
  /// stay open. Idempotent.
  Future<void> pauseFollow(String slaveAccountId);

  /// Reverse of [pauseFollow]. Idempotent.
  Future<void> resumeFollow(String slaveAccountId);

  /// Drop the master binding entirely. Existing open positions stay
  /// open until the trader closes them on the broker side.
  Future<void> unfollow(String slaveAccountId);
}

/// Mock implementation. Returns a small fleet of slaves a trader might
/// realistically have wired up — different platforms, brokers, and a
/// mix of "fresh" + "already following" states.
class MockTraderRepository implements TraderRepository {
  late final List<TraderSlaveAccount> _slaves = _generateSlaves();
  late final List<ActiveFollow> _follows = _generateFollows();

  List<TraderSlaveAccount> _generateSlaves() {
    final rng = Random(42);
    final defs = <_SlaveDef>[
      _SlaveDef('Main Slave', Platform.mt5, 'Exness', '417182231', 5840),
      _SlaveDef('Backup Slave', Platform.mt5, 'IC Markets', '90217745', 1240),
      _SlaveDef('XAU Experiment', Platform.mt4, 'Pepperstone', '5012880', 612),
      _SlaveDef('Index Slave', Platform.mt5, 'FP Markets', '230884', 8850),
    ];
    return [
      for (var i = 0; i < defs.length; i++)
        TraderSlaveAccount(
          id: 'slave-${i.toString().padLeft(3, '0')}',
          displayName: defs[i].displayName,
          platform: defs[i].platform,
          broker: defs[i].broker,
          loginNumber: defs[i].login,
          balance: defs[i].balance,
          equity: defs[i].balance + (rng.nextDouble() - 0.4) * 80,
          currency: 'USD',
          followingMasterDisplayName:
              i == 0 ? 'Aurora Gold Trend' : (i == 3 ? 'Polaris Hedge' : null),
          isPaused: false,
        ),
    ];
  }

  List<ActiveFollow> _generateFollows() {
    final rng = Random(7);
    final result = <ActiveFollow>[];
    final masterPicks = [
      ('mock-000', 'Aurora Gold Trend', ProviderTier.bronze),
      ('mock-009', 'Polaris Hedge', ProviderTier.bronze),
    ];
    var pickIdx = 0;
    for (final s in _slaves) {
      if (s.followingMasterDisplayName == null) continue;
      final mp = masterPicks[pickIdx % masterPicks.length];
      pickIdx++;
      final daysAgo = 7 + rng.nextInt(40);
      final openPnl = (rng.nextDouble() - 0.3) * 120;
      final todayPnl = (rng.nextDouble() - 0.45) * 60;
      result.add(
        ActiveFollow(
          slaveAccountId: s.id,
          masterId: mp.$1,
          createdAt: DateTime.now().subtract(Duration(days: daysAgo)),
          slaveDisplayName: s.displayName,
          slavePlatform: s.platform,
          slaveBroker: s.broker,
          slaveLoginNumber: s.loginNumber,
          slaveBalance: s.balance,
          slaveEquity: s.equity,
          slaveCurrency: s.currency,
          masterDisplayName: mp.$2,
          masterTier: mp.$3,
          openPnl: openPnl,
          todayPnl: todayPnl,
          openTradesCount: 1 + rng.nextInt(4),
          isPaused: false,
        ),
      );
    }
    return result;
  }

  @override
  Future<List<TraderSlaveAccount>> listMySlaves() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _slaves;
  }

  @override
  Future<ActiveFollowSubmission> submitFollow(FollowConfig config) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return ActiveFollowSubmission(
      slaveAccountId: config.slaveAccountId,
      masterId: config.masterId,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<ActiveFollow>> listActiveFollows() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    // Return a defensive copy so callers can't accidentally mutate
    // our backing list.
    return List.unmodifiable(_follows);
  }

  @override
  Future<void> pauseFollow(String slaveAccountId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _replace(slaveAccountId, (f) => f.copyWith(isPaused: true));
  }

  @override
  Future<void> resumeFollow(String slaveAccountId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _replace(slaveAccountId, (f) => f.copyWith(isPaused: false));
  }

  @override
  Future<void> unfollow(String slaveAccountId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _follows.removeWhere((f) => f.slaveAccountId == slaveAccountId);
  }

  void _replace(
    String slaveAccountId,
    ActiveFollow Function(ActiveFollow) update,
  ) {
    for (var i = 0; i < _follows.length; i++) {
      if (_follows[i].slaveAccountId == slaveAccountId) {
        _follows[i] = update(_follows[i]);
        return;
      }
    }
  }
}

class _SlaveDef {
  final String displayName;
  final Platform platform;
  final String broker;
  final String login;
  final double balance;
  const _SlaveDef(
    this.displayName,
    this.platform,
    this.broker,
    this.login,
    this.balance,
  );
}

/// Real Supabase-backed trader repository.
///
/// Reads slaves + active follows from `account_ownership`, joining
/// with the master row + provider_listings for display names. Live P&L
/// surfaces (openPnl, todayPnl, openTradesCount) come from a separate
/// trade-history aggregation slice — for now they default to 0 so My
/// Follows renders without nulls.
///
/// Pause / resume / unfollow proxy through the existing
/// [TradingRepository]:
///   - pause/resume → toggleAccountActivation (active_*/MT4|MT5 + DB
///     mirroring_disabled flag).
///   - unfollow → deleteTradingAccount (DELETE /api/v1/follow/{X} +
///     account_ownership row deletion).
///
/// `submitFollow` is intentionally unimplemented in this slice — the
/// trader's primary registration path is Add Account → Slave from the
/// Accounts tab, which already binds the slave to a master at register
/// time. The Configure Follow flow (carrying full risk config) waits
/// for a redesign that fits this real-data world.
class SupabaseTraderRepository implements TraderRepository {
  final SupabaseClient _supabase;
  final TradingRepository _trading;

  SupabaseTraderRepository(this._supabase, this._trading);

  String get _myUserId {
    final id = _supabase.auth.currentUser?.id;
    if (id == null) throw StateError('Not authenticated');
    return id;
  }

  @override
  Future<List<TraderSlaveAccount>> listMySlaves() async {
    final rows = await _supabase
        .from('account_ownership')
        .select('trading_account_id, login_number, platform, '
            'display_name, following_master_id, mirroring_disabled')
        .eq('user_id', _myUserId)
        .eq('account_type', 'slave')
        .order('registered_at', ascending: false);

    final list = (rows as List).cast<Map<String, dynamic>>();
    if (list.isEmpty) return const [];

    // Resolve each slave's bound master display name. Look up in
    // provider_listings first (rich label); fall back to the master's
    // own account_ownership.display_name; final fallback is the master's
    // login number.
    final masterIds = list
        .map((r) => r['following_master_id'])
        .whereType<num>()
        .map((n) => n.toInt())
        .toSet()
        .toList();

    final Map<int, String> masterLabelById = {};
    if (masterIds.isNotEmpty) {
      final listings = await _supabase
          .from('provider_listings')
          .select('master_account_id, display_name')
          .inFilter('master_account_id', masterIds);
      for (final r in (listings as List).cast<Map<String, dynamic>>()) {
        final mid = (r['master_account_id'] as num).toInt();
        final name = (r['display_name'] as String?)?.trim();
        if (name != null && name.isNotEmpty) masterLabelById[mid] = name;
      }
      // Anything still missing — fall back to the master's
      // account_ownership row (which the trader's RLS may or may not
      // see, since they only read their own rows). When invisible we
      // surface the serverId as a last resort.
      final fallbackIds =
          masterIds.where((id) => !masterLabelById.containsKey(id)).toList();
      if (fallbackIds.isNotEmpty) {
        final ao = await _supabase
            .from('account_ownership')
            .select('trading_account_id, display_name, login_number')
            .inFilter('trading_account_id', fallbackIds);
        for (final r in (ao as List).cast<Map<String, dynamic>>()) {
          final mid = (r['trading_account_id'] as num).toInt();
          final dn = (r['display_name'] as String?)?.trim();
          masterLabelById[mid] = (dn != null && dn.isNotEmpty)
              ? dn
              : (r['login_number']?.toString() ?? '#$mid');
        }
      }
    }

    return [
      for (final r in list) _toTraderSlave(r, masterLabelById),
    ];
  }

  TraderSlaveAccount _toTraderSlave(
    Map<String, dynamic> r,
    Map<int, String> masterLabelById,
  ) {
    final platform = Platform.parse(r['platform']);
    final masterId = (r['following_master_id'] as num?)?.toInt();
    final masterLabel =
        masterId == null ? null : masterLabelById[masterId];
    final displayName = (r['display_name'] as String?)?.trim();
    return TraderSlaveAccount(
      id: (r['trading_account_id'] as num).toInt().toString(),
      displayName: (displayName == null || displayName.isEmpty)
          ? r['login_number']?.toString() ?? '#${r['trading_account_id']}'
          : displayName,
      platform: platform,
      // We don't track the broker server name yet; surface platform.
      broker: platform.wireValue.toUpperCase(),
      loginNumber: r['login_number']?.toString() ?? '',
      // Live balance + equity come from the trading API; surface 0
      // until the live-perf slice lands.
      balance: 0,
      equity: 0,
      currency: 'USD',
      followingMasterDisplayName: masterLabel,
      isPaused: r['mirroring_disabled'] as bool? ?? false,
    );
  }

  @override
  Future<List<ActiveFollow>> listActiveFollows() async {
    final rows = await _supabase
        .from('account_ownership')
        .select('trading_account_id, login_number, platform, '
            'display_name, following_master_id, mirroring_disabled')
        .eq('user_id', _myUserId)
        .eq('account_type', 'slave')
        .not('following_master_id', 'is', null)
        .order('registered_at', ascending: false);

    final list = (rows as List).cast<Map<String, dynamic>>();
    if (list.isEmpty) return const [];

    final masterIds = list
        .map((r) => (r['following_master_id'] as num).toInt())
        .toSet()
        .toList();

    // Pull both provider_listings and account_ownership for the masters
    // — the listing carries display name + tier; the master's row is
    // the authoritative serverId source.
    final listings = await _supabase
        .from('provider_listings')
        .select('id, master_account_id, display_name, tier')
        .inFilter('master_account_id', masterIds);
    final Map<int, Map<String, dynamic>> listingByMaster = {
      for (final r in (listings as List).cast<Map<String, dynamic>>())
        (r['master_account_id'] as num).toInt(): r,
    };

    return [
      for (final r in list) _toActiveFollow(r, listingByMaster),
    ];
  }

  ActiveFollow _toActiveFollow(
    Map<String, dynamic> r,
    Map<int, Map<String, dynamic>> listingByMaster,
  ) {
    final masterId = (r['following_master_id'] as num).toInt();
    final listing = listingByMaster[masterId];
    final tier = _parseTier(listing?['tier'] as String?);
    final masterDisplayName = (listing?['display_name'] as String?) ??
        'Master #$masterId';
    // The 'masterId' (string) field on ActiveFollow is for cross-ref
    // with directory ids. For real data, use the listing uuid when
    // present; fall back to the bigint string.
    final masterIdString =
        (listing?['id'] as String?) ?? masterId.toString();

    final slaveDisplayName = (r['display_name'] as String?)?.trim();
    final platform = Platform.parse(r['platform']);
    return ActiveFollow(
      slaveAccountId: (r['trading_account_id'] as num).toInt().toString(),
      masterId: masterIdString,
      masterAccountId: masterId,
      // We don't store registered_at on the follow itself; we skip it
      // via DateTime.now() so 'createdAt' shows "—" cleanly until the
      // live-perf slice can pull the real binding timestamp.
      createdAt: DateTime.now(),
      slaveDisplayName: (slaveDisplayName == null || slaveDisplayName.isEmpty)
          ? r['login_number']?.toString() ?? '#${r['trading_account_id']}'
          : slaveDisplayName,
      slavePlatform: platform,
      slaveBroker: platform.wireValue.toUpperCase(),
      slaveLoginNumber: r['login_number']?.toString() ?? '',
      slaveBalance: 0,
      slaveEquity: 0,
      slaveCurrency: 'USD',
      masterDisplayName: masterDisplayName,
      masterTier: tier,
      openPnl: 0,
      todayPnl: 0,
      openTradesCount: 0,
      isPaused: r['mirroring_disabled'] as bool? ?? false,
    );
  }

  ProviderTier _parseTier(String? raw) {
    if (raw == null) return ProviderTier.bronze;
    return ProviderTier.values.firstWhere(
      (t) => t.name == raw,
      orElse: () => ProviderTier.bronze,
    );
  }

  @override
  Future<void> pauseFollow(String slaveAccountId) async {
    final serverId = int.tryParse(slaveAccountId);
    if (serverId == null) {
      throw ArgumentError('slaveAccountId must be the bigint serverId, '
          'got "$slaveAccountId"');
    }
    final ok = await _trading.toggleAccountActivation(
      account: await _slaveAccount(serverId),
      activate: false,
    );
    if (!ok) throw StateError('pauseFollow: trading API rejected toggle');
  }

  @override
  Future<void> resumeFollow(String slaveAccountId) async {
    final serverId = int.tryParse(slaveAccountId);
    if (serverId == null) {
      throw ArgumentError('slaveAccountId must be the bigint serverId, '
          'got "$slaveAccountId"');
    }
    final ok = await _trading.toggleAccountActivation(
      account: await _slaveAccount(serverId),
      activate: true,
    );
    if (!ok) throw StateError('resumeFollow: trading API rejected toggle');
  }

  @override
  Future<void> unfollow(String slaveAccountId) async {
    final serverId = int.tryParse(slaveAccountId);
    if (serverId == null) {
      throw ArgumentError('slaveAccountId must be the bigint serverId, '
          'got "$slaveAccountId"');
    }
    final acct = await _slaveAccount(serverId);
    final result = await _trading.deleteTradingAccount(
      userId: serverId,
      isMaster: false,
      platform: acct.platform.wireValue,
      loginNumber: acct.loginNumber,
    );
    if (!result.toLowerCase().contains('success')) {
      throw StateError('unfollow: $result');
    }
  }

  /// Hydrates an [Account] for the trading-API calls. Looks up the row
  /// by [serverId] under the caller's RLS scope so a trader can't act
  /// on someone else's slave.
  Future<Account> _slaveAccount(int serverId) async {
    final rows = await _supabase
        .from('account_ownership')
        .select('trading_account_id, login_number, platform, '
            'account_type, display_name')
        .eq('user_id', _myUserId)
        .eq('trading_account_id', serverId)
        .limit(1);
    final list = (rows as List);
    if (list.isEmpty) {
      throw StateError('Slave $serverId not found under current trader');
    }
    final r = list.first as Map<String, dynamic>;
    final dn = (r['display_name'] as String?)?.trim();
    return Account(
      serverId: serverId,
      loginNumber: r['login_number']?.toString() ?? '',
      accountName: (dn == null || dn.isEmpty) ? '#$serverId' : dn,
      accountType: AccountType.parse(r['account_type']),
      platform: Platform.parse(r['platform']),
    );
  }

  @override
  Future<ActiveFollowSubmission> submitFollow(FollowConfig config) async {
    // The Configure Follow flow (which calls this) was built around
    // the mock data model where a trader picked an existing slave +
    // master + risk config in one shot. Post-B-slice the trader
    // registers slaves with their master at register time on the
    // Accounts tab, and tunes risk/orders via the gear icon. A real
    // implementation here would need to call switch master + apply
    // risk settings — landing as a redesign in the live-perf slice.
    throw UnimplementedError(
      'submitFollow not implemented for SupabaseTraderRepository. '
      'Use Add Account → Slave from the Accounts tab to register a '
      'slave bound to a master, then tune risk via the gear icon.',
    );
  }
}
