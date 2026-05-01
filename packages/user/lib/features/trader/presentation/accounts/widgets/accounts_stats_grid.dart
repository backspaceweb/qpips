import 'package:flutter/material.dart';
import 'package:qp_core/domain/account_ownership.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// 4-card stats grid for the Accounts page.
///
/// Per V1: Total / Active / Inactive derive from ownership rows;
/// Best Performing is N/A until ROI tracking lands. Daily comparison
/// deltas ("+10% vs yesterday") would need an historical snapshot — out
/// of scope here; we just show the absolute numbers.
class AccountsStatsGrid extends StatelessWidget {
  final List<AccountOwnership> accounts;

  const AccountsStatsGrid({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    final total = accounts.length;
    final inactive = accounts.where((a) => a.mirroringDisabled).length;
    final active = total - inactive;

    final cards = [
      _StatCard(label: 'Total Accounts', value: total.toString()),
      _StatCard(
        label: 'Active Accounts',
        value: active.toString(),
        valueColor: active > 0 ? AppColors.profit : null,
      ),
      _StatCard(
        label: 'Inactive Accounts',
        value: inactive.toString(),
        valueColor: inactive > 0 ? AppColors.warning : null,
      ),
      const _StatCard(
        label: 'Best Performing Account',
        value: 'N/A',
        sublabel: '0.00% ROI',
      ),
    ];

    final width = MediaQuery.of(context).size.width;
    final cols = width >= AppSpacing.desktopMin
        ? 4
        : (width >= AppSpacing.tabletMin ? 2 : 1);

    return _ResponsiveGrid(cols: cols, children: cards);
  }
}

class _ResponsiveGrid extends StatelessWidget {
  final int cols;
  final List<Widget> children;
  const _ResponsiveGrid({required this.cols, required this.children});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += cols) {
      final slice = children.skip(i).take(cols).toList();
      // IntrinsicHeight bounds the Row's vertical extent to the
      // tallest card; without it, stretch + SingleChildScrollView
      // gives infinite height and the page layout corrupts.
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < slice.length; j++) ...[
                if (j > 0) const SizedBox(width: AppSpacing.md),
                Expanded(child: slice[j]),
              ],
              for (var j = slice.length; j < cols; j++) ...[
                const SizedBox(width: AppSpacing.md),
                const Expanded(child: SizedBox.shrink()),
              ],
            ],
          ),
        ),
      );
      if (i + cols < children.length) {
        rows.add(const SizedBox(height: AppSpacing.md));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? sublabel;
  final Color? valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    this.sublabel,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.numericMedium.copyWith(
              fontSize: 28,
              color: valueColor ?? AppColors.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (sublabel != null) ...[
            const SizedBox(height: 4),
            Text(
              sublabel!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
