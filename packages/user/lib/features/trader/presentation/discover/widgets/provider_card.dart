import 'package:flutter/material.dart';
import 'package:qp_core/domain/master_listing.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'sparkline_painter.dart';

/// Discovery card for a single signal provider.
///
/// Composition (top to bottom):
///   1. Avatar/initials chip + display name + tier badge
///   2. Tagline (one line, ellipsised)
///   3. Hero gain % over the selected window + small label
///   4. Sparkline preview of the equity curve
///   5. Drawdown · Risk · Followers stat row
///   6. Follow CTA — full-width, ghost-style for D.5.1
///
/// Tap target on the whole card is reserved for D.5.2 (provider
/// profile navigation). For D.5.1 the card itself is non-interactive
/// outside the Follow CTA.
class ProviderCard extends StatefulWidget {
  final MasterListing listing;
  final VoidCallback? onTap;
  final VoidCallback? onFollow;

  const ProviderCard({
    super.key,
    required this.listing,
    this.onTap,
    this.onFollow,
  });

  @override
  State<ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<ProviderCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final l = widget.listing;
    final positive = l.gainFraction >= 0;
    final gainColor = positive ? AppColors.profit : AppColors.loss;

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovering ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.surfaceBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(
                alpha: _hovering ? 0.18 : 0.10,
              ),
              blurRadius: _hovering ? 24 : 14,
              offset: Offset(0, _hovering ? 12 : 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(listing: l),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l.tagline,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${positive ? '+' : ''}'
                        '${(l.gainFraction * 100).toStringAsFixed(2)}%',
                        style: AppTypography.numericLarge.copyWith(
                          color: gainColor,
                          fontSize: 32,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          'gain',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 36,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: SparklinePainter(
                        values: l.sparkline,
                        positive: AppColors.profit,
                        negative: AppColors.loss,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _StatsRow(listing: l),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: widget.onFollow,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.primaryAccent,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: Text(
                        'Follow',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final MasterListing listing;
  const _Header({required this.listing});

  @override
  Widget build(BuildContext context) {
    final initials = _initialsOf(listing.displayName);
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textOnDark,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                listing.displayName,
                style: AppTypography.titleMedium.copyWith(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${listing.platform.name.toUpperCase()} · ${listing.broker}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _TierBadge(tier: listing.tier),
      ],
    );
  }

  String _initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

class _TierBadge extends StatelessWidget {
  final ProviderTier tier;
  const _TierBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (tier) {
      ProviderTier.bronze => (const Color(0xFFB87333), 'BRONZE'),
      ProviderTier.silver => (const Color(0xFF8C99A1), 'SILVER'),
      ProviderTier.gold => (const Color(0xFFC9A227), 'GOLD'),
      ProviderTier.diamond => (const Color(0xFF4FA8C9), 'DIAMOND'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontSize: 9,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final MasterListing listing;
  const _StatsRow({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            label: 'Drawdown',
            value: '${(listing.drawdownFraction * 100).toStringAsFixed(1)}%',
            valueColor: AppColors.loss,
          ),
        ),
        Expanded(
          child: _StatItem(
            label: 'Risk',
            value: _riskLabel(listing.riskScore),
            valueColor: _riskColor(listing.riskScore),
          ),
        ),
        Expanded(
          child: _StatItem(
            label: 'Followers',
            value: listing.followers.toString(),
            valueColor: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _riskLabel(RiskScore r) => switch (r) {
        RiskScore.low => 'Low',
        RiskScore.medium => 'Med',
        RiskScore.high => 'High',
      };

  Color _riskColor(RiskScore r) => switch (r) {
        RiskScore.low => AppColors.profit,
        RiskScore.medium => AppColors.warning,
        RiskScore.high => AppColors.loss,
      };
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: valueColor,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
