import 'account.dart';
import 'master_listing.dart';

/// A trader's currently-active follow — one slave bound to one master,
/// with a live snapshot.
///
/// Powers the My Active Follows list. Phase E will hydrate this from a
/// join across `slave_ownership`, `follow_intents`, and live trading
/// API state. Today (D.5) the mock repository synthesises plausible
/// values.
///
/// Distinct from [ActiveFollowSubmission] (returned by submitFollow):
/// `ActiveFollow` is the read-side view with live P&L; the submission
/// is the just-confirmed write-side record.
class ActiveFollow {
  // ---- Identity ----
  final String slaveAccountId;

  /// Trading API's serverId for the master this slave is bound to.
  /// Null on legacy mock data (the mock keys masters by listing-id
  /// strings); the real repository always sets this so cross-surface
  /// lookups (Provider Profile chip etc) can match against the
  /// master's account_ownership row.
  final int? masterAccountId;

  /// String identifier of the master in whatever directory surface
  /// surfaced the follow — for the real repo this matches the
  /// provider_listings.id (uuid); for the mock, the 'mock-NNN' id.
  final String masterId;

  final DateTime createdAt;

  // ---- Slave snapshot ----
  final String slaveDisplayName;
  final Platform slavePlatform;
  final String slaveBroker;
  final String slaveLoginNumber;
  final double slaveBalance;
  final double slaveEquity;
  final String slaveCurrency;

  // ---- Master display extras ----
  final String masterDisplayName;
  final ProviderTier masterTier;

  // ---- Live state ----
  /// Open positions' floating P&L right now. Will roll into [todayPnl]
  /// when those positions close.
  final double openPnl;

  /// Realised P&L since UTC midnight today.
  final double todayPnl;

  /// Number of open positions on this slave.
  final int openTradesCount;

  /// Trader has temporarily stopped mirroring. Existing open positions
  /// stay open; no new ones get mirrored. Phase E may add a "close
  /// open positions on pause" toggle.
  final bool isPaused;

  const ActiveFollow({
    required this.slaveAccountId,
    required this.masterId,
    this.masterAccountId,
    required this.createdAt,
    required this.slaveDisplayName,
    required this.slavePlatform,
    required this.slaveBroker,
    required this.slaveLoginNumber,
    required this.slaveBalance,
    required this.slaveEquity,
    required this.slaveCurrency,
    required this.masterDisplayName,
    required this.masterTier,
    required this.openPnl,
    required this.todayPnl,
    required this.openTradesCount,
    required this.isPaused,
  });

  ActiveFollow copyWith({
    bool? isPaused,
    double? slaveBalance,
    double? slaveEquity,
    double? openPnl,
    double? todayPnl,
    int? openTradesCount,
  }) {
    return ActiveFollow(
      slaveAccountId: slaveAccountId,
      masterId: masterId,
      masterAccountId: masterAccountId,
      createdAt: createdAt,
      slaveDisplayName: slaveDisplayName,
      slavePlatform: slavePlatform,
      slaveBroker: slaveBroker,
      slaveLoginNumber: slaveLoginNumber,
      slaveBalance: slaveBalance ?? this.slaveBalance,
      slaveEquity: slaveEquity ?? this.slaveEquity,
      slaveCurrency: slaveCurrency,
      masterDisplayName: masterDisplayName,
      masterTier: masterTier,
      openPnl: openPnl ?? this.openPnl,
      todayPnl: todayPnl ?? this.todayPnl,
      openTradesCount: openTradesCount ?? this.openTradesCount,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}

/// Compact confirmation returned by [TraderRepository.submitFollow].
/// The Configure Follow sheet uses this only to flip into success state
/// — the My Follows list reads [ActiveFollow] separately.
class ActiveFollowSubmission {
  final String slaveAccountId;
  final String masterId;
  final DateTime createdAt;

  const ActiveFollowSubmission({
    required this.slaveAccountId,
    required this.masterId,
    required this.createdAt,
  });
}
