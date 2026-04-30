import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/wallet.dart';
import 'package:qp_core/repositories/wallet_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

import 'wallet_detail_sheet.dart';

/// Admin "Wallets" screen — list of every trader's wallet.
///
/// Tapping a row opens a side sheet with that wallet's full transaction
/// history + a "Confirm Deposit" form. RLS guarantees only admin
/// callers see the full list (non-admins get blocked at the policy
/// level, so a plain `select` returns the right scope).
class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key});

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  late Future<List<WalletWithProfile>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<WalletWithProfile>> _load() {
    return context.read<WalletRepository>().listAllWallets();
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _openDetail(WalletWithProfile entry) async {
    final didDeposit = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      barrierColor: AppColors.overlay,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.92,
        child: WalletDetailSheet(entry: entry),
      ),
    );
    if (didDeposit == true && mounted) {
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Wallets', style: AppTypography.headlineSmall),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<WalletWithProfile>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryAccent,
              ),
            );
          }
          if (snap.hasError) {
            return _ErrorState(
              message: snap.error.toString(),
              onRetry: _refresh,
            );
          }
          final entries = snap.data ?? const <WalletWithProfile>[];
          if (entries.isEmpty) {
            return const _EmptyState();
          }
          return RefreshIndicator(
            color: AppColors.primaryAccent,
            onRefresh: () async {
              _refresh();
              await _future;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.xl),
              itemCount: entries.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) => _WalletRow(
                entry: entries[i],
                onTap: () => _openDetail(entries[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WalletRow extends StatelessWidget {
  final WalletWithProfile entry;
  final VoidCallback onTap;

  const _WalletRow({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final w = entry.wallet;
    final isAdmin = entry.role == 'admin';
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.surfaceBorder),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                alignment: Alignment.center,
                child: Text(
                  _initialsOf(entry.displayName ?? '?'),
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
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            entry.displayName ?? '(no display name)',
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isAdmin) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSm,
                              ),
                            ),
                            child: Text(
                              'ADMIN',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontSize: 9,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Updated ${_formatDate(w.updatedAt)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${w.currency} ${w.balance.toStringAsFixed(2)}',
                    style: AppTypography.titleLarge.copyWith(
                      fontSize: 18,
                      color: w.balance > 0
                          ? AppColors.profit
                          : AppColors.textPrimary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'balance',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'[\s@]+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.textMuted,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text("No wallets yet", style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Text(
                "Create a trader user via Supabase Dashboard "
                "(Authentication → Users → Add user). The trigger "
                "auto-creates a profile and wallet for each new signup.",
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.loss,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text("Couldn't load wallets", style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(message, style: AppTypography.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
