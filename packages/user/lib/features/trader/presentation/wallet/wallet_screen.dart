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
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (_) => const _TopUpInstructions(),
    );
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BalanceHero(
                      wallet: data.wallet!,
                      onTopUp: _showTopUpSheet,
                    ),
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
//  Top Up sheet
// =============================================================================

class _TopUpInstructions extends StatelessWidget {
  const _TopUpInstructions();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child:
                      Text('Top up your wallet', style: AppTypography.titleLarge),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Send any amount via the channels below. Once we receive '
              'your payment, we\'ll credit your wallet within one business '
              'day. You\'ll see the deposit appear here as a transaction.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bank transfer', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Bank: [Operator to fill in]\n'
                    'Account name: [Operator to fill in]\n'
                    'Account number: [Operator to fill in]\n'
                    'Reference: your registered email',
                    style: AppTypography.bodySmall.copyWith(
                      fontFamily: AppTypography.monoFontFamily,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Stripe Checkout for instant top-up lands soon. For now, '
              'send a message to support@quantumpips.app with your '
              'transfer reference and we\'ll confirm within a few hours.',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
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
//  Active subscriptions
// =============================================================================

class _SubscriptionRow extends StatelessWidget {
  final UserSubscription sub;
  final String currency;
  const _SubscriptionRow({required this.sub, required this.currency});

  @override
  Widget build(BuildContext context) {
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
              sub.tier.displayLabel.toUpperCase(),
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
                  '${sub.slotCount} slot${sub.slotCount == 1 ? '' : 's'} · '
                  '${_commitLabel(sub.commitmentMonths)}',
                  style: AppTypography.titleMedium.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'Expires ${_formatDate(sub.expiresAt)}'
                  '${sub.autoRenew ? ' · auto-renew on' : ''}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$currency ${sub.totalPaid.toStringAsFixed(2)}',
            style: AppTypography.titleMedium.copyWith(
              fontSize: 13,
              color: AppColors.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
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
