import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/eyebrow.dart';
import 'package:qp_design/widgets/fade_in_on_scroll.dart';
import 'package:qp_design/widgets/primary_button.dart';
import 'package:qp_design/widgets/section_container.dart';

/// Three-tier pricing section. Standard SaaS layout: Free / Pro / Elite,
/// middle card highlighted as the recommended option.
///
/// Numbers are placeholder copy — finalise with Susanto before launch.
class LandingPricing extends StatelessWidget {
  const LandingPricing({super.key});

  static const _tiers = <_Tier>[
    _Tier(
      name: 'Starter',
      tagline: 'Try the platform, no card required.',
      price: '\$0',
      pricePeriod: 'forever',
      bullets: [
        '1 slave account',
        'Follow up to 1 master',
        'All 6 broker platforms',
        'Standard copy latency',
        'Community support',
      ],
      ctaLabel: 'Start free',
      highlighted: false,
    ),
    _Tier(
      name: 'Pro',
      tagline: 'For active copy traders.',
      price: '\$29',
      pricePeriod: 'per month',
      bullets: [
        'Up to 5 slave accounts',
        'Follow up to 10 masters',
        'Priority copy latency',
        'Advanced risk controls',
        'Auto-close triggers + scalper mode',
        'Email support',
      ],
      ctaLabel: 'Upgrade to Pro',
      highlighted: true,
      badge: 'Most popular',
    ),
    _Tier(
      name: 'Elite',
      tagline: 'For prop firms and account managers.',
      price: '\$99',
      pricePeriod: 'per month',
      bullets: [
        'Unlimited slave accounts',
        'Unlimited masters',
        'Lowest-latency tier',
        'Multi-account dashboard',
        'Custom symbol-mapping packs',
        'Dedicated support',
      ],
      ctaLabel: 'Talk to sales',
      highlighted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppSpacing.desktopMin;

    return SectionContainer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          const FadeInOnScroll(child: Eyebrow('Pricing')),
          const SizedBox(height: AppSpacing.lg),
          FadeInOnScroll(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'Simple, predictable pricing.',
              style: AppTypography.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FadeInOnScroll(
            delay: const Duration(milliseconds: 150),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                'Pick a plan that fits how many accounts you copy across. '
                'Cancel or change tiers any time.',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          if (isDesktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < _tiers.length; i++) ...[
                    Expanded(
                      child: FadeInOnScroll(
                        delay: Duration(milliseconds: 150 + i * 80),
                        child: _PricingCard(tier: _tiers[i]),
                      ),
                    ),
                    if (i < _tiers.length - 1)
                      const SizedBox(width: AppSpacing.xl),
                  ],
                ],
              ),
            )
          else
            Column(
              children: [
                for (var i = 0; i < _tiers.length; i++) ...[
                  FadeInOnScroll(
                    delay: Duration(milliseconds: 150 + i * 80),
                    child: _PricingCard(tier: _tiers[i]),
                  ),
                  if (i < _tiers.length - 1)
                    const SizedBox(height: AppSpacing.xl),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _Tier {
  final String name;
  final String tagline;
  final String price;
  final String pricePeriod;
  final List<String> bullets;
  final String ctaLabel;
  final bool highlighted;
  final String? badge;

  const _Tier({
    required this.name,
    required this.tagline,
    required this.price,
    required this.pricePeriod,
    required this.bullets,
    required this.ctaLabel,
    required this.highlighted,
    this.badge,
  });
}

class _PricingCard extends StatelessWidget {
  final _Tier tier;
  const _PricingCard({required this.tier});

  @override
  Widget build(BuildContext context) {
    final highlighted = tier.highlighted;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: highlighted
                  ? AppColors.primaryAccent
                  : AppColors.surfaceBorder,
              width: highlighted ? 2 : 1,
            ),
            boxShadow: highlighted
                ? [
                    BoxShadow(
                      color: AppColors.primaryAccent.withValues(alpha: 0.18),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tier.name, style: AppTypography.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                tier.tagline,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tier.price,
                    style: AppTypography.numericLarge.copyWith(
                      fontSize: 44,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      tier.pricePeriod,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                height: 1,
                color: AppColors.surfaceBorder,
              ),
              const SizedBox(height: AppSpacing.xl),
              for (final b in tier.bullets)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.primaryAccent,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          b,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: highlighted
                    ? PrimaryButton(
                        label: tier.ctaLabel,
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/signup'),
                      )
                    : SecondaryButton(
                        label: tier.ctaLabel,
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/signup'),
                      ),
              ),
            ],
          ),
        ),
        if (tier.badge != null)
          Positioned(
            top: -12,
            left: AppSpacing.xl,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryAccent.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                tier.badge!.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
