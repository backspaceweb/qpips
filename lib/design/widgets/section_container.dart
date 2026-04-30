import 'package:flutter/material.dart';
import '../app_spacing.dart';

/// Wraps a section's content in a centered, max-width column with
/// consistent vertical padding and responsive horizontal margins.
///
/// All landing-page sections compose with this so the rhythm and content
/// width stay identical regardless of screen size.
class SectionContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? customPadding;
  final double? maxWidth;

  const SectionContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.customPadding,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppSpacing.tabletMin;
    final isTablet =
        width >= AppSpacing.tabletMin && width < AppSpacing.desktopMin;

    final horizontalPadding = isMobile
        ? AppSpacing.lg
        : isTablet
            ? AppSpacing.xxl
            : AppSpacing.x3;
    final verticalPadding = isMobile ? AppSpacing.x3 : AppSpacing.x5;

    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: customPadding ??
          EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? AppSpacing.maxContentWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}
