import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Empty-state shown for trader tabs not yet implemented.
///
/// D.5.1 fills only the Discover tab; D.5.4 fills My Follows; the
/// remaining three (Performance, Profile, Settings) are out of scope
/// for Phase D and stay placeholder until product priorities firm up.
class PlaceholderTab extends StatelessWidget {
  final String tabLabel;
  final String? whenLanding;

  const PlaceholderTab({
    super.key,
    required this.tabLabel,
    this.whenLanding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction_outlined,
              color: AppColors.primaryAccent,
              size: 56,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              '$tabLabel — coming soon',
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(
                whenLanding ??
                    'This section will land alongside the public launch. '
                        'Browse Discover for now to see how the trader '
                        'experience comes together.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
