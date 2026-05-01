import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account.dart';
import 'package:qp_core/domain/account_ownership.dart';
import 'package:qp_core/repositories/trading_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

import 'account_details_sheet.dart';
import 'slave_settings_dialog.dart';

/// Accounts table — search + platform filter + sortable rows.
///
/// Search is local (substring on display name + login). Platform filter
/// is local (no API filtering needed since the row count is bounded by
/// the trader's slot quota — small enough to render entirely). Live
/// connection + balance are placeholders ("—") in B.2.1; B.2.3 wires
/// real-time status via getStatusbyID + per-platform balance endpoints.
class AccountsTable extends StatelessWidget {
  final List<AccountOwnership> accounts;
  final int totalCount;
  final String search;
  final Platform? platformFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<Platform?> onPlatformChanged;
  final VoidCallback onAccountChanged;

  const AccountsTable({
    super.key,
    required this.accounts,
    required this.totalCount,
    required this.search,
    required this.platformFilter,
    required this.onSearchChanged,
    required this.onPlatformChanged,
    required this.onAccountChanged,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pie_chart_outline,
                color: AppColors.primaryAccent,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('Accounts', style: AppTypography.titleLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _FilterRow(
            search: search,
            platformFilter: platformFilter,
            onSearchChanged: onSearchChanged,
            onPlatformChanged: onPlatformChanged,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (totalCount == 0)
            const _EmptyState()
          else if (accounts.isEmpty)
            const _NoMatchesState()
          else
            _Table(
              accounts: accounts,
              onAccountChanged: onAccountChanged,
            ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Filter row
// =============================================================================

class _FilterRow extends StatelessWidget {
  final String search;
  final Platform? platformFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<Platform?> onPlatformChanged;

  const _FilterRow({
    required this.search,
    required this.platformFilter,
    required this.onSearchChanged,
    required this.onPlatformChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= AppSpacing.tabletMin;

    final searchField = SizedBox(
      height: 44,
      child: TextField(
        onChanged: onSearchChanged,
        controller: TextEditingController(text: search)
          ..selection = TextSelection.collapsed(offset: search.length),
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 18,
            color: AppColors.textMuted,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          filled: true,
          fillColor: AppColors.surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.surfaceBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(
              color: AppColors.primaryAccent,
              width: 1.5,
            ),
          ),
        ),
      ),
    );

    final platformDropdown = SizedBox(
      height: 44,
      child: DropdownButtonFormField<Platform?>(
        value: platformFilter,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColors.surfaceBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(
              color: AppColors.primaryAccent,
              width: 1.5,
            ),
          ),
        ),
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text('Type All Platforms'),
          ),
          for (final p in Platform.values)
            DropdownMenuItem(value: p, child: Text(p.wireValue)),
        ],
        onChanged: onPlatformChanged,
      ),
    );

    if (isWide) {
      return Row(
        children: [
          Expanded(child: searchField),
          const SizedBox(width: AppSpacing.md),
          SizedBox(width: 220, child: platformDropdown),
        ],
      );
    }
    return Column(
      children: [
        searchField,
        const SizedBox(height: AppSpacing.sm),
        platformDropdown,
      ],
    );
  }
}

// =============================================================================
//  Table
// =============================================================================

class _Table extends StatelessWidget {
  final List<AccountOwnership> accounts;
  final VoidCallback onAccountChanged;

  const _Table({required this.accounts, required this.onAccountChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HeaderRow(),
        const Divider(height: 1, color: AppColors.surfaceBorder),
        for (var i = 0; i < accounts.length; i++) ...[
          _AccountRow(
            account: accounts[i],
            onChanged: onAccountChanged,
          ),
          if (i != accounts.length - 1)
            const Divider(height: 1, color: AppColors.surfaceBorder),
        ],
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.labelSmall.copyWith(
      color: AppColors.textMuted,
      fontSize: 10,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('NAME', style: style)),
          Expanded(flex: 3, child: Text('ACCOUNT', style: style)),
          Expanded(flex: 2, child: Text('PLATFORM', style: style)),
          Expanded(flex: 2, child: Text('BALANCE', style: style)),
          Expanded(flex: 2, child: Text('CONNECTION', style: style)),
          Expanded(flex: 2, child: Text('STATUS', style: style)),
          SizedBox(width: 140, child: Text('ACTIONS', style: style)),
        ],
      ),
    );
  }
}

