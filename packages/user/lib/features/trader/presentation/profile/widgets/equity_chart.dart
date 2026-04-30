import 'package:flutter/material.dart';
import 'package:qp_core/domain/provider_profile.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Equity vs Balance line chart — the centerpiece of the Provider
/// Profile.
///
/// Two overlapping lines:
///   - Balance: realised P&L only. Drawn first, in blue.
///   - Equity: includes open-position P&L. Drawn on top, in trade green
///     so the eye lands on it. Filled underneath with a soft tint.
///
/// Markers are drawn at any [EquityPoint.depositChange] != null (deposit
/// = up triangle, withdrawal = down triangle).
///
/// Y-axis: 4 horizontal grid rules with currency labels at the right
/// edge. X-axis: 4 date ticks at quarter-points along the timeline.
///
/// Pure Flutter painting — no chart package — to keep the user app's
/// web bundle small. ~7KB.
class EquityChart extends StatelessWidget {
  final List<EquityPoint> points;
  final String currency;

  const EquityChart({
    super.key,
    required this.points,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return SizedBox(
        height: 280,
        child: Center(
          child: Text(
            'Not enough data to chart this window.',
            style: AppTypography.bodySmall,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Legend(),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 280,
          child: CustomPaint(
            size: Size.infinite,
            painter: _EquityChartPainter(
              points: points,
              currency: currency,
            ),
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: const [
        _LegendDot(color: AppColors.profit, label: 'Equity'),
        _LegendDot(color: AppColors.info, label: 'Balance'),
        _LegendMarker(color: AppColors.profit, label: 'Deposit'),
        _LegendMarker(color: AppColors.warning, label: 'Withdrawal'),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}

class _LegendMarker extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendMarker({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CustomPaint(
            painter: _TrianglePainter(color: color, pointsUp: label == 'Deposit'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final bool pointsUp;
  const _TrianglePainter({required this.color, required this.pointsUp});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    if (pointsUp) {
      p.moveTo(size.width / 2, 0);
      p.lineTo(size.width, size.height);
      p.lineTo(0, size.height);
    } else {
      p.moveTo(0, 0);
      p.lineTo(size.width, 0);
      p.lineTo(size.width / 2, size.height);
    }
    p.close();
    canvas.drawPath(p, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) =>
      old.color != color || old.pointsUp != pointsUp;
}

class _EquityChartPainter extends CustomPainter {
  final List<EquityPoint> points;
  final String currency;

  _EquityChartPainter({required this.points, required this.currency});

  static const _leftPad = 8.0;
  static const _rightPad = 56.0; // room for Y-axis labels
  static const _topPad = 8.0;
  static const _bottomPad = 28.0; // room for X-axis labels

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTRB(
      _leftPad,
      _topPad,
      size.width - _rightPad,
      size.height - _bottomPad,
    );

    // Compute Y range using the union of equity + balance.
    var lo = double.infinity;
    var hi = -double.infinity;
    for (final p in points) {
      if (p.equity < lo) lo = p.equity;
      if (p.equity > hi) hi = p.equity;
      if (p.balance < lo) lo = p.balance;
      if (p.balance > hi) hi = p.balance;
    }
    // Pad the range a touch so lines don't kiss the edges.
    final pad = (hi - lo) * 0.08;
    lo -= pad;
    hi += pad;
    if ((hi - lo).abs() < 1e-6) {
      lo -= 1;
      hi += 1;
    }

    _drawGrid(canvas, plot, lo, hi);

    // Balance (blue) — drawn first so equity sits on top.
    _drawLine(
      canvas,
      plot,
      lo,
      hi,
      values: points.map((p) => p.balance).toList(),
      color: AppColors.info,
      strokeWidth: 1.6,
    );

    // Equity (green) — fill + line.
    _drawLine(
      canvas,
      plot,
      lo,
      hi,
      values: points.map((p) => p.equity).toList(),
      color: AppColors.profit,
      strokeWidth: 2.2,
      fill: true,
    );

    // Deposit / withdrawal markers.
    for (var i = 0; i < points.length; i++) {
      final delta = points[i].depositChange;
      if (delta == null) continue;
      final x = plot.left + (i / (points.length - 1)) * plot.width;
      final y = plot.bottom -
          ((points[i].equity - lo) / (hi - lo)) * plot.height;
      _drawMarker(
        canvas,
        Offset(x, y),
        deposit: delta > 0,
      );
    }

    _drawXAxisLabels(canvas, plot);
  }

  void _drawGrid(Canvas canvas, Rect plot, double lo, double hi) {
    final gridPaint = Paint()
      ..color = AppColors.surfaceBorder
      ..strokeWidth = 1;
    final labelStyle = AppTypography.bodySmall.copyWith(
      color: AppColors.textMuted,
      fontSize: 11,
    );
    const rules = 4;
    for (var i = 0; i <= rules; i++) {
      final t = i / rules;
      final y = plot.bottom - t * plot.height;
      canvas.drawLine(
        Offset(plot.left, y),
        Offset(plot.right, y),
        gridPaint,
      );
      final value = lo + t * (hi - lo);
      final tp = TextPainter(
        text: TextSpan(text: _shortMoney(value), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(plot.right + 6, y - tp.height / 2));
    }
  }

  void _drawLine(
    Canvas canvas,
    Rect plot,
    double lo,
    double hi, {
    required List<double> values,
    required Color color,
    required double strokeWidth,
    bool fill = false,
  }) {
    final path = Path();
    final fillPath = Path();
    for (var i = 0; i < values.length; i++) {
      final x = plot.left + (i / (values.length - 1)) * plot.width;
      final y = plot.bottom - ((values[i] - lo) / (hi - lo)) * plot.height;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, plot.bottom);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    if (fill) {
      fillPath.lineTo(plot.right, plot.bottom);
      fillPath.close();
      canvas.drawPath(
        fillPath,
        Paint()..color = color.withValues(alpha: 0.10),
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawMarker(Canvas canvas, Offset c, {required bool deposit}) {
    final color = deposit ? AppColors.profit : AppColors.warning;
    const size = 8.0;
    final p = Path();
    if (deposit) {
      p.moveTo(c.dx, c.dy - size);
      p.lineTo(c.dx + size, c.dy + size * 0.6);
      p.lineTo(c.dx - size, c.dy + size * 0.6);
    } else {
      p.moveTo(c.dx - size, c.dy - size * 0.6);
      p.lineTo(c.dx + size, c.dy - size * 0.6);
      p.lineTo(c.dx, c.dy + size);
    }
    p.close();
    // Halo for visibility against the equity line.
    canvas.drawPath(p, Paint()..color = AppColors.surface);
    canvas.drawPath(
      p,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawXAxisLabels(Canvas canvas, Rect plot) {
    final labelStyle = AppTypography.bodySmall.copyWith(
      color: AppColors.textMuted,
      fontSize: 11,
    );
    const ticks = 4;
    for (var i = 0; i <= ticks; i++) {
      final t = i / ticks;
      final idx = ((points.length - 1) * t).round();
      final date = points[idx].date;
      final label = '${_monthShort(date.month)} ${date.day}';
      final tp = TextPainter(
        text: TextSpan(text: label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = plot.left + t * plot.width - tp.width / 2;
      tp.paint(canvas, Offset(x, plot.bottom + 8));
    }
  }

  String _shortMoney(double v) {
    if (v.abs() >= 1000000) {
      return '${(v / 1000000).toStringAsFixed(2)}M';
    }
    if (v.abs() >= 1000) {
      return '${(v / 1000).toStringAsFixed(1)}k';
    }
    return v.toStringAsFixed(0);
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

  @override
  bool shouldRepaint(_EquityChartPainter old) =>
      old.points != points || old.currency != currency;
}
