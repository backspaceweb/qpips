import 'package:flutter/material.dart';
import 'package:qp_core/domain/master_listing.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Pill row that flips the active [TimeWindow] for the profile page.
/// Same look as the FilterStrip's window pills on Discover; kept as a
/// separate widget here so the profile can scope its own state.
class ProfileWindowTabs extends StatelessWidget {
  final TimeWindow window;
  final ValueChanged<TimeWindow> onChanged;

  const ProfileWindowTabs({
    super.key,
    required this.window,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        for (final w in TimeWindow.values)
          _Pill(
            label: w.label,
            active: w == window,
            onTap: () => onChanged(w),
          ),
      ],
    );
  }
}

class _Pill extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<_Pill> createState() => _PillState();
}

class _PillState extends State<_Pill> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final bg = active
        ? AppColors.primary
        : (_hovering ? AppColors.surfaceMuted : AppColors.surface);
    final fg = active ? AppColors.textOnDark : AppColors.textPrimary;
    final border = active ? AppColors.primary : AppColors.surfaceBorder;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              widget.label,
              style: AppTypography.labelMedium.copyWith(
                color: fg,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
