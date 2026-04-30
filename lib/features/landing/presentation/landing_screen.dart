import 'package:flutter/material.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_spacing.dart';
import '../../../design/app_typography.dart';
import '../../../design/widgets/eyebrow.dart';
import '../../../design/widgets/fade_in_on_scroll.dart';
import '../../../design/widgets/section_container.dart';
import 'widgets/landing_features.dart';
import 'widgets/landing_hero.dart';
import 'widgets/landing_how_it_works.dart';
import 'widgets/landing_nav_bar.dart';
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
///   6. (Coming in D.3)       → Pricing · FAQ · Footer
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
            _NextSectionsPlaceholder(),
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

class _NextSectionsPlaceholder extends StatelessWidget {
  const _NextSectionsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      backgroundColor: AppColors.surface,
      child: const FadeInOnScroll(
        child: Column(
          children: [
            Eyebrow('Coming next'),
            SizedBox(height: AppSpacing.md),
            Text(
              'Pricing · FAQ · Footer',
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
