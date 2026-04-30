import 'account.dart';

/// Public directory listing for a Master account.
///
/// What a trader sees on the Signal Discovery card grid: identity,
/// performance summary, risk profile, and a small sparkline. The deeper
/// equity-curve / activity / stats data lives on [ProviderProfile].
///
/// Today this is populated by the mock repository in qp_core; Phase E
/// swaps in a Supabase-backed implementation that joins
/// `master_listings` (public flag + display metadata) with the trading
/// server's account state.
class MasterListing {
  /// Stable identifier — maps to the trading-server account ID. Stored as
  /// String so forward-compat with non-numeric IDs is free.
  final String id;

  /// Marketing-facing display name (e.g. "Aurora Gold Trend"). NEVER the
  /// broker login number — that stays operator-internal.
  final String displayName;

  /// Optional remote avatar. When null the UI renders an initials chip
  /// derived from [displayName].
  final String? avatarUrl;

  /// One-line bio shown on the discovery card and profile header.
  final String tagline;

  final Platform platform;

  /// Display-only broker name ("Exness", "IC Markets"). Not used for
  /// routing — the trading server identifies brokers by other means.
  final String broker;

  /// Total followers across all slaves currently bound to this master.
  final int followers;

  final ProviderTier tier;

  /// Total gain over the currently selected [TimeWindow], expressed as a
  /// fraction (0.05 == +5%). Matches the value rendered as the card hero.
  final double gainFraction;

  /// Worst peak-to-trough drawdown over the selected window, as a
  /// negative fraction (-0.12 == -12%).
  final double drawdownFraction;

  final RiskScore riskScore;

  /// Tiny equity curve (~16 points) used for the card sparkline. Values
  /// are normalised — no absolute meaning, only shape matters.
  final List<double> sparkline;

  final String currency;

  /// Minimum slave deposit recommended to follow this provider. Used as
  /// a soft warning on the Configure Follow step, not a hard gate.
  final double minDeposit;

  final DateTime tradingSince;

  const MasterListing({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    required this.tagline,
    required this.platform,
    required this.broker,
    required this.followers,
    required this.tier,
    required this.gainFraction,
    required this.drawdownFraction,
    required this.riskScore,
    required this.sparkline,
    required this.currency,
    required this.minDeposit,
    required this.tradingSince,
  });
}

/// Gamification tier shown as a small badge on cards. Visual-only;
/// Phase E may derive it from objective criteria (gain consistency,
/// drawdown ceiling, time on platform) or operate as a curator
/// designation.
enum ProviderTier { bronze, silver, gold, diamond }

/// Coarse risk bucket. Computed from drawdown + position sizing
/// volatility. Mock data assigns a constant per provider.
enum RiskScore { low, medium, high }

/// Performance window selectable on the discovery filter strip.
/// `Duration` is overkill — keep enum so the filter tabs are exhaustive.
enum TimeWindow {
  week('1W', Duration(days: 7)),
  month('1M', Duration(days: 30)),
  quarter('3M', Duration(days: 90)),
  year('1Y', Duration(days: 365));

  final String label;
  final Duration duration;
  const TimeWindow(this.label, this.duration);
}
