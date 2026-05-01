import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/eyebrow.dart';
import 'package:qp_design/widgets/fade_in_on_scroll.dart';
import 'package:qp_design/widgets/primary_button.dart';
import 'package:qp_design/widgets/section_container.dart';

/// Three alternating feature blocks (TradersConnect-style "TC COPIER /
/// TC ANALYZER" pattern, rebranded as `QP DISCOVER` / `QP COPY` /
/// `QP MANAGE`). Each block: tagged eyebrow + headline + body + bullets +
/// CTA on one side, custom illustration on the other. Sides alternate.
class LandingFeatures extends StatelessWidget {
  const LandingFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      backgroundColor: AppColors.surfaceMuted,
      child: Column(
        children: [
          const FadeInOnScroll(child: Eyebrow('Built for traders')),
          const SizedBox(height: AppSpacing.lg),
          FadeInOnScroll(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'Everything you need to copy with confidence.',
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          const _FeatureBlock(
            tag: 'QP DISCOVER',
            title: 'Find traders who match your style',
            body:
                'Browse a curated marketplace of signal providers. Sort by '
                'performance over the last week, month, quarter, or year. '
                'Every provider shows their full equity curve, drawdown '
                'history, and recent trades — no marketing fluff.',
            bullets: [
              'Time-window filters (1w / 1m / 3m / 1y)',
              'Verified performance from broker data',
              'Risk score, drawdown, and live sparkline at a glance',
            ],
            ctaLabel: 'Start exploring',
            visualSide: _VisualSide.right,
            visual: _DiscoverVisual(),
          ),
          SizedBox(height: AppSpacing.x4),
          _FeatureBlock(
            tag: 'QP COPY',
            title: 'Cross-broker copy execution',
            body:
                'Master and slave on different brokers? No problem. '
                'QuantumPips translates symbols, scales lots by your '
                'configured risk multiplier, and copies trades with '
                'sub-second latency through a FIX-API backend.',
            bullets: [
              'Six platforms: MT4, MT5, cTrader, DxTrade, TradeLocker, MatchTrade',
              'Configurable risk multiplier per slave',
              'Symbol mapping for cross-broker pairs',
            ],
            ctaLabel: 'See supported platforms',
            visualSide: _VisualSide.left,
            visual: _CopyVisual(),
          ),
          SizedBox(height: AppSpacing.x4),
          _FeatureBlock(
            tag: 'QP MANAGE',
            title: 'Stay in control of every position',
            body:
                'Per-slave settings let you tune exactly how much to copy: '
                'risk type, copy SL/TP, scalper mode, order filter. '
                'Auto-close triggers protect equity when a master draws '
                'down — your capital, your rules.',
            bullets: [
              'Risk multiplier and SL/TP copy settings',
              'Equity-protection auto-close triggers',
              'Per-order and account-wide profit/loss limits',
            ],
            ctaLabel: 'See risk controls',
            visualSide: _VisualSide.right,
            visual: _ManageVisual(),
          ),
        ],
      ),
    );
  }
}

enum _VisualSide { left, right }

class _FeatureBlock extends StatelessWidget {
  final String tag;
  final String title;
  final String body;
  final List<String> bullets;
  final String ctaLabel;
  final _VisualSide visualSide;
  final Widget visual;

  const _FeatureBlock({
    required this.tag,
    required this.title,
    required this.body,
    required this.bullets,
    required this.ctaLabel,
    required this.visualSide,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    final isWide =
        MediaQuery.of(context).size.width >= AppSpacing.desktopMin;

    final text = FadeInOnScroll(
      child: _FeatureText(
        tag: tag,
        title: title,
        body: body,
        bullets: bullets,
        ctaLabel: ctaLabel,
      ),
    );
    final visualWrapped = FadeInOnScroll(
      delay: const Duration(milliseconds: 100),
      child: visual,
    );

    if (!isWide) {
      // Mobile: visual below text always
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text,
          const SizedBox(height: AppSpacing.xxl),
          visualWrapped,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: visualSide == _VisualSide.right
          ? [
              Expanded(flex: 5, child: text),
              const SizedBox(width: AppSpacing.x4),
              Expanded(flex: 6, child: visualWrapped),
            ]
          : [
              Expanded(flex: 6, child: visualWrapped),
              const SizedBox(width: AppSpacing.x4),
              Expanded(flex: 5, child: text),
            ],
    );
  }
}

class _FeatureText extends StatelessWidget {
  final String tag;
  final String title;
  final String body;
  final List<String> bullets;
  final String ctaLabel;

  const _FeatureText({
    required this.tag,
    required this.title,
    required this.body,
    required this.bullets,
    required this.ctaLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow(tag),
        const SizedBox(height: AppSpacing.lg),
        Text(title, style: AppTypography.headlineLarge),
        const SizedBox(height: AppSpacing.lg),
        Text(body, style: AppTypography.bodyLarge),
        const SizedBox(height: AppSpacing.xl),
        for (final b in bullets)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    b,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.xl),
        SecondaryButton(
          label: ctaLabel,
          icon: Icons.arrow_forward,
          onPressed: () =>
              Navigator.of(context).pushNamed('/signup'),
        ),
      ],
    );
  }
}

// ============================================================================
//  Custom illustrations for each feature block.
//  Lightweight Flutter widgets that convey the feature visually without
//  needing screenshot assets. Easy to swap for real product captures later.
// ============================================================================

