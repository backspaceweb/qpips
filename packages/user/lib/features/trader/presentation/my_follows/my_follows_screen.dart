import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account.dart';
import 'package:qp_core/domain/account_ownership.dart';
import 'package:qp_core/domain/active_follow.dart';
import 'package:qp_core/repositories/trader_live_state_controller.dart';
import 'package:qp_core/repositories/trader_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';
import '../accounts/widgets/slave_settings_dialog.dart';
import '../profile/provider_profile_screen.dart';
import '../tabs.dart';
import 'widgets/follow_row.dart';
import 'widgets/follows_summary.dart';

/// My Active Follows — trader's-eye-view dashboard.
///
/// Reframes the admin dashboard for the trader: instead of "every slave
/// under the operator key" it lists "every slave I'm following with",
/// keyed by master. Each row shows the slave / master pairing, a live
/// open-P&L snapshot, today's realised P&L, open trades count, and
/// inline pause / settings / unfollow actions.
///
/// Pulls from [TraderRepository.listActiveFollows]. Mutating actions
/// (pause / resume / unfollow) trigger a refresh by re-running the
/// future. Phase E will swap the mock repo for a Supabase-backed one
/// that joins live trading-API state.
class MyFollowsScreen extends StatefulWidget {
  const MyFollowsScreen({super.key});

  @override
  State<MyFollowsScreen> createState() => _MyFollowsScreenState();
}

class _MyFollowsScreenState extends State<MyFollowsScreen> {
  late Future<List<ActiveFollow>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<ActiveFollow>> _load() {
    return context.read<TraderRepository>().listActiveFollows();
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _togglePause(ActiveFollow follow) async {
    final repo = context.read<TraderRepository>();
    if (follow.isPaused) {
      await repo.resumeFollow(follow.slaveAccountId);
    } else {
      await repo.pauseFollow(follow.slaveAccountId);
    }
    if (!mounted) return;
    _refresh();
    // Pause/resume flips the DB-side mirroring flag — the controller's
    // status ticker doesn't carry that, so re-pull accounts to refresh.
    context.read<TraderLiveStateController>().reloadAccounts();
  }

  Future<void> _unfollow(ActiveFollow follow) async {
    final confirmed = await _confirmUnfollow(context, follow);
    if (!confirmed || !mounted) return;
    await context.read<TraderRepository>().unfollow(follow.slaveAccountId);
    if (!mounted) return;
    _refresh();
    // Unfollow removes the slave; controller needs to drop it from
    // the polled fleet.
    context.read<TraderLiveStateController>().reloadAccounts();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Unfollowed ${follow.masterDisplayName} on '
          '${follow.slaveDisplayName}.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openMasterProfile(ActiveFollow follow) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProviderProfileScreen(providerId: follow.masterId),
      ),
    );
  }

  /// Opens the per-slave settings dialog (risk multiplier, copy SL/TP,
  /// scalper, order filter, auto-close limits, symbols) for the slave
  /// behind this follow. Reuses the same SlaveSettingsDialog that the
  /// Accounts tab uses — single source of truth for per-slave config.
  ///
  /// Slave identity comes from the live-state controller's accounts list
  /// (already loaded for the rest of My Follows). If the controller
  /// hasn't initialised yet, surface a soft message rather than failing.
  void _openSettings(ActiveFollow follow) {
    final serverId = int.tryParse(follow.slaveAccountId);
    if (serverId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't open settings — invalid slave id."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final controller = context.read<TraderLiveStateController>();
    final idx = controller.accounts
        .indexWhere((a) => a.tradingAccountId == serverId);
    if (idx == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Slave account is still loading — please try again in a moment.',
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      barrierColor: AppColors.overlay,
      builder: (_) =>
          SlaveSettingsDialog(account: _toAccount(controller.accounts[idx])),
    );
  }

  Account _toAccount(AccountOwnership a) {
    return Account(
      serverId: a.tradingAccountId,
      loginNumber: a.loginNumber,
      accountName: a.effectiveLabel,
      accountType: a.accountType,
      platform: a.platform,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width >= AppSpacing.desktopMin
        ? AppSpacing.x3
        : (width >= AppSpacing.tabletMin
            ? AppSpacing.xxl
            : AppSpacing.lg);

    return RefreshIndicator(
      color: AppColors.primaryAccent,
      onRefresh: () async {
        _refresh();
        await _future;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: hPad,
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My active follows', style: AppTypography.headlineLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Slaves currently mirroring a signal provider. Pause to '
              'stop new trades; unfollow to drop the binding entirely.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            FutureBuilder<List<ActiveFollow>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.x3),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  );
                }
                if (snap.hasError) {
                  return _ErrorCard(
                    message: snap.error.toString(),
                    onRetry: _refresh,
                  );
                }
                final baseFollows = snap.data ?? const <ActiveFollow>[];
                if (baseFollows.isEmpty) {
                  return const _EmptyState();
                }
                // Live overlay: rebuilds whenever the controller
                // ticks. balance/equity/openPnl/todayPnl/openTrades
                // come from the controller; identity + master display
                // + isPaused come from the loaded follows.
                return Consumer<TraderLiveStateController>(
                  builder: (context, ctrl, _) {
                    final follows = [
                      for (final f in baseFollows)
                        () {
                          final serverId = int.tryParse(f.slaveAccountId);
                          if (serverId == null) return f;
                          final live = ctrl.liveFor(serverId);
                          return f.copyWith(
                            slaveBalance: live.balance,
                            slaveEquity: live.equity,
                            openPnl: live.openPnl,
                            todayPnl: live.todayPnl,
                            openTradesCount: live.openTradesCount,
                          );
                        }(),
                    ];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FollowsSummary(follows: follows),
                        const SizedBox(height: AppSpacing.xl),
                        for (final f in follows)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: FollowRow(
                              follow: f,
                              onTogglePause: () => _togglePause(f),
                              onUnfollow: () => _unfollow(f),
                              onSettings: () => _openSettings(f),
                              onOpenMaster: () => _openMasterProfile(f),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _confirmUnfollow(
  BuildContext context,
  ActiveFollow follow,
) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: AppColors.overlay,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      title: Text('Unfollow ${follow.masterDisplayName}?',
          style: AppTypography.titleLarge),
      content: Text(
        '${follow.slaveDisplayName} will stop mirroring new trades from '
        '${follow.masterDisplayName}. '
        '${follow.openTradesCount} open position'
        '${follow.openTradesCount == 1 ? '' : 's'} '
        'will stay open until you close them on the broker side.',
        style: AppTypography.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.loss),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Unfollow'),
        ),
      ],
    ),
  );
  return result ?? false;
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.explore_outlined,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            "You're not following anyone yet",
            style: AppTypography.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              'Browse signal providers in Discover, evaluate their '
              'performance, and bind one to a slave account to start '
              'mirroring trades.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Browse providers',
            onPressed: () {
              context.read<TraderTabController>().setTab(TraderTab.discover);
            },
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline,
              color: AppColors.loss, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text("Couldn't load your follows",
              style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
