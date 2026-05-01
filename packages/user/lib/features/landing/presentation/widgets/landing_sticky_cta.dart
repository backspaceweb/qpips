import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Floating "Start free →" pill anchored to the bottom of the landing
/// page on mobile. Always visible while the trader scrolls; dismisses
/// the keyboard if open and routes to /signup on tap.
///
/// Hidden on desktop — there the inline hero / nav / pricing CTAs are
/// already always reachable. On mobile, hero CTAs scroll out of view
/// fast and the trader has no anchor for the primary action without
/// this.
class LandingStickyCta extends StatelessWidget {
  const LandingStickyCta({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: SafeArea(
        top: false,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryAccent.withValues(alpha: 0.32),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/signup'),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Start free',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textOnDark,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.textOnDark,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
