import 'plan_tier.dart';

/// One slot-purchase row. A user may have multiple active subscriptions
/// (each with its own slot count, commitment length, and expiry); their
/// total purchased capacity = sum of `slot_count` for active rows.
///
/// Renewals (1C) do NOT lock the original price — at renewal time the
/// row is recharged at the *current* admin pricing for the row's
/// (tier, commitment_months) cell. So this class records `total_paid`
/// historically (audit), but the next charge may differ.
class UserSubscription {
  final String id;
  final String userId;
  final PlanTier tier;
  final int slotCount;
  final int commitmentMonths;

  /// What was actually charged at purchase time. Audit only — does not
  /// drive renewal pricing.
  final double totalPaid;

  final DateTime startedAt;
  final DateTime expiresAt;
  final SubscriptionStatus status;
  final bool autoRenew;

  const UserSubscription({
    required this.id,
    required this.userId,
    required this.tier,
    required this.slotCount,
    required this.commitmentMonths,
    required this.totalPaid,
    required this.startedAt,
    required this.expiresAt,
    required this.status,
    required this.autoRenew,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) => UserSubscription(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        tier: PlanTier.fromString(json['tier'] as String),
        slotCount: json['slot_count'] as int,
        commitmentMonths: json['commitment_months'] as int,
        totalPaid: (json['total_paid'] as num).toDouble(),
        startedAt: DateTime.parse(json['started_at'] as String),
        expiresAt: DateTime.parse(json['expires_at'] as String),
        status: SubscriptionStatus.fromString(json['status'] as String),
        autoRenew: json['auto_renew'] as bool,
      );

  bool get isActive => status == SubscriptionStatus.active;
}

enum SubscriptionStatus {
  active('active'),
  expired('expired'),
  cancelled('cancelled');

  final String wireValue;
  const SubscriptionStatus(this.wireValue);

  static SubscriptionStatus fromString(String s) =>
      SubscriptionStatus.values.firstWhere(
        (t) => t.wireValue == s,
        orElse: () => throw ArgumentError('Unknown status: $s'),
      );
}

/// Result returned by `book_slots` RPC.
class BookSlotsResult {
  final String subscriptionId;
  final double totalPaid;
  final DateTime expiresAt;
  final double newWalletBalance;

  const BookSlotsResult({
    required this.subscriptionId,
    required this.totalPaid,
    required this.expiresAt,
    required this.newWalletBalance,
  });
}
