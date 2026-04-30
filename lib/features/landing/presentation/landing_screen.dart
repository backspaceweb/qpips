import 'package:flutter/material.dart';
import '../../../design/app_colors.dart';
import '../../../design/app_spacing.dart';
import '../../../design/app_typography.dart';
import '../../../design/widgets/eyebrow.dart';
import '../../../design/widgets/fade_in_on_scroll.dart';
import '../../../design/widgets/section_container.dart';
import 'widgets/landing_nav_bar.dart';
import 'widgets/landing_hero.dart';
import 'widgets/landing_trust_strip.dart';

/// Public landing page. Composes nav + hero + trust strip + (more sections
/// to follow). All sections live in `widgets/` for clarity.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            // Top: dark hero region (nav + hero share the same gradient bg).
            _DarkHeader(),
            LandingTrustStrip(),
            // Stub for sections we'll add next:
            //   How it works · Features · Stats · Pricing · FAQ · Footer
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
      backgroundColor: AppColors.surfaceMuted,
      child: const FadeInOnScroll(
        child: Column(
          children: [
            Eyebrow('Coming next'),
            SizedBox(height: AppSpacing.md),
            Text(
              'How it works · Features · Stats · Pricing · FAQ · Footer',
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Hero + trust strip first. Tell me to refine before we build out below.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
