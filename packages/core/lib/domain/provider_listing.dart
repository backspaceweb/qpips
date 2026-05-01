import 'master_listing.dart' show ProviderTier, RiskScore;

/// One row in `provider_listings`. Represents a trader's *application*
/// for one of their master accounts to appear on the public Discover
/// surface, plus the operator-curated metadata that's set on approval.
///
/// Distinct from [MasterListing] (the public-facing display model used
/// by the directory cards): this entity carries the workflow state
/// (status, audit fields) and the trader-supplied bio. The directory
/// repository joins this with `account_ownership` to build the
/// presentation [MasterListing] for status='approved' rows.
class ProviderListing {
  final String id;
  final int masterAccountId;
  final String ownerUserId;
  final ProviderListingStatus status;

  /// Trader-supplied
  final String displayName;
  final String? bio;
  final double? minDeposit;
  final String currency;

  /// Operator-set on approval (null until approved)
  final ProviderTier? tier;
  final RiskScore? riskScore;

  /// Snapshot performance numbers set by operator on approval. Live-from-
  /// trades reconciliation is a follow-up slice — for v1 these are
  /// manually maintained.
  final double? gainPct;
  final double? drawdownPct;
  final int followersCount;

  /// Audit
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? rejectionReason;

  const ProviderListing({
    required this.id,
    required this.masterAccountId,
    required this.ownerUserId,
    required this.status,
    required this.displayName,
    this.bio,
    this.minDeposit,
    required this.currency,
    this.tier,
    this.riskScore,
    this.gainPct,
    this.drawdownPct,
    required this.followersCount,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.rejectionReason,
  });

  factory ProviderListing.fromJson(Map<String, dynamic> json) =>
      ProviderListing(
        id: json['id'] as String,
        masterAccountId: (json['master_account_id'] as num).toInt(),
        ownerUserId: json['owner_user_id'] as String,
        status: ProviderListingStatus.parse(json['status'] as String),
        displayName: json['display_name'] as String? ?? '',
        bio: json['bio'] as String?,
        minDeposit: (json['min_deposit'] as num?)?.toDouble(),
        currency: json['currency'] as String? ?? 'USD',
        tier: _parseTier(json['tier'] as String?),
        riskScore: _parseRisk(json['risk_score'] as String?),
        gainPct: (json['gain_pct'] as num?)?.toDouble(),
        drawdownPct: (json['drawdown_pct'] as num?)?.toDouble(),
        followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
        submittedAt: DateTime.parse(json['submitted_at'] as String),
        reviewedAt: json['reviewed_at'] == null
            ? null
            : DateTime.parse(json['reviewed_at'] as String),
        reviewedBy: json['reviewed_by'] as String?,
        rejectionReason: json['rejection_reason'] as String?,
      );

  static ProviderTier? _parseTier(String? raw) {
    if (raw == null) return null;
    return ProviderTier.values.firstWhere(
      (t) => t.name == raw,
      orElse: () => ProviderTier.bronze,
    );
  }

  static RiskScore? _parseRisk(String? raw) {
    if (raw == null) return null;
    return RiskScore.values.firstWhere(
      (r) => r.name == raw,
      orElse: () => RiskScore.medium,
    );
  }
}

enum ProviderListingStatus {
  pending,
  approved,
  rejected;

  static ProviderListingStatus parse(String raw) {
    return ProviderListingStatus.values.firstWhere(
      (s) => s.name == raw,
      orElse: () => ProviderListingStatus.pending,
    );
  }

  String get label => switch (this) {
        ProviderListingStatus.pending => 'PENDING',
        ProviderListingStatus.approved => 'APPROVED',
        ProviderListingStatus.rejected => 'REJECTED',
      };
}
