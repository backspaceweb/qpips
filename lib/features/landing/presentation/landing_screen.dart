import 'package:flutter/material.dart';
import '../../../design/app_colors.dart';
import 'widgets/landing_faq.dart';
import 'widgets/landing_features.dart';
import 'widgets/landing_footer.dart';
import 'widgets/landing_hero.dart';
import 'widgets/landing_how_it_works.dart';
import 'widgets/landing_nav_bar.dart';
import 'widgets/landing_pricing.dart';
import 'widgets/landing_stats.dart';
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
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
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
