import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_typography.dart';

/// Small-caps "eyebrow" tag that sits above section headlines.
///
/// E.g. `CONNECT · COPY · ANALYZE · FOLLOW` over a hero. Distinctive
/// enough to feel intentional, restrained enough to not steal focus.
class Eyebrow extends StatelessWidget {
  final String text;
  final bool onDark;
  final Color? customColor;

  const Eyebrow(
    this.text, {
    super.key,
    this.onDark = false,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = customColor ??
        (onDark ? AppColors.primaryHover : AppColors.primaryAccent);
    return Text(
      text.toUpperCase(),
      style: AppTypography.labelSmall.copyWith(color: color),
    );
  }
}
