import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/user_subscription.dart';
import 'package:qp_core/repositories/subscription_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Admin Subscriptions tab — read-only list of every active subscription
/// across all traders. Sorted by most-recent first.
///
/// 1B is read-only here. Cancellation, manual extension, and other
/// admin-side mutations land in 1C.
class SubscriptionsTab extends StatefulWidget {
  const SubscriptionsTab({super.key});

  @override
  State<SubscriptionsTab> createState() => _SubscriptionsTabState();
}

class _SubscriptionsTabState extends State<SubscriptionsTab> {
  Future<List<UserSubscription>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<UserSubscription>> _load() {
    return context.read<SubscriptionRepository>().listAllSubscriptions();
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryAccent,
      onRefresh: () async {
        _refresh();
        await _future;
      },
      child: FutureBuilder<List<UserSubscription>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryAccent,
              ),
            );
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  "Couldn't load subscriptions: ${snap.error}",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.loss,
                  ),
                ),
              ),
            );
          }
          final subs = snap.data ?? const <UserSubscription>[];
          if (subs.isEmpty) {
            return _emptyState();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.xl),
            itemCount: subs.length + 1,
            separatorBuilder: (_, __) => const SizedBox.shrink(),
            itemBuilder: (_, i) {
              if (i == 0) return const _Header();
              return _SubscriptionRow(sub: subs[i - 1]);
            },
          );
        },
      ),
    );
  }

  Widget _emptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      children: [
        const SizedBox(height: AppSpacing.x4),
        const Icon(
          Icons.confirmation_number_outlined,
          color: AppColors.textMuted,
          size: 48,
        ),
        const SizedBox(height: AppSpacing.md),
        Center(child: Text('No subscriptions yet', style: AppTypography.titleLarge)),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Text(
            'When traders fund their wallet and buy slots, '
            'subscriptions appear here.',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        children: [
          for (final entry in const [
            ('USER', 4),
            ('TIER', 2),
            ('SLOTS', 2),
            ('COMMIT', 2),
            ('STARTED', 3),
            ('EXPIRES', 3),
            ('STATUS', 2),
            ('AUTO-RENEW', 2),
          ])
            Expanded(
              flex: entry.$2,
              child: Text(
                entry.$1,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SubscriptionRow extends StatelessWidget {
  final UserSubscription sub;
  const _SubscriptionRow({required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          left: const BorderSide(color: AppColors.surfaceBorder),
          right: const BorderSide(color: AppColors.surfaceBorder),
          bottom: const BorderSide(color: AppColors.surfaceBorder),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              sub.userId,
              style: AppTypography.bodySmall.copyWith(
                fontFamily: AppTypography.monoFontFamily,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              sub.tier.displayLabel,
              style: AppTypography.titleMedium.copyWith(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              sub.slotCount.toString(),
              style: AppTypography.bodyMedium.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${sub.commitmentMonths}mo',
              style: AppTypography.bodyMedium,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _formatDate(sub.startedAt),
              style: AppTypography.bodySmall,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _formatDate(sub.expiresAt),
              style: AppTypography.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: _StatusChip(status: sub.status),
          ),
          Expanded(
            flex: 2,
            child: Text(
              sub.autoRenew ? 'On' : 'Off',
              style: AppTypography.bodySmall.copyWith(
                color: sub.autoRenew
                    ? AppColors.profit
                    : AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
  }
}

class _StatusChip extends StatelessWidget {
  final SubscriptionStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      SubscriptionStatus.active => (AppColors.profit, 'ACTIVE'),
      SubscriptionStatus.expired => (AppColors.textMuted, 'EXPIRED'),
      SubscriptionStatus.cancelled => (AppColors.warning, 'CANCELLED'),
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: color,
            fontSize: 9,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}
