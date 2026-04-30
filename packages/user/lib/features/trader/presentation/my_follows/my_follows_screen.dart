import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/active_follow.dart';
import 'package:qp_core/repositories/trader_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';
import '../profile/provider_profile_screen.dart';
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
  }

  Future<void> _unfollow(ActiveFollow follow) async {
    final confirmed = await _confirmUnfollow(context, follow);
    if (!confirmed || !mounted) return;
    await context.read<TraderRepository>().unfollow(follow.slaveAccountId);
    if (!mounted) return;
    _refresh();
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

  void _comingSoonSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'In-place settings editing lands later. For now, unfollow then '
          're-bind to change risk or limits.',
        ),
        duration: Duration(seconds: 3),
      ),
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
                final follows = snap.data ?? const <ActiveFollow>[];
                if (follows.isEmpty) {
                  return const _EmptyState();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FollowsSummary(follows: follows),
                    const SizedBox(height: AppSpacing.xl),
                    for (final f in follows)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.md),
                        child: FollowRow(
                          follow: f,
                          onTogglePause: () => _togglePause(f),
                          onUnfollow: () => _unfollow(f),
                          onSettings: _comingSoonSettings,
                          onOpenMaster: () => _openMasterProfile(f),
                        ),
                      ),
                  ],
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
              // TraderShell holds tab state in setState — for D.5 we
              // surface a hint rather than wire a cross-tab jump.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Switch to the Discover tab on the left.'),
                  duration: Duration(seconds: 2),
                ),
              );
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
