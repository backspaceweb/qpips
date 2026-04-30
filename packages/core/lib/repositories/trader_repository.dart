import 'dart:math';

import '../domain/account.dart';
import '../domain/active_follow.dart';
import '../domain/follow_config.dart';
import '../domain/master_listing.dart';
import '../domain/trader_slave.dart';

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
