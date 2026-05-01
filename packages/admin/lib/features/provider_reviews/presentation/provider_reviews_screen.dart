import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/provider_listing.dart';
import 'package:qp_core/repositories/provider_listing_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'widgets/approve_dialog.dart';
import 'widgets/reject_dialog.dart';

/// Admin queue for reviewing trader applications to appear on the
/// public Discover surface. Shows pending applications by default;
/// segmented control flips between PENDING / APPROVED / REJECTED.
///
/// Each card joins the listing with its master account_ownership row
/// (broker login + platform) and the applicant's profile.display_name
/// — admin can SELECT all three via existing RLS policies.
class ProviderReviewsScreen extends StatefulWidget {
  const ProviderReviewsScreen({super.key});

  @override
  State<ProviderReviewsScreen> createState() => _ProviderReviewsScreenState();
}

class _ProviderReviewsScreenState extends State<ProviderReviewsScreen> {
  ProviderListingStatus _filter = ProviderListingStatus.pending;
  Future<List<EnrichedListing>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<EnrichedListing>> _load() async {
    final repo = context.read<ProviderListingRepository>();
    final supabase = Supabase.instance.client;
    final listings = await repo.listAllByStatus(_filter);
    if (listings.isEmpty) return [];

    final masterIds = listings.map((l) => l.masterAccountId).toList();
    final ownerIds = listings.map((l) => l.ownerUserId).toSet().toList();

    final accounts = await supabase
        .from('account_ownership')
        .select('trading_account_id, login_number, platform, account_type')
        .inFilter('trading_account_id', masterIds);
    final profiles = await supabase
        .from('profiles')
        .select('user_id, display_name')
        .inFilter('user_id', ownerIds);

    final accountByMaster = {
      for (final r in (accounts as List))
        (r as Map<String, dynamic>)['trading_account_id'] as int: r,
    };
    final profileByUser = {
      for (final r in (profiles as List))
        (r as Map<String, dynamic>)['user_id'] as String: r,
    };

    return [
      for (final l in listings)
        EnrichedListing(
          listing: l,
          account: accountByMaster[l.masterAccountId],
          profile: profileByUser[l.ownerUserId],
        ),
    ];
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  void _setFilter(ProviderListingStatus s) {
    setState(() {
      _filter = s;
      _future = _load();
    });
  }

  Future<void> _openApprove(EnrichedListing item) async {
    final approved = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => ApproveDialog(item: item),
    );
    if (approved == true) _refresh();
  }

  Future<void> _openReject(EnrichedListing item) async {
    final rejected = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => RejectDialog(item: item),
    );
    if (rejected == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      appBar: AppBar(
        title: const Text('Provider Reviews'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(filter: _filter, onChanged: _setFilter),
            const SizedBox(height: AppSpacing.lg),
            FutureBuilder<List<EnrichedListing>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.x3),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  );
                }
                if (snap.hasError) {
                  return _ErrorBlock(
                    message: snap.error.toString(),
                    onRetry: _refresh,
                  );
                }
                final items = snap.data ?? const [];
                if (items.isEmpty) {
                  return _EmptyState(filter: _filter);
                }
                return Column(
                  children: [
                    for (final item in items)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.lg,
                        ),
                        child: _ApplicationCard(
                          item: item,
                          onApprove: () => _openApprove(item),
                          onReject: () => _openReject(item),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EnrichedListing {
  final ProviderListing listing;
  final Map<String, dynamic>? account;
  final Map<String, dynamic>? profile;
  const EnrichedListing({
    required this.listing,
    required this.account,
    required this.profile,
  });

  String get loginNumber => account?['login_number']?.toString() ?? '—';
  String get platform => account?['platform']?.toString().toUpperCase() ?? '—';
  String get applicantName =>
      profile?['display_name']?.toString() ?? listing.ownerUserId;
}

class _Header extends StatelessWidget {
  final ProviderListingStatus filter;
  final ValueChanged<ProviderListingStatus> onChanged;
  const _Header({required this.filter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Provider applications', style: AppTypography.headlineLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Approve trader applications to make their master accounts '
          'visible on the public Discover surface.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        SegmentedButton<ProviderListingStatus>(
          segments: const [
            ButtonSegment(
              value: ProviderListingStatus.pending,
              label: Text('Pending'),
              icon: Icon(Icons.hourglass_empty),
            ),
            ButtonSegment(
              value: ProviderListingStatus.approved,
              label: Text('Approved'),
              icon: Icon(Icons.verified),
            ),
            ButtonSegment(
              value: ProviderListingStatus.rejected,
              label: Text('Rejected'),
              icon: Icon(Icons.cancel_outlined),
            ),
          ],
          selected: {filter},
          onSelectionChanged: (s) => onChanged(s.first),
        ),
      ],
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final EnrichedListing item;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  const _ApplicationCard({
    required this.item,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final l = item.listing;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.displayName, style: AppTypography.titleLarge),
                    const SizedBox(height: 2),
                    Text(
                      'Applicant: ${item.applicantName}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              _StatusChip(status: l.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              _Field('Master serverId', l.masterAccountId.toString()),
              _Field('Broker login', item.loginNumber),
              _Field('Platform', item.platform),
              _Field('Min deposit',
                  l.minDeposit == null ? '—' : '${l.minDeposit} ${l.currency}'),
              _Field('Submitted', _ymd(l.submittedAt)),
            ],
          ),
          if (l.bio?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Text(l.bio!, style: AppTypography.bodyMedium),
            ),
          ],
          if (l.status == ProviderListingStatus.rejected &&
              l.rejectionReason?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.loss.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Text(
                'Rejection reason: ${l.rejectionReason!}',
                style: AppTypography.bodySmall.copyWith(color: AppColors.loss),
              ),
            ),
          ],
          if (l.status == ProviderListingStatus.approved) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: [
                _Field('Tier', l.tier?.name.toUpperCase() ?? '—'),
                _Field('Risk', l.riskScore?.name.toUpperCase() ?? '—'),
                _Field(
                  'Gain',
                  l.gainPct == null
                      ? '—'
                      : '${(l.gainPct! * 100).toStringAsFixed(2)}%',
                ),
                _Field(
                  'Drawdown',
                  l.drawdownPct == null
                      ? '—'
                      : '${(l.drawdownPct! * 100).toStringAsFixed(2)}%',
                ),
                _Field('Followers', l.followersCount.toString()),
              ],
            ),
          ],
          if (l.status == ProviderListingStatus.pending) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('Reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.loss,
                  ),
                  onPressed: onReject,
                ),
                const SizedBox(width: AppSpacing.md),
                PrimaryButton(label: 'Approve', onPressed: onApprove),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  const _Field(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.bodyMedium.copyWith(fontSize: 13)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ProviderListingStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ProviderListingStatus.pending => AppColors.warning,
      ProviderListingStatus.approved => AppColors.profit,
      ProviderListingStatus.rejected => AppColors.loss,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        status.label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ProviderListingStatus filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: [
          Icon(
            switch (filter) {
              ProviderListingStatus.pending => Icons.inbox_outlined,
              ProviderListingStatus.approved => Icons.verified,
              ProviderListingStatus.rejected => Icons.cancel_outlined,
            },
            color: AppColors.textMuted,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No ${filter.label.toLowerCase()} applications',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBlock({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.loss.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.loss, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(color: AppColors.loss),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
