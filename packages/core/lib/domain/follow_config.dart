/// Trader-facing configuration captured by the Configure Follow flow.
///
/// Mirrors the shape of the admin-side Slave Settings dialog (Risk &
/// Stops + Order Control tabs) but presented in trader-friendly
/// language. Submitted to [TraderRepository.submitFollow] which under
/// Phase E translates these fields to:
///   - `updateRiskSettings` on the trading API for risk + copy SL/TP +
///     scalper + filter,
///   - `updateOrderControlSettings` for the auto-close limits,
///   - and a Supabase row in `follow_intents` recording the master/slave
///     binding.
///
/// Today (D.5 mock) the repo just echoes the config back as success.
class FollowConfig {
  /// Trading-server master account ID — taken from
  /// [MasterListing.id] on the discovery card the trader chose.
  final String masterId;

  /// Trader's slave account that will start mirroring this master.
  final String slaveAccountId;

  final RiskMode riskMode;

  /// Multiplier interpretation depends on [riskMode]:
  ///   - [RiskMode.equityScaled]: x times the master's per-trade risk
  ///     scaled by the equity ratio (default 1.0).
  ///   - [RiskMode.lotMultiplier]: x times the master's lot size.
  ///   - [RiskMode.fixedLot]: literal lot size to open per trade.
  ///   - [RiskMode.autoRisk]: ignored — the server picks the multiplier.
  final double riskMultiplier;

  /// Copy stop-loss + take-profit levels from the master order. When
  /// false, slave orders open with no SL/TP attached.
  final bool copySlTp;

  final ScalperMode scalperMode;

  /// Threshold paired with the scalper mode (0 disables for `permanent`
  /// / `rollover`; spec details in tooltip).
  final int scalperValuePoints;

  final OrderFilter orderFilter;

  /// Optional auto-close limits. Null => trader skipped Advanced; the
  /// server-side defaults stay in place.
  final FollowLimits? limits;

  const FollowConfig({
    required this.masterId,
    required this.slaveAccountId,
    required this.riskMode,
    required this.riskMultiplier,
    required this.copySlTp,
    required this.scalperMode,
    required this.scalperValuePoints,
    required this.orderFilter,
    this.limits,
  });
}

/// How the slave sizes its trades relative to the master.
enum RiskMode {
  /// Server-side: scale risk by equity ratio (master / slave). Best
  /// default for traders with similar account sizes.
  equityScaled('Equity-scaled risk'),

  /// Server-side: multiply the master's lot size by [riskMultiplier].
  lotMultiplier('Lot multiplier'),

  /// Server-side: every order opens at exactly [riskMultiplier] lots.
  fixedLot('Fixed lot size'),

  /// Server-side: auto-tune per provider. Ignores [riskMultiplier].
  autoRisk('Auto risk');

  final String label;
  const RiskMode(this.label);
}

enum ScalperMode {
  off('Off'),

  /// Mirror micro-trades 1:1.
  permanent('Permanent — mirror every trade'),

  /// Roll positions forward instead of mirroring close-then-reopen.
  rollover('Rollover — keep positions open across mirrors');

  final String label;
  const ScalperMode(this.label);
}

enum OrderFilter {
  buyAndSell('Buy & Sell'),
  buyOnly('Buy only'),
  sellOnly('Sell only'),
  pendingOnly('Pending only');

  final String label;
  const OrderFilter(this.label);
}

/// Subset of `OrderControlSettings` exposed in the trader-facing
/// Configure Follow Advanced section. Limited to the highest-impact
/// triggers; advanced traders can edit the full set later from the
/// Slave Settings dialog (admin parity).
///
/// All values are integer points or amounts as the trading server
/// expects. Zero disables that trigger.
class FollowLimits {
  /// Close ALL orders when total profit reaches this amount.
  final int profitForAllOrder;

  /// Close ALL orders when total loss reaches this amount.
  final int lossForAllOrder;

  /// Close ALL if equity rises above this.
  final int equityUnderHigh;

  /// Close ALL if equity drops below this.
  final int equityUnderLow;

  const FollowLimits({
    this.profitForAllOrder = 0,
    this.lossForAllOrder = 0,
    this.equityUnderHigh = 0,
    this.equityUnderLow = 0,
  });

  static const empty = FollowLimits();

  bool get isEmpty =>
      profitForAllOrder == 0 &&
      lossForAllOrder == 0 &&
      equityUnderHigh == 0 &&
      equityUnderLow == 0;
}
