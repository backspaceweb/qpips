import 'package:flutter/material.dart';
import '../../../../design/app_colors.dart';
import '../../../../design/app_spacing.dart';
import '../../../../design/app_typography.dart';
import '../../../../design/widgets/eyebrow.dart';
import '../../../../design/widgets/fade_in_on_scroll.dart';
import '../../../../design/widgets/section_container.dart';

/// Stats counter row — quantified trust signal.
///
/// Dark band sandwiched between the lighter sections above and below,
/// with 4 large numeric stats. Big numbers in the brand teal accent,
/// small descriptions in muted on-dark text.
///
/// Numbers are placeholders for now; swap for real counters once
/// platform metrics are available.
class LandingStats extends StatelessWidget {
  const LandingStats({super.key});

  static const _stats = <_StatItem>[
    _StatItem(
      value: '6',
      unit: 'platforms',
      label: 'Cross-broker support',
      caption: 'MT4 · MT5 · cTrader · DxTrade · TradeLocker · MatchTrade',
    ),
    _StatItem(
      value: '~50',
      unit: 'ms',
      label: 'Average copy latency',
      caption: 'Master to slave via FIX-API backend',
    ),
    _StatItem(
      value: '24/7',
      unit: '',
      label: 'Always live',
      caption: 'No VPS required, no manual restarts',
    ),
    _StatItem(
      value: '100%',
      unit: '',
      label: 'Bank-grade auth',
      caption: 'Supabase JWT + RLS, no API keys in your bundle',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppSpacing.tabletMin;
    final isTablet = !isMobile && width < AppSpacing.desktopMin;
    // Mobile: 1 col, tablet: 2 cols, desktop: 4 cols
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    return SectionContainer(
      backgroundColor: AppColors.surfaceDark,
      child: Column(
        children: [
          const FadeInOnScroll(
            child: Eyebrow('By the numbers', onDark: true),
          ),
          const SizedBox(height: AppSpacing.lg),
          FadeInOnScroll(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'Engineered for traders who care\nabout the details.',
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.textOnDark,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            childAspectRatio: isMobile ? 3.2 : (isTablet ? 1.7 : 1.0),
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.lg,
            children: [
              for (var i = 0; i < _stats.length; i++)
                FadeInOnScroll(
                  delay: Duration(milliseconds: 150 + i * 80),
                  child: _StatCard(_stats[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String value;
  final String unit;
  final String label;
  final String caption;
  const _StatItem({
    required this.value,
    required this.unit,
    required this.label,
    required this.caption,
  });
}

class _StatCard extends StatelessWidget {
  final _StatItem item;
  const _StatCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceDarkRaised,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceDarkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.value,
                style: AppTypography.numericLarge.copyWith(
                  color: AppColors.primaryHover,
                  fontSize: 48,
                ),
              ),
              if (item.unit.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    item.unit,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primaryHover,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            item.label,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textOnDark,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.caption,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textOnDarkMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
