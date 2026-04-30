import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Donut chart + symbol legend showing how a provider distributes their
/// trade volume.
///
/// The donut is hand-painted (no chart package). Legend lists each
/// symbol with its colour swatch + percent. Slices use a fixed teal-tone
/// palette so the chart stays on-brand even when symbol counts change
/// across providers.
class SymbolDistribution extends StatelessWidget {
  final Map<String, double> distribution;

  const SymbolDistribution({super.key, required this.distribution});

  static const _palette = <Color>[
    Color(0xFF1A8B6B), // primaryAccent
    Color(0xFF22A37D), // primaryHover
    Color(0xFF4FA8C9), // diamond / accent blue
    Color(0xFFC9A227), // gold
    Color(0xFF8C99A1), // silver
    Color(0xFFB87333), // bronze
  ];

  @override
  Widget build(BuildContext context) {
    if (distribution.isEmpty) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text(
            'No trades in this window.',
            style: AppTypography.bodySmall,
          ),
        ),
      );
    }
    final entries = distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final colors = <String, Color>{
      for (var i = 0; i < entries.length; i++)
        entries[i].key: _palette[i % _palette.length],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _DonutPainter(entries: entries, colors: colors),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${entries.length}',
                      style: AppTypography.numericMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                      ),
                    ),
                    Text(
                      'symbols',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _LegendRow(
              symbol: e.key,
              fraction: e.value,
              color: colors[e.key]!,
            ),
          ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  final String symbol;
  final double fraction;
  final Color color;

  const _LegendRow({
    required this.symbol,
    required this.fraction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            symbol,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          '${(fraction * 100).toStringAsFixed(1)}%',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<MapEntry<String, double>> entries;
  final Map<String, Color> colors;

  _DonutPainter({required this.entries, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final ringWidth = size.shortestSide * 0.18;
    final inner = rect.deflate(ringWidth);
    var start = -math.pi / 2;
    const gap = 0.02;
    for (final e in entries) {
      final sweep = e.value * math.pi * 2 - gap;
      if (sweep <= 0) continue;
      final paint = Paint()
        ..color = colors[e.key]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = ringWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(inner, start, sweep, false, paint);
      start += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.entries != entries || old.colors != colors;
}
