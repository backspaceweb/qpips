import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Top nav for the public landing page.
///
/// Transparent over the gradient hero. On desktop: logo + nav links +
/// Login / Get Started. On mobile: logo + hamburger.
class LandingNavBar extends StatelessWidget {
  const LandingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < AppSpacing.desktopMin;

    final horizontalPadding = isCompact ? AppSpacing.lg : AppSpacing.x3;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: AppSpacing.lg,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Row(
            children: [
              const _Wordmark(),
              const Spacer(),
              if (!isCompact) ...const [
                _NavLink('Features'),
                SizedBox(width: AppSpacing.xxl),
                _NavLink('How it works'),
                SizedBox(width: AppSpacing.xxl),
                _NavLink('Pricing'),
                SizedBox(width: AppSpacing.xxl),
                _NavLink('FAQ'),
                SizedBox(width: AppSpacing.x3),
              ],
              if (!isCompact) ...[
                _LoginLink(
                  onTap: () =>
                      Navigator.of(context).pushNamed('/registration'),
                ),
                const SizedBox(width: AppSpacing.lg),
                PrimaryButton(
                  label: 'Get Started',
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/app'),
                ),
              ] else
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.textOnDark),
                  onPressed: () {},
                  tooltip: 'Menu',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
        const Text(
          'QuantumPips',
          style: TextStyle(
            color: AppColors.textOnDark,
            fontWeight: FontWeight.w700,
            fontSize: 19,
            letterSpacing: -0.3,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  const _NavLink(this.label);

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 150),
        style: AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w500,
          color: _hovering
              ? AppColors.textOnDark
              : AppColors.textOnDarkMuted,
        ),
        child: Text(widget.label),
      ),
    );
  }
}

class _LoginLink extends StatefulWidget {
  final VoidCallback onTap;
  const _LoginLink({required this.onTap});

  @override
  State<_LoginLink> createState() => _LoginLinkState();
}

class _LoginLinkState extends State<_LoginLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w500,
            color:
                _hovering ? AppColors.textOnDark : AppColors.textOnDarkMuted,
          ),
          child: const Text('Login'),
        ),
      ),
    );
  }
}
