import 'package:flutter/material.dart';
import 'package:qp_core/domain/provider_profile.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Two-column key/value list of provider performance stats.
///
/// Each row has a tooltip-bearing `?` chip explaining the metric — most
/// traders know "win rate" but profit factor / avg hold time / streaks
/// reward a one-line gloss. Tooltips render as default Material tooltips
/// so they work on hover (web) and long-press (mobile).
class StatsTable extends StatelessWidget {
  final ProviderStats stats;

  const StatsTable({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final rows = <_Row>[
      _Row(
        label: 'Total trades',
        value: stats.totalTrades.toString(),
        explanation:
            'Trades closed across the selected window. Open positions '
            'are not counted here.',
      ),
      _Row(
        label: 'Win rate',
        value: '${(stats.winRate * 100).toStringAsFixed(1)}%',
        valueColor: stats.winRate >= 0.5 ? AppColors.profit : AppColors.loss,
        explanation:
            'Share of trades that closed profitably. A high win rate '
            "doesn't guarantee profitability — pair with profit factor.",
      ),
      _Row(
        label: 'Profit factor',
        value: stats.profitFactor.toStringAsFixed(2),
        valueColor:
            stats.profitFactor >= 1 ? AppColors.profit : AppColors.loss,
        explanation:
            'Gross profit divided by gross loss. > 1.0 means a provider '
            "earns more than they lose. > 1.5 is healthy; < 1 is "
            'losing money.',
      ),
      _Row(
        label: 'Avg win',
        value: _money(stats.avgWin),
        valueColor: AppColors.profit,
        explanation: 'Average P&L per winning trade.',
      ),
      _Row(
        label: 'Avg loss',
        value: _money(stats.avgLoss),
        valueColor: AppColors.loss,
        explanation: 'Average P&L per losing trade.',
      ),
      _Row(
        label: 'Avg hold time',
        value: _holdTime(stats.avgHoldTime),
        explanation:
            'Average time a position is open. Short = scalper / '
            'intraday; long = swing / position trader.',
      ),
      _Row(
        label: 'Max win streak',
        value: stats.maxWinStreak.toString(),
        explanation: 'Longest consecutive run of winning trades.',
      ),
      _Row(
        label: 'Max loss streak',
        value: stats.maxLossStreak.toString(),
        explanation:
            'Longest consecutive run of losing trades. A high number '
            'with otherwise-good stats can signal high variance.',
      ),
    ];
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          rows[i],
          if (i != rows.length - 1)
            const Divider(
              height: 1,
              color: AppColors.surfaceBorder,
            ),
        ],
      ],
    );
  }

  String _money(double v) {
    final sign = v < 0 ? '-' : '';
    return '$sign\$${v.abs().toStringAsFixed(2)}';
  }

  String _holdTime(Duration d) {
    if (d.inDays >= 1) return '${d.inDays}d';
    if (d.inHours >= 1) {
      final m = d.inMinutes.remainder(60);
      return '${d.inHours}h ${m.toString().padLeft(2, '0')}m';
    }
    return '${d.inMinutes}m';
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final String explanation;

  const _Row({
    required this.label,
    required this.value,
    required this.explanation,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Tooltip(
                  message: explanation,
                  preferBelow: false,
                  textStyle: AppTypography.bodySmall.copyWith(
                    color: AppColors.textOnDark,
                    height: 1.4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '?',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: AppTypography.titleMedium.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontSize: 14,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
