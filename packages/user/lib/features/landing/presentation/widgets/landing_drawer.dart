import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Mobile end-drawer for the landing page.
///
/// Mirrors the desktop nav: Features / How it works / Pricing / FAQ +
/// Login + Get Started. The four section links are visual-only —
/// matches desktop nav behavior; deep-linking to scroll anchors lands
/// later. Login and Get Started route to /registration and /app.
///
/// Visually distinct from the dark hero — the drawer is white-on-white
/// because it's overlaid on the page; the dark hero gradient is
/// behind it but at lower z.
class LandingDrawer extends StatelessWidget {
  const LandingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      width: 320,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(onClose: () => Navigator.of(context).pop()),
            const Divider(height: 1, color: AppColors.surfaceBorder),
            const SizedBox(height: AppSpacing.md),
            const _SectionLink(label: 'Features'),
            const _SectionLink(label: 'How it works'),
            const _SectionLink(label: 'Pricing'),
            const _SectionLink(label: 'FAQ'),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Divider(height: 1, color: AppColors.surfaceBorder),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _LoginRow(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/login');
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    label: 'Get Started',
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/signup');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onClose;
  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Q',
              style: TextStyle(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Text(
              'QuantumPips',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 17,
                letterSpacing: -0.3,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: onClose,
            tooltip: 'Close menu',
          ),
        ],
      ),
    );
  }
}

class _SectionLink extends StatelessWidget {
  final String label;
  const _SectionLink({required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Visual-only for now — desktop nav links behave the same. Anchor
      // scrolling will be a separate small PR.
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Text(
          label,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _LoginRow extends StatelessWidget {
  final VoidCallback onTap;
  const _LoginRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Log in',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
