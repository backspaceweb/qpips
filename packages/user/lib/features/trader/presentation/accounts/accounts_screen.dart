import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account.dart';
import 'package:qp_core/domain/account_ownership.dart';
import 'package:qp_core/repositories/account_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

import 'add_account_dialog.dart';
import 'widgets/accounts_stats_grid.dart';
import 'widgets/accounts_table.dart';
import 'widgets/slot_indicator.dart';

/// Accounts tab — trader's view of their registered trading accounts.
///
/// Layout (matches Susanto's design sample):
///   - Header row: "Accounts Configuration" + slot-usage progress bar +
///     "Add Account" button (disabled when slots are exhausted)
///   - 4 stat cards: Total / Active / Inactive / Best Performing
///   - Accounts panel: search + platform filter + sortable table +
///     pagination + No-Data empty state
///
/// Reads ownership rows from `account_ownership` (Supabase). Live state
/// (connection, balance) ships in B.2.3 via getStatusbyID + the live-
/// state endpoints; for now Status defaults to ACTIVE (mirroring_disabled
/// flips it once B.4 lands), Connection + Balance show placeholders.
class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  Future<_AccountsData>? _future;
  String _search = '';
  Platform? _platformFilter;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_AccountsData> _load() async {
    final repo = context.read<AccountRepository>();
    final results = await Future.wait([
      repo.listMyAccounts(),
      repo.getMySlotUsage(),
    ]);
    return _AccountsData(
      accounts: results[0] as List<AccountOwnership>,
      usage: results[1] as SlotUsage,
    );
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _openAddDialog(_AccountsData data) async {
    final masters = data.accounts
        .where((a) => a.accountType == AccountType.master)
        .toList();
    final added = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.overlay,
      builder: (_) => AddAccountDialog(
        usage: data.usage,
        existingMasters: masters,
      ),
    );
    if (added == true) _refresh();
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppSpacing.desktopMin;
    final hPad = isDesktop
        ? AppSpacing.x3
        : (width >= AppSpacing.tabletMin ? AppSpacing.xxl : AppSpacing.lg);

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
        child: FutureBuilder<_AccountsData>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 320,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryAccent,
                  ),
                ),
              );
            }
            if (snap.hasError) {
              return _ErrorBlock(
                message: snap.error.toString(),
                onRetry: _refresh,
              );
            }
            final data = snap.data!;
            final visible = _applyFilters(data.accounts);
            final inactiveCount = data.accounts
                .where((a) => a.mirroringDisabled)
                .length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  usage: data.usage,
                  onAddPressed: () => _openAddDialog(data),
                ),
                if (inactiveCount > 0) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _InactiveBanner(count: inactiveCount),
                ],
                const SizedBox(height: AppSpacing.xl),
                AccountsStatsGrid(accounts: data.accounts),
                const SizedBox(height: AppSpacing.xl),
                AccountsTable(
                  accounts: visible,
                  allAccounts: data.accounts,
                  search: _search,
                  platformFilter: _platformFilter,
                  onSearchChanged: (s) => setState(() => _search = s),
                  onPlatformChanged: (p) =>
                      setState(() => _platformFilter = p),
                  onAccountChanged: _refresh,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AccountsData {
  final List<AccountOwnership> accounts;
  final SlotUsage usage;
  const _AccountsData({required this.accounts, required this.usage});
}

class _Header extends StatelessWidget {
  final SlotUsage usage;
  final VoidCallback onAddPressed;

  const _Header({required this.usage, required this.onAddPressed});

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
}

class _ErrorBlock extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
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
