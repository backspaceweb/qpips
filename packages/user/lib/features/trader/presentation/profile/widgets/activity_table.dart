import 'package:flutter/material.dart';
import 'package:qp_core/domain/provider_profile.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Recent trading activity table.
///
/// Columns: Symbol · Direction · Lots · Opened · Closed · P&L.
/// Open positions render with a "Live" pill in place of close-time and
/// dashes in P&L. P&L is colored profit/loss.
///
/// Sorted with open positions first, then most recent close.
///
/// On mobile (< tabletMin) we render a compact card list instead of a
/// horizontal-scroll table — narrow viewports can't honour 6 columns
/// without a degraded experience.
class ActivityTable extends StatelessWidget {
  final List<TradingActivity> activity;

  const ActivityTable({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    if (activity.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Text(
            'No recent activity in this window.',
            style: AppTypography.bodySmall,
          ),
        ),
      );
    }
    final sorted = [...activity]..sort((a, b) {
        if (a.isOpen != b.isOpen) return a.isOpen ? -1 : 1;
        final aTime = a.closeTime ?? a.openTime;
        final bTime = b.closeTime ?? b.openTime;
        return bTime.compareTo(aTime);
      });

    final width = MediaQuery.of(context).size.width;
    if (width < AppSpacing.tabletMin) {
      return Column(
        children: [
          for (var i = 0; i < sorted.length; i++) ...[
            _ActivityCardMobile(activity: sorted[i]),
            if (i != sorted.length - 1)
              const Divider(height: 1, color: AppColors.surfaceBorder),
          ],
        ],
      );
    }
    return Column(
      children: [
        const _HeaderRow(),
        const Divider(height: 1, color: AppColors.surfaceBorder),
        for (var i = 0; i < sorted.length; i++) ...[
          _ActivityRow(activity: sorted[i]),
          if (i != sorted.length - 1)
            const Divider(height: 1, color: AppColors.surfaceBorder),
        ],
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: const [
          Expanded(flex: 2, child: _HeaderCell('Symbol')),
          Expanded(flex: 2, child: _HeaderCell('Side')),
          Expanded(flex: 2, child: _HeaderCell('Lots')),
          Expanded(flex: 3, child: _HeaderCell('Opened')),
          Expanded(flex: 3, child: _HeaderCell('Closed')),
          Expanded(
            flex: 2,
            child: _HeaderCell('P&L', alignRight: true),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final bool alignRight;
  const _HeaderCell(this.label, {this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTypography.labelSmall.copyWith(
        color: AppColors.textMuted,
        fontSize: 10,
      ),
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final TradingActivity activity;
  const _ActivityRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    final pnl = activity.pnl;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              activity.symbol,
              style: AppTypography.titleMedium.copyWith(
                fontSize: 13,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Expanded(flex: 2, child: _SideChip(direction: activity.direction)),
          Expanded(
            flex: 2,
            child: Text(
              activity.lots.toStringAsFixed(2),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _formatDateTime(activity.openTime),
              style: AppTypography.bodySmall,
            ),
          ),
          Expanded(
            flex: 3,
            child: activity.isOpen
                ? const _LivePill()
                : Text(
                    _formatDateTime(activity.closeTime!),
                    style: AppTypography.bodySmall,
                  ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              pnl == null ? '—' : _money(pnl),
              textAlign: TextAlign.right,
              style: AppTypography.titleMedium.copyWith(
                fontSize: 13,
                color: pnl == null
                    ? AppColors.textMuted
                    : (pnl >= 0 ? AppColors.profit : AppColors.loss),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCardMobile extends StatelessWidget {
  final TradingActivity activity;
  const _ActivityCardMobile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final pnl = activity.pnl;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                activity.symbol,
                style: AppTypography.titleMedium.copyWith(fontSize: 14),
              ),
              const SizedBox(width: AppSpacing.sm),
              _SideChip(direction: activity.direction),
              const Spacer(),
              Text(
                pnl == null ? '—' : _money(pnl),
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 14,
                  color: pnl == null
                      ? AppColors.textMuted
                      : (pnl >= 0 ? AppColors.profit : AppColors.loss),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${activity.lots.toStringAsFixed(2)} lots · '
                '${_formatDateTime(activity.openTime)}',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(width: AppSpacing.sm),
              if (activity.isOpen)
                const _LivePill()
              else
                Text(
                  '→ ${_formatDateTime(activity.closeTime!)}',
                  style: AppTypography.bodySmall,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SideChip extends StatelessWidget {
  final TradeDirection direction;
  const _SideChip({required this.direction});

  @override
  Widget build(BuildContext context) {
    final isBuy = direction == TradeDirection.buy;
    final color = isBuy ? AppColors.profit : AppColors.loss;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(
          isBuy ? 'BUY' : 'SELL',
          style: AppTypography.labelSmall.copyWith(
            color: color,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _LivePill extends StatelessWidget {
  const _LivePill();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: AppColors.primaryAccent.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryAccent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Live',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontSize: 10,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime dt) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${_monthShort(dt.month)} ${two(dt.day)} '
      '${two(dt.hour)}:${two(dt.minute)}';
}

String _monthShort(int m) => const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][m - 1];

String _money(double v) {
  final sign = v < 0 ? '-' : '+';
  return '$sign\$${v.abs().toStringAsFixed(2)}';
}
