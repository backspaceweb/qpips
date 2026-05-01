import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/user_subscription.dart';
import 'package:qp_core/domain/wallet.dart';
import 'package:qp_core/domain/wallet_transaction.dart';
import 'package:qp_core/repositories/subscription_repository.dart';
import 'package:qp_core/repositories/wallet_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

import 'widgets/top_up_sheet.dart';

const _expirySoonThreshold = Duration(days: 3);

/// Trader's Wallet tab — balance hero + active subscriptions +
/// transaction history + Top Up.
///
/// Slot-purchase flow lives on the separate Plans tab (sibling tab in
/// the trader shell). 1A landed Top Up + transaction history. 1B added
/// active subscriptions list (read-only here; purchase happens on
/// Plans). 1C+ adds Stripe-funded deposits + auto-renewal.
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Future<_WalletData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_WalletData> _load() async {
    final walletRepo = context.read<WalletRepository>();
    final subsRepo = context.read<SubscriptionRepository>();
    final wallet = await walletRepo.getMyWallet();
    if (wallet == null) {
      return const _WalletData(
        wallet: null,
        transactions: [],
        subscriptions: [],
      );
    }
    final results = await Future.wait([
      walletRepo.getMyTransactions(),
      subsRepo.getMyActiveSubscriptions(),
    ]);
    return _WalletData(
      wallet: wallet,
      transactions: results[0] as List<WalletTransaction>,
      subscriptions: results[1] as List<UserSubscription>,
    );
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  void _showTopUpSheet() {
    showTopUpSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width >= AppSpacing.desktopMin
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wallet', style: AppTypography.headlineLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Top up your balance to buy account slots and follow signal '
              'providers. Slot purchases land in the next sub-PR (1B).',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            FutureBuilder<_WalletData>(
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
                final data = snap.data!;
                if (data.wallet == null) {
                  return const _NoWalletCard();
                }
                final expiringSoon = data.subscriptions
                    .where((s) =>
                        s.expiresAt.difference(DateTime.now()) <
                        _expirySoonThreshold)
                    .toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BalanceHero(
                      wallet: data.wallet!,
                      onTopUp: _showTopUpSheet,
                    ),
                    if (expiringSoon.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _ExpirySoonBanner(
                        count: expiringSoon.length,
                        currency: data.wallet!.currency,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Active subscriptions',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (data.subscriptions.isEmpty)
                      _EmptySubscriptions(currency: data.wallet!.currency)
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border:
                              Border.all(color: AppColors.surfaceBorder),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                        child: Column(
                          children: [
                            for (var i = 0;
                                i < data.subscriptions.length;
                                i++) ...[
                              _SubscriptionRow(
                                sub: data.subscriptions[i],
                                currency: data.wallet!.currency,
                                onChanged: _refresh,
                              ),
                              if (i != data.subscriptions.length - 1)
                                const Divider(
                                  height: 1,
                                  color: AppColors.surfaceBorder,
                                ),
                            ],
                          ],
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Transaction history',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (data.transactions.isEmpty)
                      _EmptyHistory(currency: data.wallet!.currency)
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border:
                              Border.all(color: AppColors.surfaceBorder),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                        ),
                        child: Column(
                          children: [
                            for (var i = 0;
                                i < data.transactions.length;
                                i++) ...[
                              _TransactionRow(
                                tx: data.transactions[i],
                                currency: data.wallet!.currency,
                              ),
                              if (i != data.transactions.length - 1)
                                const Divider(
                                  height: 1,
                                  color: AppColors.surfaceBorder,
                                ),
                            ],
                          ],
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

class _WalletData {
  final Wallet? wallet;
  final List<WalletTransaction> transactions;
  final List<UserSubscription> subscriptions;
  const _WalletData({
    required this.wallet,
    required this.transactions,
    required this.subscriptions,
  });
}

// =============================================================================
//  Balance hero
// =============================================================================

class _BalanceHero extends StatelessWidget {
  final Wallet wallet;
  final VoidCallback onTopUp;
  const _BalanceHero({
    required this.wallet,
    required this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: AppColors.heroBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AVAILABLE BALANCE',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textOnDarkMuted,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                wallet.currency,
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textOnDarkMuted,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  wallet.balance.toStringAsFixed(2),
                  style: AppTypography.numericLarge.copyWith(
                    color: AppColors.textOnDark,
                    fontSize: 44,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: onTopUp,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Top up'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textOnDark,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Transaction history
// =============================================================================

class _TransactionRow extends StatelessWidget {
  final WalletTransaction tx;
  final String currency;
  const _TransactionRow({required this.tx, required this.currency});

  @override
  Widget build(BuildContext context) {
    final positive = tx.isCredit;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: positive
                  ? AppColors.profit.withValues(alpha: 0.10)
                  : AppColors.loss.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              tx.type.displayLabel.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: positive ? AppColors.profit : AppColors.loss,
                fontSize: 9,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.reference ?? '(no reference)',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(tx.createdAt),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '${positive ? '+' : ''}'
            '$currency ${tx.amount.toStringAsFixed(2)}',
            style: AppTypography.titleMedium.copyWith(
              fontSize: 14,
              color: positive ? AppColors.profit : AppColors.loss,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
        '${two(dt.hour)}:${two(dt.minute)}';
  }
}

class _EmptyHistory extends StatelessWidget {
  final String currency;
  const _EmptyHistory({required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.surfaceBorder),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Center(
        child: Text(
          'No transactions yet. Top up to fund your first slot in $currency.',
          style: AppTypography.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _NoWalletCard extends StatelessWidget {
  const _NoWalletCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.surfaceBorder),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.textMuted,
            size: 36,
          ),
          const SizedBox(height: AppSpacing.md),
          Text("Wallet not found", style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Your wallet should be auto-created when you sign up. If you "
            "see this for long, contact support.",
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
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
        border: Border.all(color: AppColors.surfaceBorder),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline,
              color: AppColors.loss, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text("Couldn't load wallet", style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

// =============================================================================
//  Expiring-soon banner
// =============================================================================

class _ExpirySoonBanner extends StatelessWidget {
  final int count;
  final String currency;
  const _ExpirySoonBanner({required this.count, required this.currency});

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
              '$count subscription${count == 1 ? '' : 's'} '
              'expir${count == 1 ? 'es' : 'e'} within 3 days. '
              'Top up your $currency wallet to keep '
              '${count == 1 ? 'it' : 'them'} active — auto-renew '
              'charges from your wallet on the expiry date.',
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

// =============================================================================
//  Active subscriptions
// =============================================================================

class _SubscriptionRow extends StatefulWidget {
  final UserSubscription sub;
  final String currency;
  final VoidCallback onChanged;
  const _SubscriptionRow({
    required this.sub,
    required this.currency,
    required this.onChanged,
  });

  @override
  State<_SubscriptionRow> createState() => _SubscriptionRowState();
}

class _SubscriptionRowState extends State<_SubscriptionRow> {
  late bool _autoRenew;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _autoRenew = widget.sub.autoRenew;
  }

  @override
  void didUpdateWidget(covariant _SubscriptionRow old) {
    super.didUpdateWidget(old);
    if (old.sub.autoRenew != widget.sub.autoRenew) {
      _autoRenew = widget.sub.autoRenew;
    }
  }

  Future<void> _toggleAutoRenew(bool next) async {
    final previous = _autoRenew;
    setState(() {
      _autoRenew = next;
      _saving = true;
    });
    try {
      await context.read<SubscriptionRepository>().setAutoRenew(
            subscriptionId: widget.sub.id,
            autoRenew: next,
          );
      if (!mounted) return;
      setState(() => _saving = false);
      widget.onChanged();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _autoRenew = previous;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = widget.sub.expiresAt.difference(DateTime.now()).inDays;
    final expiringSoon =
        widget.sub.expiresAt.difference(DateTime.now()) < _expirySoonThreshold;
    final expiryColor = expiringSoon ? AppColors.warning : AppColors.textMuted;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: AppColors.primaryAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              widget.sub.tier.displayLabel.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontSize: 10,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.sub.slotCount} slot'
                  '${widget.sub.slotCount == 1 ? '' : 's'} · '
                  '${_commitLabel(widget.sub.commitmentMonths)}',
                  style: AppTypography.titleMedium.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  expiringSoon
                      ? 'Expires in ${daysLeft <= 0 ? '<1' : daysLeft} '
                          'day${daysLeft == 1 ? '' : 's'} · '
                          '${_formatDate(widget.sub.expiresAt)}'
                      : 'Expires ${_formatDate(widget.sub.expiresAt)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: expiryColor,
                    fontSize: 11,
                    fontWeight: expiringSoon
                        ? FontWeight.w600
                        : FontWeight.w400,
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
                '${widget.currency} '
                '${widget.sub.totalPaid.toStringAsFixed(2)}',
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Auto-renew',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: _autoRenew,
                      onChanged: _saving ? null : _toggleAutoRenew,
                      activeColor: AppColors.primaryAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _commitLabel(int months) {
    switch (months) {
      case 1:
        return 'Monthly';
      case 3:
        return '3 months';
      case 6:
        return '6 months';
      case 12:
        return 'Yearly';
      default:
        return '$months months';
    }
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
  }
}

class _EmptySubscriptions extends StatelessWidget {
  final String currency;
  const _EmptySubscriptions({required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.surfaceBorder),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Center(
        child: Text(
          "You don't have any active subscriptions yet. "
          "Top up at least one slot's worth in $currency, then "
          "tap Buy slots above.",
          style: AppTypography.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
