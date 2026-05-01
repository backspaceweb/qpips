import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account.dart';
import 'package:qp_core/domain/account_ownership.dart';
import 'package:qp_core/domain/provider_listing.dart';
import 'package:qp_core/repositories/account_repository.dart';
import 'package:qp_core/repositories/provider_listing_repository.dart';
import 'package:qp_core/repositories/trader_live_state_controller.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

import 'add_account_dialog.dart';
import 'widgets/accounts_stats_grid.dart';
import 'widgets/accounts_table.dart';
import 'widgets/slot_indicator.dart';

/// Accounts tab — trader's view of their registered trading accounts.
///
/// Live values (balance, equity, openPnl, openTradesCount, status) come
/// from a centralised [TraderLiveStateController] (E.4) so they stay
/// in lockstep with the same numbers shown on My Follows. This screen
/// loads the page-specific static data (slot usage, listings) and
/// reads everything else from the controller via Consumer.
class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  Future<_StaticData>? _staticFuture;
  String _search = '';
  Platform? _platformFilter;

  @override
  void initState() {
    super.initState();
    _staticFuture = _loadStatic();
  }

  Future<_StaticData> _loadStatic() async {
    final providerRepo = context.read<ProviderListingRepository>();
    final accountRepo = context.read<AccountRepository>();
    final results = await Future.wait([
      accountRepo.getMySlotUsage(),
      providerRepo.listMine(),
    ]);
    final listings = results[1] as List<ProviderListing>;
    return _StaticData(
      usage: results[0] as SlotUsage,
      listingsByMaster: {
        for (final l in listings) l.masterAccountId: l,
      },
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _staticFuture = _loadStatic();
    });
    await context.read<TraderLiveStateController>().refresh();
  }

  Future<void> _openAddDialog(_StaticData staticData,
      List<AccountOwnership> accounts) async {
    final masters =
        accounts.where((a) => a.accountType == AccountType.master).toList();
    final added = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.overlay,
      builder: (_) => AddAccountDialog(
        usage: staticData.usage,
        existingMasters: masters,
      ),
    );
    if (added == true) {
      // New account → reload static data + refresh controller's
      // accounts list so polling picks up the new fleet.
      await _refresh();
      if (!mounted) return;
      await context.read<TraderLiveStateController>().reloadAccounts();
    }
  }

  List<AccountOwnership> _applyFilters(List<AccountOwnership> all) {
    Iterable<AccountOwnership> filtered = all;
    if (_platformFilter != null) {
      filtered = filtered.where((a) => a.platform == _platformFilter);
    }
    final q = _search.trim().toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered.where((a) =>
          a.effectiveLabel.toLowerCase().contains(q) ||
          a.tradingAccountId.toString().contains(q));
    }
    return filtered.toList();
  }

  /// Called by row-level mutations (delete, switch master, edit) so
  /// the controller picks up the new fleet.
  void _onRowMutated() {
    context.read<TraderLiveStateController>().reloadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppSpacing.desktopMin;
    final hPad = isDesktop
        ? AppSpacing.x3
        : (width >= AppSpacing.tabletMin ? AppSpacing.xxl : AppSpacing.lg);

    return RefreshIndicator(
      color: AppColors.primaryAccent,
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: hPad,
          vertical: AppSpacing.xxl,
        ),
        child: FutureBuilder<_StaticData>(
          future: _staticFuture,
          builder: (context, staticSnap) {
            if (staticSnap.connectionState != ConnectionState.done) {
              return const _Loading();
            }
            if (staticSnap.hasError) {
              return _ErrorBlock(
                message: staticSnap.error.toString(),
                onRetry: _refresh,
              );
            }
            final staticData = staticSnap.data!;
            return Consumer<TraderLiveStateController>(
              builder: (context, ctrl, _) {
                if (ctrl.initialError != null) {
                  return _ErrorBlock(
                    message: ctrl.initialError.toString(),
                    onRetry: _refresh,
                  );
                }
                if (!ctrl.initialized) {
                  return const _Loading();
                }
                final accounts = ctrl.accounts;
                final visible = _applyFilters(accounts);
                final inactiveCount =
                    accounts.where((a) => a.mirroringDisabled).length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(
                      usage: staticData.usage,
                      onAddPressed: () =>
                          _openAddDialog(staticData, accounts),
                      lastUpdatedAt: ctrl.lastUpdatedAt,
                    ),
                    if (inactiveCount > 0) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _InactiveBanner(count: inactiveCount),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    AccountsStatsGrid(accounts: accounts),
                    const SizedBox(height: AppSpacing.xl),
                    AccountsTable(
                      accounts: visible,
                      allAccounts: accounts,
                      listingsByMaster: staticData.listingsByMaster,
                      liveStateByAccount: ctrl.liveStateByAccount,
                      statusByAccount: ctrl.statusByAccount,
                      search: _search,
                      platformFilter: _platformFilter,
                      onSearchChanged: (s) => setState(() => _search = s),
                      onPlatformChanged: (p) =>
                          setState(() => _platformFilter = p),
                      onAccountChanged: _onRowMutated,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _StaticData {
  final SlotUsage usage;
  final Map<int, ProviderListing> listingsByMaster;
  const _StaticData({
    required this.usage,
    required this.listingsByMaster,
  });
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 320,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primaryAccent),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final SlotUsage usage;
  final VoidCallback onAddPressed;
  final DateTime? lastUpdatedAt;

  const _Header({
    required this.usage,
    required this.onAddPressed,
    required this.lastUpdatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= AppSpacing.tabletMin;
    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Accounts Configuration', style: AppTypography.headlineLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Register the broker accounts you want to use as masters or '
          'slaves. Each account consumes one slot from your active '
          'subscriptions.',
          style: AppTypography.bodyMedium,
        ),
        if (lastUpdatedAt != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Live values updated ${_relativeTime(lastUpdatedAt!)}.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
    final right = SlotIndicator(
      usage: usage,
      onAddPressed: onAddPressed,
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: AppSpacing.xl),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: right,
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        left,
        const SizedBox(height: AppSpacing.lg),
        right,
      ],
    );
  }

  String _relativeTime(DateTime t) {
    final secs = DateTime.now().difference(t).inSeconds;
    if (secs < 5) return 'just now';
    if (secs < 60) return '${secs}s ago';
    final mins = secs ~/ 60;
    if (mins < 60) return '${mins}m ago';
    final hours = mins ~/ 60;
    return '${hours}h ago';
  }
}

class _ErrorBlock extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  const _ErrorBlock({required this.message, required this.onRetry});

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
          const Icon(Icons.error_outline, color: AppColors.loss, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text("Couldn't load accounts", style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

/// Warning banner shown above the stats grid when one or more of the
/// trader's accounts have `mirroring_disabled = true`. Coverage drops
/// the oldest accounts first when slot subs expire (or when the trader
/// over-registers); buying a new sub from Plans automatically
/// reactivates them via the enforce_slot_coverage trigger.
class _InactiveBanner extends StatelessWidget {
  final int count;
  const _InactiveBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.40),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '$count account${count == 1 ? ' is' : 's are'} inactive — '
              'your active slots cover fewer accounts than you have '
              'registered. Buy more slots from Plans to reactivate '
              '${count == 1 ? 'it' : 'them'}, or remove the inactive '
              'account${count == 1 ? '' : 's'}. Inactive accounts '
              "stay registered but won't mirror new trades.",
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
