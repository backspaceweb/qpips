import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/repositories/auth_repository.dart';
import 'package:qp_core/repositories/trader_live_state_controller.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/demo_data_banner.dart';
import 'accounts/accounts_screen.dart';
import 'discover/discover_screen.dart';
import 'my_follows/my_follows_screen.dart';
import 'placeholder_tab.dart';
import 'plans/plans_screen.dart';
import 'tabs.dart';
import 'wallet/wallet_screen.dart';

/// Responsive shell for every trader-app screen.
///
/// On desktop (>= 1024px) renders a fixed sidebar + content. On smaller
/// viewports renders content + bottom-tab bar. Tab state lives in the
/// shell — each tab swaps the body widget. Browser URL stays at /app
/// (no per-tab routing for D.5; Phase E wires real go_router URLs).
///
/// The DemoDataBanner sits above all content because every trader tab
/// renders mock data today.
class TraderShell extends StatefulWidget {
  const TraderShell({super.key});

  @override
  State<TraderShell> createState() => _TraderShellState();
}

class _TraderShellState extends State<TraderShell> {
  final TraderTabController _tabCtrl = TraderTabController();

  @override
  void initState() {
    super.initState();
    // Kick off the centralised live-state controller now that we know
    // the trader is authenticated (the AuthGate gate above us has
    // already verified the session). Idempotent — safe to call again
    // if the shell rebuilds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<TraderLiveStateController>().initialize();
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Widget _bodyFor(TraderTab tab) {
    switch (tab) {
      case TraderTab.discover:
        return const DiscoverScreen();
      case TraderTab.myFollows:
        return const MyFollowsScreen();
      case TraderTab.accounts:
        return const AccountsScreen();
      case TraderTab.wallet:
        return const WalletScreen();
      case TraderTab.plans:
        return const PlansScreen();
      case TraderTab.settings:
        return const PlaceholderTab(tabLabel: 'Settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TraderTabController>.value(
      value: _tabCtrl,
      child: ListenableBuilder(
        listenable: _tabCtrl,
        builder: (context, _) => _buildShell(context, _tabCtrl.active),
      ),
    );
  }

  Widget _buildShell(BuildContext context, TraderTab active) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppSpacing.desktopMin;

    final body = Column(
      children: [
        const DemoDataBanner(),
        Expanded(child: _bodyFor(active)),
      ],
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.surfaceMuted,
        body: Row(
          children: [
            _Sidebar(active: active, onSelect: _tabCtrl.setTab),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      body: SafeArea(child: body),
      bottomNavigationBar: _BottomTabs(
        active: active,
        onSelect: _tabCtrl.setTab,
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final TraderTab active;
  final ValueChanged<TraderTab> onSelect;

  const _Sidebar({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.surfaceBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: _Wordmark(),
          ),
          const SizedBox(height: AppSpacing.xl),
          for (final tab in TraderTab.values)
            _SidebarItem(
              tab: tab,
              active: active == tab,
              onTap: () => onSelect(tab),
            ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: _SignOut(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: _BackToLanding(),
          ),
        ],
      ),
    );
  }
}

class _SignOut extends StatelessWidget {
  const _SignOut();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await context.read<AuthRepository>().signOut();
        if (!context.mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (_) => false,
        );
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.logout,
              size: 16,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Sign out',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
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
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 17,
            letterSpacing: -0.3,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final TraderTab tab;
  final bool active;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final bg = active
        ? AppColors.primarySoft
        : (_hovering ? AppColors.surfaceMuted : Colors.transparent);
    final fg = active ? AppColors.primary : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 2,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Icon(
                    active ? widget.tab.activeIcon : widget.tab.icon,
                    color: fg,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    widget.tab.label,
                    style: AppTypography.titleMedium.copyWith(
                      color: fg,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
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

class _BackToLanding extends StatelessWidget {
  const _BackToLanding();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushReplacementNamed('/'),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back,
              size: 16,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Back to landing',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomTabs extends StatelessWidget {
  final TraderTab active;
  final ValueChanged<TraderTab> onSelect;

  const _BottomTabs({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final tab in TraderTab.values)
                _BottomTabItem(
                  tab: tab,
                  active: active == tab,
                  onTap: () => onSelect(tab),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomTabItem extends StatelessWidget {
  final TraderTab tab;
  final bool active;
  final VoidCallback onTap;

  const _BottomTabItem({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textMuted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active ? tab.activeIcon : tab.icon,
                color: color,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                tab.label,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                  fontSize: 10,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
