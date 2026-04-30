import 'package:flutter/material.dart';
import '../../../../design/app_colors.dart';
import '../../../../design/app_spacing.dart';
import '../../../../design/app_typography.dart';

/// Public landing-page footer.
///
/// Dark band with brand wordmark + tagline + store badges on one side,
/// sitemap columns on the other. Bottom strip carries copyright +
/// social.
///
/// Store badges are visual placeholders pointing at `#` until the
/// mobile apps ship in D.8.
class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppSpacing.desktopMin;
    final isMobile = width < AppSpacing.tabletMin;

    final horizontalPadding = isMobile
        ? AppSpacing.lg
        : (isDesktop ? AppSpacing.x3 : AppSpacing.xxl);

    return Container(
      width: double.infinity,
      color: AppColors.surfaceDark,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: AppSpacing.x4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: const _BrandColumn()),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(flex: 6, child: const _SitemapRow()),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _BrandColumn(),
                      SizedBox(height: AppSpacing.x3),
                      _SitemapRow(),
                    ],
                  ),
                const SizedBox(height: AppSpacing.x3),
                Container(
                  height: 1,
                  color: AppColors.surfaceDarkBorder,
                ),
                const SizedBox(height: AppSpacing.xl),
                const _BottomStrip(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandColumn extends StatelessWidget {
  const _BrandColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Q',
                style: TextStyle(
                  color: AppColors.textOnDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Text(
              'QuantumPips',
              style: TextStyle(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.w700,
                fontSize: 19,
                letterSpacing: -0.3,
                fontFamily: AppTypography.fontFamily,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            'Cross-broker copy trading for retail traders, prop firms, '
            'and account managers. Six platforms, one dashboard.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textOnDarkMuted,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const _StoreBadges(),
      ],
    );
  }
}

class _StoreBadges extends StatelessWidget {
  const _StoreBadges();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: const [
        _StoreBadge(
          topLine: 'Download on the',
          bottomLine: 'App Store',
          icon: Icons.apple,
        ),
        _StoreBadge(
          topLine: 'GET IT ON',
          bottomLine: 'Google Play',
          icon: Icons.shop,
        ),
      ],
    );
  }
}

class _StoreBadge extends StatefulWidget {
  final String topLine;
  final String bottomLine;
  final IconData icon;
  const _StoreBadge({
    required this.topLine,
    required this.bottomLine,
    required this.icon,
  });

  @override
  State<_StoreBadge> createState() => _StoreBadgeState();
}

class _StoreBadgeState extends State<_StoreBadge> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: _hovering
                ? AppColors.surfaceDarkRaised
                : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: _hovering
                  ? AppColors.textOnDark.withValues(alpha: 0.4)
                  : AppColors.surfaceDarkBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: AppColors.textOnDark, size: 26),
              const SizedBox(width: AppSpacing.md),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.topLine.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textOnDarkMuted,
                      fontSize: 9,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.bottomLine,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textOnDark,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SitemapRow extends StatelessWidget {
  const _SitemapRow();

  static const _columns = <_SitemapColumn>[
    _SitemapColumn(
      title: 'Product',
      links: ['Features', 'Pricing', 'How it works', 'Roadmap'],
    ),
    _SitemapColumn(
      title: 'Resources',
      links: ['Documentation', 'API reference', 'Blog', 'Status'],
    ),
    _SitemapColumn(
      title: 'Company',
      links: ['About', 'Careers', 'Contact', 'Press'],
    ),
    _SitemapColumn(
      title: 'Legal',
      links: ['Terms', 'Privacy', 'Cookies', 'Risk disclosure'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppSpacing.tabletMin;
    final crossAxisCount = isMobile ? 2 : 4;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: AppSpacing.xl,
      mainAxisSpacing: AppSpacing.x3,
      childAspectRatio: 1.2,
      children: [for (final c in _columns) _SitemapColumnWidget(c)],
    );
  }
}

class _SitemapColumn {
  final String title;
  final List<String> links;
  const _SitemapColumn({required this.title, required this.links});
}

class _SitemapColumnWidget extends StatelessWidget {
  final _SitemapColumn column;
  const _SitemapColumnWidget(this.column);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          column.title.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final link in column.links)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _FooterLink(link),
          ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  const _FooterLink(this.label);

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTypography.bodyMedium.copyWith(
            color: _hovering
                ? AppColors.textOnDark
                : AppColors.textOnDarkMuted,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _BottomStrip extends StatelessWidget {
  const _BottomStrip();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < AppSpacing.tabletMin;

    final copyright = Text(
      '© 2026 QuantumPips. All rights reserved.',
      style: AppTypography.bodySmall.copyWith(
        color: AppColors.textOnDarkMuted,
      ),
    );

    final social = Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _SocialIcon(Icons.alternate_email, label: 'X / Twitter'),
        SizedBox(width: AppSpacing.md),
        _SocialIcon(Icons.chat_bubble_outline, label: 'Discord'),
        SizedBox(width: AppSpacing.md),
        _SocialIcon(Icons.play_circle_outline, label: 'YouTube'),
        SizedBox(width: AppSpacing.md),
        _SocialIcon(Icons.send, label: 'Telegram'),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          social,
          const SizedBox(height: AppSpacing.md),
          copyright,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        copyright,
        const Spacer(),
        social,
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  const _SocialIcon(this.icon, {required this.label});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: () {},
        child: Tooltip(
          message: widget.label,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _hovering
                  ? AppColors.surfaceDarkRaised
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(color: AppColors.surfaceDarkBorder),
            ),
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: 16,
              color: _hovering
                  ? AppColors.textOnDark
                  : AppColors.textOnDarkMuted,
            ),
          ),
        ),
      ),
    );
  }
}
