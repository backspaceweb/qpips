import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/plan_tier.dart';
import 'package:qp_core/domain/user_subscription.dart';
import 'package:qp_core/repositories/subscription_repository.dart';
import 'package:qp_core/repositories/trading_repository.dart';
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
  Future<_SubsAndCapacity>? _future;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  /// Loads subscriptions + the operator's bought-capacity in parallel.
  /// `accountLimit` comes from the trading API's getAPIInfo response —
  /// can be null if the call fails (network, expired key, etc.). Strip
  /// hides the capacity section when null rather than guessing.
  Future<_SubsAndCapacity> _load() async {
    final subRepo = context.read<SubscriptionRepository>();
    final tradingRepo = context.read<TradingRepository>();
    final results = await Future.wait([
      subRepo.listAllSubscriptions(),
      tradingRepo.getAPIInfo(),
    ]);
    final subs = results[0] as List<UserSubscription>;
    final apiInfo = results[1] as Map<String, dynamic>?;
    final raw = apiInfo == null ? null : apiInfo['accountLimit'];
    final accountLimit = raw is num ? raw.toInt() : null;
    return _SubsAndCapacity(subs: subs, accountLimit: accountLimit);
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _runRenewals() async {
    setState(() => _running = true);
    try {
      final result =
          await context.read<SubscriptionRepository>().processRenewalsNow();
      if (!mounted) return;
      _refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Renewals processed — renewed ${result.renewedCount}, '
            'expired ${result.expiredCount}.',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Couldn't run renewals: $e"),
          backgroundColor: AppColors.loss,
        ),
      );
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_SubsAndCapacity>(
      future: _future,
      builder: (context, snap) {
        final loading = snap.connectionState != ConnectionState.done;
        final subs = snap.data?.subs ?? const <UserSubscription>[];
        final accountLimit = snap.data?.accountLimit;
        final agg = _Aggregates.compute(subs);
        return Column(
          children: [
            _InventoryStrip(
              agg: agg,
              loading: loading,
              accountLimit: accountLimit,
            ),
            _renewalsBanner(),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryAccent,
                onRefresh: () async {
                  _refresh();
                  await _future;
                },
                child: _buildList(loading: loading, error: snap.error, subs: subs),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _renewalsBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.md,
      ),
      color: AppColors.surfaceMuted,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'A daily cron runs renewals at 00:00 UTC. Use the '
              'button to force a pass for testing.',
              style: AppTypography.bodySmall,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: _running ? null : _runRenewals,
            icon: _running
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textOnDark,
                    ),
                  )
                : const Icon(Icons.refresh, size: 16),
            label: const Text('Run renewals now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAccent,
              foregroundColor: AppColors.textOnDark,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList({
    required bool loading,
    required Object? error,
    required List<UserSubscription> subs,
  }) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryAccent),
      );
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            "Couldn't load subscriptions: $error",
            style: AppTypography.bodySmall.copyWith(color: AppColors.loss),
          ),
        ),
      );
    }
    if (subs.isEmpty) return _emptyState();
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemCount: subs.length + 1,
      separatorBuilder: (_, __) => const SizedBox.shrink(),
      itemBuilder: (_, i) {
        if (i == 0) return const _Header();
        return _SubscriptionRow(sub: subs[i - 1]);
      },
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

/// Combined load result: subscriptions + the operator's bought capacity
/// (accountLimit from getAPIInfo). Capacity is nullable because the
/// trading API call can fail or return an unexpected shape; the strip
/// hides the capacity row when null rather than guessing.
class _SubsAndCapacity {
  final List<UserSubscription> subs;
  final int? accountLimit;

  const _SubsAndCapacity({required this.subs, required this.accountLimit});
}

/// Client-side aggregation of all subscription rows. Computes:
///   - totalSlots / activeCount across status='active' rows only
///   - totalBooked = sum of total_paid (lifetime revenue from currently
///     active subs — does NOT include expired/cancelled)
///   - mrr = sum of total_paid / commitment_months (effective monthly
///     recurring revenue, normalised across commitment lengths)
///   - byTier = per-tier breakdown for the inventory strip
class _Aggregates {
  final int totalSlots;
  final int activeCount;
  final double totalBooked;
  final double mrr;
  final List<_TierAgg> byTier;

  const _Aggregates._({
    required this.totalSlots,
    required this.activeCount,
    required this.totalBooked,
    required this.mrr,
    required this.byTier,
  });

