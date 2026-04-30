import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'widgets/landing_drawer.dart';
import 'widgets/landing_faq.dart';
import 'widgets/landing_features.dart';
import 'widgets/landing_footer.dart';
import 'widgets/landing_hero.dart';
import 'widgets/landing_how_it_works.dart';
import 'widgets/landing_nav_bar.dart';
import 'widgets/landing_pricing.dart';
import 'widgets/landing_stats.dart';
import 'widgets/landing_sticky_cta.dart';
import 'widgets/landing_trust_strip.dart';

/// Public landing page. Composes nav + hero + sections in order.
///
/// Sections, in scroll order:
///   1. Dark gradient header  → nav + hero
///   2. Trust strip           → 6 supported platforms
///   3. How it works          → 3 numbered steps
///   4. Features              → 3 alternating blocks (DISCOVER / COPY / MANAGE)
///   5. Stats                 → quantified trust counter row (dark band)
///   6. Pricing               → 3 tiers (Starter / Pro / Elite)
///   7. FAQ                   → accordion
///   8. Footer                → sitemap + store badges + social
///
/// Mobile chrome (D.6): Scaffold.endDrawer wires the nav-bar hamburger
/// to a slide-in drawer; a sticky bottom CTA pill stays visible while
/// scrolling. Both render only at < tabletMin.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppSpacing.tabletMin;

    return Scaffold(
      backgroundColor: AppColors.surface,
      endDrawer: const LandingDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            // Add bottom padding on mobile so the sticky CTA never
            // covers the footer's last row.
            padding: EdgeInsets.only(bottom: isMobile ? 76 : 0),
            child: Column(
              children: const [
                _DarkHeader(),
                LandingTrustStrip(),
                LandingHowItWorks(),
                LandingFeatures(),
                LandingStats(),
                LandingPricing(),
                LandingFaq(),
                LandingFooter(),
              ],
            ),
          ),
          if (isMobile)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LandingStickyCta(),
            ),
        ],
      ),
    );
  }
}

class _DarkHeader extends StatelessWidget {
  const _DarkHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.heroBackground),
      child: const Column(
        children: [
          LandingNavBar(),
          LandingHero(),
        ],
      ),
    );
  }
}
