import 'package:flutter/material.dart';
import 'package:qp_core/domain/master_listing.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Hero card at the top of the Provider Profile.
///
/// Composition (responsive):
///   - Avatar/initials chip + tier badge (top-left)
///   - Display name + tagline + platform/broker meta
///   - Identity stats row: trading since · followers · risk · drawdown
///   - Hero gain % over the selected window
///   - Follow CTA + min-deposit hint
///
/// On desktop (>= tabletMin) the gain + CTA align right; on mobile
/// everything stacks.
class ProfileHeader extends StatelessWidget {
  final MasterListing listing;

  /// Number of the trader's slaves currently following this master.
  /// > 0 surfaces a "Following with N slave(s)" chip below the CTA;
  /// CTA stays clickable since one master can be followed by multiple
  /// slaves (per spec). 0 hides the chip entirely.
  final int existingFollowsCount;

  final VoidCallback onFollow;

  const ProfileHeader({
    super.key,
    required this.listing,
    this.existingFollowsCount = 0,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= AppSpacing.tabletMin;
    final positive = listing.gainFraction >= 0;

    final identity = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Avatar(name: listing.displayName),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          listing.displayName,
                          style: AppTypography.headlineMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _TierBadge(tier: listing.tier),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${listing.platform.name.toUpperCase()} · '
                    '${listing.broker} · ${listing.currency}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(listing.tagline, style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.lg),
        _MetaRow(listing: listing),
      ],
    );

    final gainBlock = Column(
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Gain (this window)',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${positive ? '+' : ''}'
          '${(listing.gainFraction * 100).toStringAsFixed(2)}%',
          style: AppTypography.numericMedium.copyWith(
            color: positive ? AppColors.profit : AppColors.loss,
            fontSize: 40,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(label: 'Follow this provider', onPressed: onFollow),
        if (existingFollowsCount > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          _FollowingChip(count: existingFollowsCount),
        ],
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Min deposit ${_money(listing.minDeposit, listing.currency)}',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
          ),
          textAlign: isWide ? TextAlign.right : TextAlign.left,
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: identity),
                const SizedBox(width: AppSpacing.xl),
                Expanded(flex: 2, child: gainBlock),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                identity,
                const SizedBox(height: AppSpacing.xl),
                gainBlock,
              ],
            ),
    );
  }

  String _money(double v, String currency) {
    return '$currency ${v.toStringAsFixed(0)}';
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = _initialsOf(name);
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryAccent.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTypography.titleLarge.copyWith(
          color: AppColors.textOnDark,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
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

class _MetaRow extends StatelessWidget {
  final MasterListing listing;
  const _MetaRow({required this.listing});

  @override
  Widget build(BuildContext context) {
    final since =
        '${_monthName(listing.tradingSince.month)} ${listing.tradingSince.year}';
    return Wrap(
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.md,
      children: [
        _MetaItem(label: 'Trading since', value: since),
        _MetaItem(
          label: 'Followers',
          value: listing.followers.toString(),
        ),
        _MetaItem(
          label: 'Drawdown',
          value: '${(listing.drawdownFraction * 100).toStringAsFixed(1)}%',
          valueColor: AppColors.loss,
        ),
        _MetaItem(
          label: 'Risk',
          value: _riskLabel(listing.riskScore),
          valueColor: _riskColor(listing.riskScore),
        ),
      ],
    );
  }

  String _riskLabel(RiskScore r) => switch (r) {
        RiskScore.low => 'Low',
        RiskScore.medium => 'Medium',
        RiskScore.high => 'High',
      };

  Color _riskColor(RiskScore r) => switch (r) {
        RiskScore.low => AppColors.profit,
        RiskScore.medium => AppColors.warning,
        RiskScore.high => AppColors.loss,
      };

  String _monthName(int m) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][m - 1];
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetaItem({
    required this.label,
    required this.value,
    this.valueColor,
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
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _FollowingChip extends StatelessWidget {
  final int count;
  const _FollowingChip({required this.count});

  @override
  Widget build(BuildContext context) {
    final label = count == 1 ? 'Following with 1 slave' : 'Following with $count slaves';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.profit.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 14, color: AppColors.profit),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.profit,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
