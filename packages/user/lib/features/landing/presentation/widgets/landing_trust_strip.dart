import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/eyebrow.dart';
import 'package:qp_design/widgets/fade_in_on_scroll.dart';
import 'package:qp_design/widgets/section_container.dart';

/// Trust strip with broker / platform names. Sits directly under the
/// hero. Until we have real broker logos, we render the platform names
/// as styled "logo plates" — distinctive enough to feel intentional,
/// easy to swap for SVG/image logos later.
class LandingTrustStrip extends StatelessWidget {
  const LandingTrustStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      backgroundColor: AppColors.surface,
      customPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.x3,
      ),
      child: FadeInOnScroll(
        delay: const Duration(milliseconds: 100),
        child: Column(
          children: [
            const Eyebrow('Cross-broker by design'),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Six trading platforms supported',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            const _PlatformRow(),
          ],
        ),
      ),
    );
  }
}

class _PlatformRow extends StatelessWidget {
  const _PlatformRow();

  static const _platforms = <_Platform>[
    _Platform('MT4', 'MetaTrader 4'),
    _Platform('MT5', 'MetaTrader 5'),
    _Platform('cT', 'cTrader'),
    _Platform('DX', 'DxTrade'),
    _Platform('TL', 'TradeLocker'),
    _Platform('MX', 'MatchTrade'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x4,
      runSpacing: AppSpacing.xxl,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _platforms.map((p) => _PlatformBadge(p)).toList(),
    );
  }
}

class _Platform {
  final String mark;
  final String name;
  const _Platform(this.mark, this.name);
}

class _PlatformBadge extends StatefulWidget {
  final _Platform platform;
  const _PlatformBadge(this.platform);

  @override
  State<_PlatformBadge> createState() => _PlatformBadgeState();
}

class _PlatformBadgeState extends State<_PlatformBadge> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: _hovering ? 1.0 : 0.55,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.platform.mark,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              widget.platform.name,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
