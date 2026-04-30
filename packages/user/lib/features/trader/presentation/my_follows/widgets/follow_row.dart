import 'package:flutter/material.dart';
import 'package:qp_core/domain/active_follow.dart';
import 'package:qp_core/domain/master_listing.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// One row in the My Active Follows list.
///
/// Layout (responsive):
///   - Identity column: master avatar + display name + tier badge,
///     followed by the slave it's bound to (display name · platform ·
///     broker · login).
///   - Live snapshot column: open P&L (big, colored), today's P&L
///     (small), open trades count.
///   - Actions: pause/resume, settings, unfollow. On desktop these
///     render as inline icon buttons; on mobile they collapse into an
///     overflow menu.
///
/// Tapping the master display name opens that provider's profile.
class FollowRow extends StatelessWidget {
  final ActiveFollow follow;
  final VoidCallback onTogglePause;
  final VoidCallback onUnfollow;
  final VoidCallback onSettings;
  final VoidCallback onOpenMaster;

  const FollowRow({
    super.key,
    required this.follow,
    required this.onTogglePause,
    required this.onUnfollow,
    required this.onSettings,
    required this.onOpenMaster,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppSpacing.desktopMin;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: follow.isPaused
              ? AppColors.warning.withValues(alpha: 0.4)
              : AppColors.surfaceBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: isDesktop
          ? _DesktopLayout(
              follow: follow,
              onTogglePause: onTogglePause,
              onUnfollow: onUnfollow,
              onSettings: onSettings,
              onOpenMaster: onOpenMaster,
            )
          : _MobileLayout(
              follow: follow,
              onTogglePause: onTogglePause,
              onUnfollow: onUnfollow,
              onSettings: onSettings,
              onOpenMaster: onOpenMaster,
            ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final ActiveFollow follow;
  final VoidCallback onTogglePause;
  final VoidCallback onUnfollow;
  final VoidCallback onSettings;
  final VoidCallback onOpenMaster;

  const _DesktopLayout({
    required this.follow,
    required this.onTogglePause,
    required this.onUnfollow,
    required this.onSettings,
    required this.onOpenMaster,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: _Identity(follow: follow, onOpenMaster: onOpenMaster),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(flex: 3, child: _LiveSnapshot(follow: follow)),
        const SizedBox(width: AppSpacing.lg),
        _Actions(
          follow: follow,
          onTogglePause: onTogglePause,
          onUnfollow: onUnfollow,
          onSettings: onSettings,
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final ActiveFollow follow;
  final VoidCallback onTogglePause;
  final VoidCallback onUnfollow;
  final VoidCallback onSettings;
  final VoidCallback onOpenMaster;

  const _MobileLayout({
    required this.follow,
    required this.onTogglePause,
    required this.onUnfollow,
    required this.onSettings,
    required this.onOpenMaster,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _Identity(follow: follow, onOpenMaster: onOpenMaster),
            ),
            _OverflowMenu(
              follow: follow,
              onTogglePause: onTogglePause,
              onUnfollow: onUnfollow,
              onSettings: onSettings,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Divider(height: 1, color: AppColors.surfaceBorder),
        const SizedBox(height: AppSpacing.md),
        _LiveSnapshot(follow: follow),
      ],
    );
  }
}

class _Identity extends StatelessWidget {
  final ActiveFollow follow;
  final VoidCallback onOpenMaster;

  const _Identity({required this.follow, required this.onOpenMaster});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MasterAvatar(name: follow.masterDisplayName),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: onOpenMaster,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          follow.masterDisplayName,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                AppColors.primary.withValues(alpha: 0.3),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _TierDot(tier: follow.masterTier),
                      if (follow.isPaused) ...[
                        const SizedBox(width: AppSpacing.sm),
                        const _PausedPill(),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'on ${follow.slaveDisplayName} · '
                '${follow.slavePlatform.name.toUpperCase()} · '
                '${follow.slaveBroker} #${follow.slaveLoginNumber}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Following since ${_formatDate(follow.createdAt)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LiveSnapshot extends StatelessWidget {
  final ActiveFollow follow;
  const _LiveSnapshot({required this.follow});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Metric(
          label: 'Open P&L',
          value: _money(follow.openPnl),
          valueColor: _pnlColor(follow.openPnl),
          prominent: true,
        ),
        _Metric(
          label: 'Today',
          value: _money(follow.todayPnl),
          valueColor: _pnlColor(follow.todayPnl),
        ),
        _Metric(
          label: 'Open',
          value: '${follow.openTradesCount}',
        ),
        _Metric(
          label: 'Equity',
          value: '\$${follow.slaveEquity.toStringAsFixed(0)}',
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool prominent;

  const _Metric({
    required this.label,
    required this.value,
    this.valueColor,
    this.prominent = false,
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
          style: prominent
              ? AppTypography.titleLarge.copyWith(
                  fontSize: 20,
                  color: valueColor ?? AppColors.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                )
              : AppTypography.titleMedium.copyWith(
                  fontSize: 14,
                  color: valueColor ?? AppColors.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  final ActiveFollow follow;
  final VoidCallback onTogglePause;
  final VoidCallback onUnfollow;
  final VoidCallback onSettings;

  const _Actions({
    required this.follow,
    required this.onTogglePause,
    required this.onUnfollow,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionButton(
          icon: follow.isPaused ? Icons.play_arrow : Icons.pause,
          tooltip: follow.isPaused ? 'Resume mirroring' : 'Pause mirroring',
          onPressed: onTogglePause,
        ),
        const SizedBox(width: 4),
        _ActionButton(
          icon: Icons.tune,
          tooltip: 'Settings',
          onPressed: onSettings,
        ),
        const SizedBox(width: 4),
        _ActionButton(
          icon: Icons.link_off,
          tooltip: 'Unfollow',
          onPressed: onUnfollow,
          dangerous: true,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool dangerous;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.dangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = dangerous ? AppColors.loss : AppColors.textSecondary;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  final ActiveFollow follow;
  final VoidCallback onTogglePause;
  final VoidCallback onUnfollow;
  final VoidCallback onSettings;

  const _OverflowMenu({
    required this.follow,
    required this.onTogglePause,
    required this.onUnfollow,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
      onSelected: (key) {
        switch (key) {
          case 'pause':
            onTogglePause();
            break;
          case 'settings':
            onSettings();
            break;
          case 'unfollow':
            onUnfollow();
            break;
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'pause',
          child: Row(
            children: [
              Icon(
                follow.isPaused ? Icons.play_arrow : Icons.pause,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(follow.isPaused ? 'Resume' : 'Pause'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.tune, size: 18),
              SizedBox(width: AppSpacing.sm),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'unfollow',
          child: Row(
            children: [
              Icon(Icons.link_off, size: 18, color: AppColors.loss),
              SizedBox(width: AppSpacing.sm),
              Text('Unfollow', style: TextStyle(color: AppColors.loss)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MasterAvatar extends StatelessWidget {
  final String name;
  const _MasterAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      alignment: Alignment.center,
      child: Text(
        _initialsOf(name),
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.textOnDark,
          fontSize: 14,
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

class _TierDot extends StatelessWidget {
  final ProviderTier tier;
  const _TierDot({required this.tier});

  @override
  Widget build(BuildContext context) {
    final color = switch (tier) {
      ProviderTier.bronze => const Color(0xFFB87333),
      ProviderTier.silver => const Color(0xFF8C99A1),
      ProviderTier.gold => const Color(0xFFC9A227),
      ProviderTier.diamond => const Color(0xFF4FA8C9),
    };
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PausedPill extends StatelessWidget {
  const _PausedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Text(
        'PAUSED',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.warning,
          fontSize: 9,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

String _formatDate(DateTime dt) {
  return '${_monthShort(dt.month)} ${dt.day}, ${dt.year}';
}

String _monthShort(int m) => const [
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

Color _pnlColor(double v) {
  if (v > 0.005) return AppColors.profit;
  if (v < -0.005) return AppColors.loss;
  return AppColors.textPrimary;
}

String _money(double v) {
  final sign = v < 0 ? '-' : (v > 0 ? '+' : '');
  return '$sign\$${v.abs().toStringAsFixed(2)}';
}
