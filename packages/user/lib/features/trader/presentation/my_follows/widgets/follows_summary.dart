import 'package:flutter/material.dart';
import 'package:qp_core/domain/active_follow.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Compact metric strip above the follow list.
///
/// Shows aggregate state across all of the trader's active follows:
/// total active follows, combined open P&L (live), today's realised
/// P&L, total open trades. Stacks 4 → 2 cols at the tablet breakpoint
/// and 2 → 1 col on phone.
///
/// Equivalent of the admin dashboard's metric cards, reframed for the
/// trader's perspective ("how am I doing across everything I'm
/// following?").
class FollowsSummary extends StatelessWidget {
  final List<ActiveFollow> follows;

  const FollowsSummary({super.key, required this.follows});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = width >= AppSpacing.desktopMin
        ? 4
        : (width >= AppSpacing.tabletMin ? 2 : 1);

    final totalOpenPnl = follows.fold<double>(0, (a, f) => a + f.openPnl);
    final totalTodayPnl = follows.fold<double>(0, (a, f) => a + f.todayPnl);
    final totalOpenTrades =
        follows.fold<int>(0, (a, f) => a + f.openTradesCount);
    final totalEquity = follows.fold<double>(0, (a, f) => a + f.slaveEquity);

    final cards = <_Card>[
      _Card(
        label: 'Active follows',
        value: follows.length.toString(),
      ),
      _Card(
        label: 'Open P&L',
        value: _money(totalOpenPnl),
        valueColor: _pnlColor(totalOpenPnl),
      ),
      _Card(
        label: 'Today P&L',
        value: _money(totalTodayPnl),
        valueColor: _pnlColor(totalTodayPnl),
      ),
      _Card(
        label: 'Equity / Open',
        value:
            '\$${totalEquity.toStringAsFixed(2)} · $totalOpenTrades trade'
            '${totalOpenTrades == 1 ? '' : 's'}',
      ),
    ];

    return _Grid(cols: cols, children: cards);
  }
}

class _Grid extends StatelessWidget {
  final int cols;
  final List<Widget> children;
  const _Grid({required this.cols, required this.children});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += cols) {
      final slice = children.skip(i).take(cols).toList();
      rows.add(
        Row(
          children: [
            for (var j = 0; j < slice.length; j++) ...[
              if (j > 0) const SizedBox(width: AppSpacing.md),
              Expanded(child: slice[j]),
            ],
            // Pad short final rows so the cards stay the same width as
            // the wider rows above them.
            for (var j = slice.length; j < cols; j++) ...[
              const SizedBox(width: AppSpacing.md),
              const Expanded(child: SizedBox.shrink()),
            ],
          ],
        ),
      );
      if (i + cols < children.length) {
        rows.add(const SizedBox(height: AppSpacing.md));
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }
}

class _Card extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Card({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

Color _pnlColor(double v) {
  if (v > 0.005) return AppColors.profit;
  if (v < -0.005) return AppColors.loss;
  return AppColors.textPrimary;
}

String _money(double v) {
  final sign = v < 0 ? '-' : (v > 0 ? '+' : '');
  return '$sign\$${v.abs().toStringAsFixed(2)}';
}
