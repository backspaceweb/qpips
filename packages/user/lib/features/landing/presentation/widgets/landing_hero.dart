import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/eyebrow.dart';
import 'package:qp_design/widgets/fade_in_on_scroll.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Hero section. Eyebrow tag · headline · subhead · CTA pair · device
/// mockup pane. On wide screens: text left, mockup right. On compact:
/// stacked, mockup below text.
class LandingHero extends StatelessWidget {
  const LandingHero({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= AppSpacing.desktopMin;
    final isMobile = width < AppSpacing.tabletMin;

    final horizontalPadding =
        isMobile ? AppSpacing.lg : isWide ? AppSpacing.x3 : AppSpacing.xxl;
    final verticalPadding = isMobile ? AppSpacing.x4 : AppSpacing.x6;

    final text = const _HeroText();
    final visual = const _HeroVisual();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: text),
                    const SizedBox(width: AppSpacing.x4),
                    Expanded(flex: 6, child: visual),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text,
                    const SizedBox(height: AppSpacing.x3),
                    visual,
                  ],
                ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= AppSpacing.desktopMin;
    final isMobile = width < AppSpacing.tabletMin;

    final headlineStyle = (isMobile
            ? AppTypography.displaySmall
            : isWide
                ? AppTypography.displayLarge
                : AppTypography.displayMedium)
        .copyWith(color: AppColors.textOnDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FadeInOnScroll(
          delay: Duration(milliseconds: 50),
          child: Eyebrow('Discover · Follow · Earn', onDark: true),
        ),
        const SizedBox(height: AppSpacing.lg),
        FadeInOnScroll(
          delay: const Duration(milliseconds: 150),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Copy proven traders.\n'),
                TextSpan(
                  text: 'Trade smarter,',
                  style: headlineStyle.copyWith(color: AppColors.primaryHover),
                ),
                const TextSpan(text: ' from\nday one.'),
              ],
            ),
            style: headlineStyle,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeInOnScroll(
          delay: const Duration(milliseconds: 250),
          child: Text(
            'Browse a marketplace of verified signal providers, evaluate '
            'their real performance, and follow with one click. '
            'Cross-broker support across MT4, MT5, cTrader, DxTrade, '
            'TradeLocker, and MatchTrade.',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textOnDarkMuted,
              fontSize: isMobile ? 15 : 17,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        FadeInOnScroll(
          delay: const Duration(milliseconds: 350),
          child: Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.md,
            children: [
              PrimaryButton(
                label: 'Get Started Free',
                large: !isMobile,
                icon: Icons.arrow_forward,
                onPressed: () =>
                    Navigator.of(context).pushNamed('/app'),
              ),
              SecondaryButton(
                label: 'See how it works',
                large: !isMobile,
                onDark: true,
                onPressed: () {
                  // TODO: smooth-scroll to "How it works" section once it exists
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const FadeInOnScroll(
          delay: Duration(milliseconds: 450),
          child: _HeroBadgeRow(),
        ),
      ],
    );
  }
}

class _HeroBadgeRow extends StatelessWidget {
  const _HeroBadgeRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xxl,
      runSpacing: AppSpacing.md,
      children: const [
        _HeroBadge(icon: Icons.shield_outlined, label: 'Bank-grade security'),
        _HeroBadge(icon: Icons.flash_on_outlined, label: '50ms copy speed'),
        _HeroBadge(icon: Icons.public_outlined, label: '6 platforms supported'),
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primaryHover, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textOnDarkMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Stylized "device mockup" hero visual.
///
/// We don't ship real product screenshots yet, so this is a custom
/// composition that conveys "data + chart + provider card" while staying
/// professional. Easy to swap for real screenshots later.
class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    return FadeInOnScroll(
      delay: const Duration(milliseconds: 350),
      duration: const Duration(milliseconds: 800),
      startOffsetY: 32,
      child: AspectRatio(
        aspectRatio: 5 / 4,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Soft glow behind the mockup
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryHover.withValues(alpha: 0.30),
                        Colors.transparent,
                      ],
                      radius: 0.85,
                    ),
                  ),
                ),
              ),
            ),
            // Main "screen" card
            Positioned.fill(
              child: _MockupCard(),
            ),
            // Floating provider chip (top-right)
            const Positioned(
              top: 16,
              right: -12,
              child: _ProviderChip(),
            ),
            // Floating performance chip (bottom-left)
            const Positioned(
              bottom: 24,
              left: -16,
              child: _PerformanceChip(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDarkRaised,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.surfaceDarkBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 40,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Window chrome
          Row(
            children: [
              for (final color in [
                Colors.redAccent,
                Colors.orangeAccent,
                AppColors.primaryHover,
              ]) ...[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline,
                        size: 12,
                        color: AppColors.textOnDarkMuted
                            .withValues(alpha: 0.7)),
                    const SizedBox(width: 6),
                    Text(
                      'app.quantumpips.com',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textOnDarkMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const SizedBox(width: 30 * 3 + 24),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // Header row
          Row(
            children: [
              const _StatPill(label: 'Equity', value: '\$24,560', delta: '+12.4%'),
              const SizedBox(width: AppSpacing.md),
              const _StatPill(
                  label: 'Active Follows', value: '3', delta: 'Online'),
              const SizedBox(width: AppSpacing.md),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 6),
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
                    Text(
                      'Live',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.profit,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // Sparkline area
          const Expanded(child: _SparklinePanel()),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final String delta;
  const _StatPill({required this.label, required this.value, required this.delta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.surfaceDarkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textOnDarkMuted,
              fontSize: 11,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.titleMedium
                .copyWith(color: AppColors.textOnDark, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            delta,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.profit,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePanel extends StatelessWidget {
  const _SparklinePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceDarkBorder),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Equity vs Balance',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textOnDark,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              for (final label in ['1W', '1M', '3M', '1Y'])
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: label == '1M'
                          ? AppColors.primaryAccent.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      label,
                      style: AppTypography.labelSmall.copyWith(
                        color: label == '1M'
                            ? AppColors.primaryHover
                            : AppColors.textOnDarkMuted,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: CustomPaint(
              painter: _SparklinePainter(),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Equity line (green) — generally up
    final equityPath = Path();
    final pts = [
      0.10,
      0.20,
      0.18,
      0.30,
      0.42,
      0.38,
      0.55,
      0.62,
      0.58,
      0.72,
      0.85,
      0.78,
      0.92,
    ];
    for (var i = 0; i < pts.length; i++) {
      final x = (i / (pts.length - 1)) * size.width;
      final y = size.height - pts[i] * size.height * 0.85;
      if (i == 0) {
        equityPath.moveTo(x, y);
      } else {
        equityPath.lineTo(x, y);
      }
    }
    final equityPaint = Paint()
      ..color = AppColors.primaryHover
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Filled gradient under the equity line
    final fillPath = Path.from(equityPath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryHover.withValues(alpha: 0.35),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(equityPath, equityPaint);

    // Balance line (more muted, slightly different shape)
    final balPath = Path();
    final balPts = [
      0.12,
      0.18,
      0.20,
      0.25,
      0.32,
      0.35,
      0.45,
      0.50,
      0.55,
      0.60,
      0.66,
      0.70,
      0.75,
    ];
    for (var i = 0; i < balPts.length; i++) {
      final x = (i / (balPts.length - 1)) * size.width;
      final y = size.height - balPts[i] * size.height * 0.85;
      if (i == 0) {
        balPath.moveTo(x, y);
      } else {
        balPath.lineTo(x, y);
      }
    }
    canvas.drawPath(
      balPath,
      Paint()
        ..color = AppColors.textOnDarkMuted.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ProviderChip extends StatelessWidget {
  const _ProviderChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'YT',
              style: TextStyle(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('yoo trader',
                  style: AppTypography.titleMedium.copyWith(fontSize: 13)),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.trending_up,
                      size: 11, color: AppColors.profit),
                  const SizedBox(width: 4),
                  Text(
                    '+96.55% · 91 followers',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerformanceChip extends StatelessWidget {
  const _PerformanceChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.profit.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.bolt, color: AppColors.profit, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Trade copied',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'BTCUSD · +\$2.64',
                style: AppTypography.titleMedium.copyWith(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