class _CardSurface extends StatelessWidget {
  final Widget child;
  const _CardSurface({required this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.surfaceBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: child,
      ),
    );
  }
}

class _DiscoverVisual extends StatelessWidget {
  const _DiscoverVisual();

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Eyebrow('Top this week'),
              const Spacer(),
              for (final tab in const ['1W', '1M', '3M', '1Y'])
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tab == '1W'
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      tab,
                      style: AppTypography.labelSmall.copyWith(
                        color: tab == '1W'
                            ? AppColors.textOnDark
                            : AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) => _ProviderRow(
                name: ['yoo trader', 'AxisTrader V1', 'Aurora Gold Trend'][i],
                gain: ['+96.55%', '+45.10%', '+38.40%'][i],
                followers: ['91', '64', '48'][i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderRow extends StatelessWidget {
  final String name;
  final String gain;
  final String followers;
  const _ProviderRow({
    required this.name,
    required this.gain,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name,
                  style: AppTypography.titleMedium.copyWith(fontSize: 14)),
              const SizedBox(height: 2),
              Text('$followers followers',
                  style: AppTypography.bodySmall.copyWith(fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        // tiny sparkline
        SizedBox(
          width: 60,
          height: 24,
          child: CustomPaint(painter: _MiniSparklinePainter()),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          gain,
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.profit,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MiniSparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pts = [0.6, 0.5, 0.55, 0.4, 0.5, 0.35, 0.3, 0.25, 0.2, 0.1];
    final path = Path();
    for (var i = 0; i < pts.length; i++) {
      final x = (i / (pts.length - 1)) * size.width;
      final y = pts[i] * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.profit
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CopyVisual extends StatelessWidget {
  const _CopyVisual();

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Trade flow'),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const _NodePill(
                  label: 'Master',
                  sub: 'MT5 · Exness',
                  primary: true,
                ),
                Expanded(
                  child: CustomPaint(
                    painter: _CopyArrowsPainter(),
                    size: Size.infinite,
                  ),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NodePill(label: 'Slave A', sub: 'MT4 · IC Markets'),
                    SizedBox(height: AppSpacing.md),
                    _NodePill(label: 'Slave B', sub: 'MT5 · Exness'),
                    SizedBox(height: AppSpacing.md),
                    _NodePill(label: 'Slave C', sub: 'cTrader · Pepperstone'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: AppColors.primary, size: 16),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Avg copy latency',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  '~50 ms',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NodePill extends StatelessWidget {
  final String label;
  final String sub;
  final bool primary;
  const _NodePill({
    required this.label,
    required this.sub,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = primary ? AppColors.primary : AppColors.surface;
    final fg = primary ? AppColors.textOnDark : AppColors.textPrimary;
    final subColor =
        primary ? AppColors.textOnDarkMuted : AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
            color: primary ? AppColors.primary : AppColors.surfaceBorder),
        boxShadow: primary
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: AppTypography.titleMedium.copyWith(
                color: fg,
                fontSize: 13,
              )),
          const SizedBox(height: 2),
          Text(sub,
              style: AppTypography.bodySmall.copyWith(
                color: subColor,
                fontSize: 10,
              )),
        ],
      ),
    );
  }
}

class _CopyArrowsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final leftX = 0.0;
    final rightX = size.width;
    final centerY = size.height / 2;
    final ys = [size.height * 0.2, centerY, size.height * 0.8];

    for (final y in ys) {
      final path = Path()
        ..moveTo(leftX, centerY)
        ..cubicTo(centerX, centerY, centerX, y, rightX - 8, y);
      canvas.drawPath(path, paint);

      // arrow head
      final arrow = Path()
        ..moveTo(rightX - 8, y)
        ..lineTo(rightX - 13, y - 4)
        ..moveTo(rightX - 8, y)
        ..lineTo(rightX - 13, y + 4);
      canvas.drawPath(arrow, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ManageVisual extends StatelessWidget {
  const _ManageVisual();

  @override
  Widget build(BuildContext context) {
    return _CardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.tune, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Text('Slave Settings',
                  style: AppTypography.titleLarge.copyWith(fontSize: 16)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.profit.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                          color: AppColors.profit, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text('Active',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.profit,
                          fontSize: 10,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Tab pills
          Row(
            children: [
              _ManageTab('Risk & Stops', selected: true),
              const SizedBox(width: AppSpacing.sm),
              _ManageTab('Order Control'),
              const SizedBox(width: AppSpacing.sm),
              _ManageTab('Symbols'),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _SettingRow(label: 'Risk Type', value: 'Auto risk'),
                SizedBox(height: AppSpacing.md),
                _SettingRow(label: 'Multiplier', value: '1.5x'),
                SizedBox(height: AppSpacing.md),
                _SettingRow(label: 'Copy SL/TP', value: 'On'),
                SizedBox(height: AppSpacing.md),
                _SettingRow(label: 'Order Filter', value: 'Buy & Sell'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ManageTab extends StatelessWidget {
  final String label;
  final bool selected;
  const _ManageTab(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: selected ? AppColors.textOnDark : AppColors.textSecondary,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String value;
  const _SettingRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
              fontSize: 13,
            )),
        const Spacer(),
        Text(value,
            style: AppTypography.titleMedium.copyWith(fontSize: 13)),
      ],
    );
  }
}