  factory _Aggregates.compute(List<UserSubscription> all) {
    final perTier = {
      for (final t in PlanTier.values) t: _TierAgg(t),
    };
    var totalSlots = 0;
    var activeCount = 0;
    var totalBooked = 0.0;
    var mrr = 0.0;
    for (final s in all) {
      if (!s.isActive) continue;
      activeCount++;
      totalSlots += s.slotCount;
      totalBooked += s.totalPaid;
      if (s.commitmentMonths > 0) {
        mrr += s.totalPaid / s.commitmentMonths;
      }
      final agg = perTier[s.tier]!;
      agg.count++;
      agg.slots += s.slotCount;
      agg.revenue += s.totalPaid;
      if (s.commitmentMonths > 0) {
        agg.slotMonths += s.slotCount * s.commitmentMonths;
      }
    }
    return _Aggregates._(
      totalSlots: totalSlots,
      activeCount: activeCount,
      totalBooked: totalBooked,
      mrr: mrr,
      byTier: PlanTier.values.map((t) => perTier[t]!).toList(),
    );
  }
}

class _TierAgg {
  final PlanTier tier;
  int count = 0;
  int slots = 0;
  double revenue = 0;
  int slotMonths = 0;

  _TierAgg(this.tier);

  /// Effective $/slot/month — divides lifetime revenue across the slot-
  /// months actually purchased. Useful sanity check: should fall within
  /// the tier's configured base price (after commitment discount).
  double? get effectivePerSlotMonth =>
      slotMonths == 0 ? null : revenue / slotMonths;
}

class _InventoryStrip extends StatelessWidget {
  final _Aggregates agg;
  final bool loading;

  /// Operator's bought slot capacity from the trading API team. Null
  /// when getAPIInfo failed — the capacity row hides in that case.
  final int? accountLimit;

  const _InventoryStrip({
    required this.agg,
    required this.loading,
    required this.accountLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Slot Inventory', style: AppTypography.titleLarge),
              const SizedBox(width: AppSpacing.sm),
              if (loading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryAccent,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Aggregated from active subscriptions only. Expired and '
            'cancelled rows are excluded.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _kpi('Slots Sold', agg.totalSlots.toString(),
                  Icons.confirmation_number_outlined),
              const SizedBox(width: AppSpacing.md),
              _kpi('Active Subscriptions', agg.activeCount.toString(),
                  Icons.people_outline),
              const SizedBox(width: AppSpacing.md),
              _kpi('Total Booked', _money(agg.totalBooked),
                  Icons.account_balance_wallet_outlined,
                  valueColor: AppColors.primaryAccent),
              const SizedBox(width: AppSpacing.md),
              _kpi('MRR', _money(agg.mrr), Icons.trending_up,
                  valueColor: AppColors.profit),
            ],
          ),
          if (accountLimit != null) ...[
            const SizedBox(height: AppSpacing.lg),
            _capacityBar(),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text(
            'BY TIER',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (var i = 0; i < agg.byTier.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.md),
                Expanded(child: _tierCard(agg.byTier[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _kpi(String label, String value, IconData icon, {Color? valueColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.textMuted),
                const SizedBox(width: AppSpacing.xs),
                Text(label,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    )),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTypography.headlineSmall.copyWith(
                color: valueColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Capacity utilization: how much of the operator's bought capacity
  /// (from the trading API team) has been resold to traders. Color
  /// thresholds: <70% green / 70–89% amber / ≥90% red — at red the
  /// operator should buy more capacity from the API team before more
  /// traders try to register slaves.
  Widget _capacityBar() {
    final limit = accountLimit!;
    final sold = agg.totalSlots;
    final available = (limit - sold).clamp(0, limit);
    final pct = limit == 0 ? 0.0 : (sold / limit).clamp(0.0, 1.0);
    final pctLabel = '${(pct * 100).toStringAsFixed(0)}%';
    final overSold = sold > limit;
    final color = overSold || pct >= 0.90
        ? AppColors.loss
        : pct >= 0.70
            ? AppColors.warning
            : AppColors.profit;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'CAPACITY',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Text(
                pctLabel,
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                '$sold of $limit slots sold',
                style: AppTypography.bodyMedium.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '· $available available to sell',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: AppColors.surfaceBorder,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          if (overSold) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Sold ${sold - limit} more slots than the trading API team '
              "covers — buy more capacity before any new trader registration "
              'gets blocked.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.loss),
            ),
          ] else if (pct >= 0.90) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Approaching capacity ceiling — buy more slots from the '
              'trading API team soon.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tierCard(_TierAgg t) {
    final eff = t.effectivePerSlotMonth;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(t.tier.displayLabel,
                  style: AppTypography.titleMedium.copyWith(fontSize: 14)),
              const Spacer(),
              Text(
                '${t.count} sub${t.count == 1 ? '' : 's'}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              _tierStat('${t.slots}', 'slots'),
              const SizedBox(width: AppSpacing.lg),
              _tierStat(_money(t.revenue), 'revenue'),
              const SizedBox(width: AppSpacing.lg),
              _tierStat(
                eff == null ? '—' : '\$${eff.toStringAsFixed(2)}',
                '/slot/mo',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tierStat(String value, String label) {
    return Row(
      children: [
        Text(value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            )),
        const SizedBox(width: 4),
        Text(label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            )),
      ],
    );
  }

  String _money(double v) {
    final whole = v.toStringAsFixed(2);
    return '\$$whole';
  }
}