class _AccountRow extends StatefulWidget {
  final AccountOwnership account;
  final VoidCallback onChanged;
  const _AccountRow({required this.account, required this.onChanged});

  @override
  State<_AccountRow> createState() => _AccountRowState();
}

class _AccountRowState extends State<_AccountRow> {
  bool _deleting = false;

  Account _toAccount() {
    final acc = widget.account;
    return Account(
      serverId: acc.tradingAccountId,
      loginNumber: acc.loginNumber,
      accountName: acc.effectiveLabel,
      accountType: acc.accountType,
      platform: acc.platform,
    );
  }

  void _openSettings() {
    showDialog<void>(
      context: context,
      barrierColor: AppColors.overlay,
      builder: (_) => SlaveSettingsDialog(account: _toAccount()),
    );
  }

  void _openDetails() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.overlay,
      builder: (_) => AccountDetailsSheet(account: _toAccount()),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: const Text('Delete account?'),
        content: Text(
          'Removing ${widget.account.effectiveLabel} '
          '(#${widget.account.loginNumber}) frees up its slot. '
          'You can re-register the same broker login later if you change '
          'your mind. This cannot be undone.',
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      final repo = context.read<TradingRepository>();
      final result = await repo.deleteTradingAccount(
        userId: widget.account.tradingAccountId,
        isMaster: widget.account.accountType == AccountType.master,
        platform: widget.account.platform.wireValue,
        loginNumber: widget.account.loginNumber,
      );
      if (!mounted) return;
      if (!result.toLowerCase().contains('success')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: AppColors.loss,
          ),
        );
        setState(() => _deleting = false);
        return;
      }
      widget.onChanged();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Couldn't delete account: $e"),
          backgroundColor: AppColors.loss,
        ),
      );
      setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final acc = widget.account;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  acc.effectiveLabel,
                  style: AppTypography.titleMedium.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                _TypePill(type: acc.accountType),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              acc.loginNumber,
              style: AppTypography.bodyMedium.copyWith(
                fontFamily: AppTypography.monoFontFamily,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              acc.platform.wireValue,
              style: AppTypography.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '—',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '—',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _StatusPill(disabled: acc.mirroringDisabled),
          ),
          SizedBox(
            width: 140,
            child: _deleting
                ? const Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.loss,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Info — open orders + trade history (both roles).
                      IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          size: 18,
                        ),
                        color: AppColors.textMuted,
                        onPressed: _openDetails,
                        tooltip: 'Open orders + history',
                      ),
                      // Gear (Slave Settings) — only on slaves; masters
                      // don't have follow-side risk/order-control settings.
                      if (acc.accountType == AccountType.slave)
                        IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            size: 18,
                          ),
                          color: AppColors.textMuted,
                          onPressed: _openSettings,
                          tooltip: 'Slave settings',
                        ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                        ),
                        color: AppColors.textMuted,
                        onPressed: _confirmDelete,
                        tooltip: 'Delete account',
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  final AccountType type;
  const _TypePill({required this.type});

  @override
  Widget build(BuildContext context) {
    final isMaster = type == AccountType.master;
    final color = isMaster ? AppColors.primaryAccent : AppColors.info;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        isMaster ? 'MASTER' : 'SLAVE',
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool disabled;
  const _StatusPill({required this.disabled});

  @override
  Widget build(BuildContext context) {
    final (color, label) = disabled
        ? (AppColors.warning, 'INACTIVE')
        : (AppColors.profit, 'ACTIVE');
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: color,
            fontSize: 9,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  Empty / no-matches states
// =============================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            color: AppColors.textMuted,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Data',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            "Use Add Account above to register your first broker account.",
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NoMatchesState extends StatelessWidget {
  const _NoMatchesState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Center(
        child: Text(
          'No accounts match the current filters.',
          style: AppTypography.bodySmall,
        ),
      ),
    );
  }
}
