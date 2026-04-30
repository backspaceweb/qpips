import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

import 'pricing_tab.dart';
import 'subscriptions_tab.dart';

/// Admin "Plans" screen — pricing config + active subscriptions list.
///
/// Two tabs:
///   - **Pricing:** edit per-tier slot ranges + base prices + per-
///     commitment discount percentages. RPCs gate writes to admin.
///   - **Subscriptions:** read-only list of every trader's active
///     subscription (tier, slots, commitment, expires, status).
class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.surfaceMuted,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          title: Text('Plans', style: AppTypography.headlineSmall),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          bottom: TabBar(
            labelColor: AppColors.primaryAccent,
            indicatorColor: AppColors.primaryAccent,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: AppTypography.titleMedium.copyWith(fontSize: 14),
            unselectedLabelStyle: AppTypography.bodyMedium.copyWith(
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'Pricing'),
              Tab(text: 'Subscriptions'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PricingTab(),
            SubscriptionsTab(),
          ],
        ),
      ),
    );
  }
}

/// Shared section card for the Plans screen.
class PlansSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const PlansSectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleLarge),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle!, style: AppTypography.bodySmall),
          ],
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}
