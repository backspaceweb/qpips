/// Pricing tier for slot subscriptions.
///
/// Tier is derived from the slot quantity at purchase time, not stored
/// as a user choice. The boundaries between tiers (1–10 = Start by
/// default, 11–50 = Pro, 51+ = Premium) are operator-editable via the
/// admin Plans screen.
///
/// Per spec (2026-05-01): tier gating is marketing-only — every tier
/// gets the same product features. The differentiator is per-slot price.
enum PlanTier {
  start('start', 'Start'),
  pro('pro', 'Pro'),
  premium('premium', 'Premium');

  final String wireValue;
  final String displayLabel;
  const PlanTier(this.wireValue, this.displayLabel);

  static PlanTier fromString(String s) =>
      PlanTier.values.firstWhere(
        (t) => t.wireValue == s,
        orElse: () => throw ArgumentError('Unknown plan tier: $s'),
      );
}

/// Admin-editable per-tier configuration (slot range + base monthly
/// price). One row per tier; three rows total.
class PlanTierConfig {
  final PlanTier tier;
  final int minSlots;

  /// Null means "unbounded" — used by Premium.
  final int? maxSlots;

  /// Per-slot per-month base price in USD. Discounts apply on top
  /// (see [CommitmentDiscount]).
  final double basePricePerSlot;

  final DateTime updatedAt;

  const PlanTierConfig({
    required this.tier,
    required this.minSlots,
    this.maxSlots,
    required this.basePricePerSlot,
    required this.updatedAt,
  });

  factory PlanTierConfig.fromJson(Map<String, dynamic> json) => PlanTierConfig(
        tier: PlanTier.fromString(json['tier'] as String),
        minSlots: json['min_slots'] as int,
        maxSlots: json['max_slots'] as int?,
        basePricePerSlot: (json['base_price_per_slot'] as num).toDouble(),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  /// True when [slotCount] falls within this tier's range.
  bool contains(int slotCount) {
    if (slotCount < minSlots) return false;
    if (maxSlots != null && slotCount > maxSlots!) return false;
    return true;
  }
}

/// Admin-editable per-commitment discount percentage.
///
/// Four rows: 1 / 3 / 6 / 12 months. The 1-month row is conventionally
/// 0% (no discount for the shortest commitment) but it's just a row
/// in the table — the operator can change it.
class CommitmentDiscount {
  final int commitmentMonths;

  /// 0–100. Applied as `(1 - discount_percent / 100)` against the
  /// per-tier base price.
  final double discountPercent;

  final DateTime updatedAt;

  const CommitmentDiscount({
    required this.commitmentMonths,
    required this.discountPercent,
    required this.updatedAt,
  });

  factory CommitmentDiscount.fromJson(Map<String, dynamic> json) =>
      CommitmentDiscount(
        commitmentMonths: json['commitment_months'] as int,
        discountPercent: (json['discount_percent'] as num).toDouble(),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  /// `(1 - discount/100)` — multiply against base*qty*months for total.
  double get multiplier => 1 - (discountPercent / 100.0);
}

/// Computes the trader-facing subscription cost for a given quantity +
/// commitment. The same algorithm runs server-side in
/// `compute_subscription_cost` SQL function — keep them in sync if you
/// edit one.
///
/// Returns null when [slotCount] doesn't match any tier (e.g. 0 slots,
/// or all configs missing). Caller should treat null as "invalid input".
double? computeSubscriptionCost({
  required int slotCount,
  required int commitmentMonths,
  required List<PlanTierConfig> tierConfigs,
  required List<CommitmentDiscount> discounts,
}) {
  if (slotCount < 1) return null;
  PlanTierConfig? tier;
  for (final c in tierConfigs) {
    if (c.contains(slotCount)) {
      tier = c;
      break;
    }
  }
  if (tier == null) return null;
  final discount = discounts.firstWhere(
    (d) => d.commitmentMonths == commitmentMonths,
    orElse: () => CommitmentDiscount(
      commitmentMonths: commitmentMonths,
      discountPercent: 0,
      updatedAt: DateTime.now(),
    ),
  );
  final raw = slotCount * tier.basePricePerSlot * commitmentMonths * discount.multiplier;
  return double.parse(raw.toStringAsFixed(2));
}

/// Locates the tier matching [slotCount] across [tierConfigs]. Used by
/// the user-facing Buy Slots screen to show the live "Tier: Pro" hint.
PlanTier? tierForSlotCount(int slotCount, List<PlanTierConfig> tierConfigs) {
  for (final c in tierConfigs) {
    if (c.contains(slotCount)) return c.tier;
  }
  return null;
}
