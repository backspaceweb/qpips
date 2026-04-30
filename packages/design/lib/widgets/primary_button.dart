import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_spacing.dart';
import '../app_typography.dart';

/// Brand primary CTA. Gradient fill, soft shadow, hover lift.
///
/// Use for the hero CTA, "Get Started" buttons, primary actions on the
/// landing page. For lower-emphasis actions use [SecondaryButton].
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool large;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.large = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null || widget.isLoading;
    final h = widget.large ? 56.0 : 48.0;
    final hPad = widget.large ? AppSpacing.xxl + 4 : AppSpacing.xxl;

    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovering && !disabled ? -2 : 0, 0),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: disabled
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.primaryAccent
                            .withValues(alpha: _hovering ? 0.35 : 0.22),
                        blurRadius: _hovering ? 24 : 14,
                        offset: Offset(0, _hovering ? 10 : 6),
                      ),
                    ],
            ),
            child: InkWell(
              onTap: disabled ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Container(
                height: h,
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isLoading)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textOnDark,
                        ),
                      )
                    else ...[
                      Text(
                        widget.label,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.textOnDark,
                          fontSize: widget.large ? 16 : 15,
                        ),
                      ),
                      if (widget.icon != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Icon(widget.icon, color: AppColors.textOnDark, size: 18),
                      ],
                    ],
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

/// Secondary / outlined button. Use for "Learn more", "Watch demo", and
/// other lower-emphasis CTAs.
class SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool large;
  final bool onDark;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.large = false,
    this.onDark = false,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final h = widget.large ? 56.0 : 48.0;
    final hPad = widget.large ? AppSpacing.xxl + 4 : AppSpacing.xxl;

    final fg = widget.onDark ? AppColors.textOnDark : AppColors.textPrimary;
    final borderColor = widget.onDark
        ? AppColors.textOnDark.withValues(alpha: _hovering ? 0.5 : 0.25)
        : AppColors.surfaceBorder;
    final bg = _hovering
        ? (widget.onDark
            ? AppColors.textOnDark.withValues(alpha: 0.05)
            : AppColors.surfaceMuted)
        : Colors.transparent;

    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: h,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: borderColor),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: disabled ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label,
                    style: AppTypography.labelLarge.copyWith(
                      color: fg,
                      fontSize: widget.large ? 16 : 15,
                    ),
                  ),
                  if (widget.icon != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Icon(widget.icon, color: fg, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
