import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/eyebrow.dart';
import 'package:qp_design/widgets/fade_in_on_scroll.dart';
import 'package:qp_design/widgets/section_container.dart';

/// "How it works" — 3 numbered steps explaining the trader journey.
///
/// On desktop: 3 cards in a horizontal row with subtle connector arrows.
/// On mobile: 3 cards stacked vertically (no connectors).
class LandingHowItWorks extends StatelessWidget {
  const LandingHowItWorks({super.key});

  static const _steps = <_Step>[
    _Step(
      number: '01',
      icon: Icons.search,
      title: 'Browse signal providers',
      body:
          'Filter by 1-week, 1-month, 3-month, or 1-year performance. '
          'See gain, drawdown, risk score, and a live equity sparkline at a glance.',
    ),
    _Step(
      number: '02',
      icon: Icons.bar_chart,
      title: 'Evaluate before you commit',
      body:
          'Open a provider profile to dive into their full equity curve, '
          'symbol mix, win rate, drawdown history, and recent trades. '
          'No black boxes.',
    ),
    _Step(
      number: '03',
      icon: Icons.bolt,
      title: 'Follow with one click',
      body:
          'Pick which of your accounts copies the master, set your risk '
          'multiplier and equity protection, and let trades flow '
          'automatically across MT4, MT5, cTrader, and beyond.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= AppSpacing.desktopMin;

    return SectionContainer(
      backgroundColor: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const FadeInOnScroll(child: Eyebrow('How it works')),
          const SizedBox(height: AppSpacing.lg),
          FadeInOnScroll(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'Three steps from\ncuriosity to copying.',
              style: (isWide
                      ? AppTypography.displaySmall
                      : AppTypography.headlineLarge)
                  .copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FadeInOnScroll(
            delay: const Duration(milliseconds: 200),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppSpacing.maxNarrowContentWidth),
              child: Text(
                'No technical setup, no VPS hosting, no juggling broker '
                'platforms. QuantumPips runs in the cloud and copies trades '
                'in milliseconds — you stay in control of risk.',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _steps.length; i++) ...[
                  Expanded(
                    child: FadeInOnScroll(
                      delay: Duration(milliseconds: 300 + i * 120),
                      child: _StepCard(_steps[i]),
                    ),
                  ),
                  if (i < _steps.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: _StepConnector(),
                    ),
                ],
              ],
            )
          else
            Column(
              children: [
                for (var i = 0; i < _steps.length; i++) ...[
                  FadeInOnScroll(
                    delay: Duration(milliseconds: 200 + i * 120),
                    child: _StepCard(_steps[i]),
                  ),
                  if (i < _steps.length - 1)
                    const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _Step {
  final String number;
  final IconData icon;
  final String title;
  final String body;
  const _Step({
    required this.number,
    required this.icon,
    required this.title,
    required this.body,
  });
}

class _StepCard extends StatelessWidget {
  final _Step step;
  const _StepCard(this.step);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                alignment: Alignment.center,
                child: Icon(step.icon, color: AppColors.primary, size: 22),
              ),
              const Spacer(),
              Text(
                step.number,
                style: AppTypography.numericMedium.copyWith(
                  fontSize: 28,
                  color: AppColors.primarySoft,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(step.title, style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          Text(step.body, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Icon(
        Icons.east,
        color: AppColors.primary.withValues(alpha: 0.4),
        size: 18,
      ),
    );
  }
}
