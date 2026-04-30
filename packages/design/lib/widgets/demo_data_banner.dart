import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_spacing.dart';
import '../app_typography.dart';

/// Persistent strip shown across trader-app screens that surface mock
/// performance data. Communicates "these numbers aren't real" to anyone
/// demoing the app, without making the surface feel unfinished.
///
/// Drop it at the top of any scaffold's body before the screen content:
///
/// ```dart
/// Column(children: [const DemoDataBanner(), Expanded(child: ...)])
/// ```
///
/// Phase E removes consumers of this widget once the
/// SupabaseSignalDirectoryRepository is wired in. The widget itself can
/// stay around for staging/preview environments.
class DemoDataBanner extends StatelessWidget {
  const DemoDataBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.warning.withValues(alpha: 0.10),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.warning,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              'Demo data — provider performance shown is illustrative only.',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
