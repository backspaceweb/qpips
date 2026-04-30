import 'package:flutter/material.dart';
import 'package:qp_core/domain/master_listing.dart';
import 'package:qp_core/repositories/signal_directory_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Top filter bar for the Discover screen.
///
/// Three controls in one strip:
///   - search input (left, flex)
///   - sort dropdown (right of search)
///   - time-window pills (1W / 1M / 3M / 1Y) below or beside depending
///     on width.
///
/// All emit through callbacks; the parent screen owns state. Keeping
/// the widget stateless makes it cheap to rebuild on every keystroke.
class FilterStrip extends StatelessWidget {
  final TimeWindow window;
  final ValueChanged<TimeWindow> onWindowChanged;
  final String search;
  final ValueChanged<String> onSearchChanged;
  final DirectorySort sort;
  final ValueChanged<DirectorySort> onSortChanged;

  const FilterStrip({
    super.key,
    required this.window,
    required this.onWindowChanged,
    required this.search,
    required this.onSearchChanged,
    required this.sort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final compact = width < AppSpacing.tabletMin;

    final searchField = SizedBox(
      height: 40,
      child: TextField(
        onChanged: onSearchChanged,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search providers',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 18,
            color: AppColors.textMuted,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 0,
          ),
          filled: true,
          fillColor: AppColors.surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.surfaceBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(
              color: AppColors.primaryAccent,
              width: 1.5,
            ),
          ),
        ),
      ),
    );

    final sortMenu = _SortMenu(
      sort: sort,
      onChanged: onSortChanged,
    );

    final windowPills = _WindowPills(
      window: window,
      onChanged: onWindowChanged,
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          searchField,
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: windowPills),
              const SizedBox(width: AppSpacing.md),
              sortMenu,
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        SizedBox(width: 280, child: searchField),
        const SizedBox(width: AppSpacing.lg),
        windowPills,
        const Spacer(),
        sortMenu,
      ],
    );
  }
}

class _WindowPills extends StatelessWidget {
  final TimeWindow window;
  final ValueChanged<TimeWindow> onChanged;

  const _WindowPills({required this.window, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final w in TimeWindow.values)
            _WindowPill(
              label: w.label,
              active: w == window,
              onTap: () => onChanged(w),
            ),
        ],
      ),
    );
  }
}

class _WindowPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _WindowPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Material(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 6,
            ),
            child: Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: active
                    ? AppColors.textOnDark
                    : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SortMenu extends StatelessWidget {
  final DirectorySort sort;
  final ValueChanged<DirectorySort> onChanged;

  const _SortMenu({required this.sort, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: PopupMenuButton<DirectorySort>(
        offset: const Offset(0, 44),
        tooltip: 'Sort by',
        position: PopupMenuPosition.under,
        onSelected: onChanged,
        itemBuilder: (_) => [
          for (final s in DirectorySort.values)
            PopupMenuItem(
              value: s,
              child: Row(
                children: [
                  Icon(
                    s == sort
                        ? Icons.check
                        : Icons.radio_button_unchecked,
                    size: 14,
                    color: s == sort
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(s.label, style: AppTypography.bodyMedium),
                ],
              ),
            ),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sort.label,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
