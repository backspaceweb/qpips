import 'package:flutter/material.dart';
import 'package:qp_core/domain/account_ownership.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Slot-usage progress bar + Add Account button.
///
/// Shown in the Accounts page header. The progress bar fill colour
/// shifts at thresholds: green-ish below 75%, amber 75–99%, red at 100%.
/// The Add Account button is disabled when [SlotUsage.exhausted] is
/// true; tapping it opens the registration dialog.
class SlotIndicator extends StatelessWidget {
  final SlotUsage usage;
  final VoidCallback onAddPressed;

  const SlotIndicator({
    super.key,
    required this.usage,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (usage.fraction * 100).round();
    final barColor = _colorFor(usage.fraction);
    final canAdd = !usage.exhausted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                child: LinearProgressIndicator(
                  value: usage.fraction,
                  backgroundColor: AppColors.surfaceMuted,
                  valueColor: AlwaysStoppedAnimation(barColor),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              '$pct%',
              style: AppTypography.titleMedium.copyWith(
                fontSize: 13,
                color: barColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            ElevatedButton.icon(
              onPressed: canAdd ? onAddPressed : null,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.textOnDark,
                disabledBackgroundColor:
                    AppColors.primaryAccent.withValues(alpha: 0.4),
                disabledForegroundColor:
                    AppColors.textOnDark.withValues(alpha: 0.7),
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
        const SizedBox(height: 6),
        Text(
          '${usage.used} of ${usage.quota} slots used'
          '${usage.exhausted && usage.quota > 0 ? ' · buy more from Plans' : ''}'
          '${usage.quota == 0 ? ' · buy slots from Plans first' : ''}',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Color _colorFor(double f) {
    if (f >= 1.0) return AppColors.loss;
    if (f >= 0.75) return AppColors.warning;
    return AppColors.profit;
  }
}
