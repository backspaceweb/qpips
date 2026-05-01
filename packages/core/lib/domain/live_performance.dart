import 'provider_profile.dart';

/// Aggregations computed from a master account's trade history over a
/// time window. Returned by `TradingRepository.getMasterPerformance`
/// and merged into `ProviderProfile` by the directory repository.
///
/// Null on API failure — callers fall back to operator-set snapshot
/// values (gain_pct etc on `provider_listings`).
class MasterPerformance {
  /// Total P&L over the window divided by total deposits over the
  /// window (when present) or by total |P&L| as a soft denominator.
  /// Returns 0 when neither is meaningful.
  final double gainFraction;

  /// Worst peak-to-trough drawdown over the equity curve, as a
  /// negative fraction (e.g. -0.12 == -12%). Computed from the
  /// running equity curve.
  final double drawdownFraction;

  /// Daily equity + balance points spanning the window. Drives the
  /// equity-vs-balance line chart on the profile.
  final List<EquityPoint> equityHistory;

  final ProviderStats stats;

  /// Up to 12 most recent closed trades for the activity table.
  final List<TradingActivity> recentActivity;

  /// Symbol → fraction of total volume traded. Sums to ~1.0.
  final Map<String, double> symbolDistribution;

  const MasterPerformance({
    required this.gainFraction,
    required this.drawdownFraction,
    required this.equityHistory,
    required this.stats,
    required this.recentActivity,
    required this.symbolDistribution,
  });
}

/// Per-account live state for the My Follows + Accounts surfaces.
/// Computed by `TradingRepository.getAccountLiveState` from a single
/// all-time history pull plus open orders. Works the same for master
/// and slave accounts — the trading API distinguishes them via the
/// `accountStatus` query param under the hood.
///
/// Caveat on [balance] / [equity]: the trading API has no direct
/// balance endpoint, so the values are *synthetic* — reconstructed
/// by walking deposit / withdrawal entries plus realised trade P&L
/// since whatever depth the API exposes. For accounts that joined
/// QuantumPips fresh (no prior broker-side activity outside the
/// API's history window), this matches the broker-side balance
/// exactly. For accounts with older activity beyond the API's
/// history depth, the value under-reports — UI captions it as
/// "since QuantumPips registration" so traders aren't misled.
class SlaveLiveState {
  /// Synthetic running balance reconstructed from history. See class
  /// doc for the caveat.
  final double balance;

  /// `balance + openPnl`.
  final double equity;

  /// Sum of `profit + commission + swap` across open positions. Floats
  /// up/down with the market.
  final double openPnl;

  /// Realised P&L for trades closed since UTC midnight today. Excludes
  /// "Balance" deposit/withdrawal entries.
  final double todayPnl;

  /// Number of currently-open positions on this slave.
  final int openTradesCount;

  const SlaveLiveState({
    required this.balance,
    required this.equity,
    required this.openPnl,
    required this.todayPnl,
    required this.openTradesCount,
  });

  static const empty = SlaveLiveState(
    balance: 0,
    equity: 0,
    openPnl: 0,
    todayPnl: 0,
    openTradesCount: 0,
  );
}
