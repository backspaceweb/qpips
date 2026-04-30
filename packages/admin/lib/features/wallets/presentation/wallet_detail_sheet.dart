import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/wallet.dart';
import 'package:qp_core/domain/wallet_transaction.dart';
import 'package:qp_core/repositories/wallet_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Wallet detail bottom sheet — transaction history + Confirm Deposit form.
///
/// Returns `true` from the sheet on successful deposit so the caller
/// can refresh the wallets list.
class WalletDetailSheet extends StatefulWidget {
  final WalletWithProfile entry;

  const WalletDetailSheet({super.key, required this.entry});

  @override
  State<WalletDetailSheet> createState() => _WalletDetailSheetState();
}

class _WalletDetailSheetState extends State<WalletDetailSheet> {
  late Future<List<WalletTransaction>> _txFuture;
  bool _didDeposit = false;

  late double _liveBalance;

  @override
  void initState() {
    super.initState();
    _liveBalance = widget.entry.wallet.balance;
    _txFuture = _loadTx();
  }

  Future<List<WalletTransaction>> _loadTx() {
    return context
        .read<WalletRepository>()
        .getTransactionsForWallet(widget.entry.wallet.id);
  }

  void _onDepositConfirmed(double newBalance) {
    setState(() {
      _liveBalance = newBalance;
      _didDeposit = true;
      _txFuture = _loadTx();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.entry.wallet;
    return Column(
      children: [
        _Header(
          displayName: widget.entry.displayName,
          balance: _liveBalance,
          currency: w.currency,
          onClose: () => Navigator.of(context).pop(_didDeposit),
        ),
        const Divider(height: 1, color: AppColors.surfaceBorder),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              _DepositForm(
                targetUserId: w.userId,
                currency: w.currency,
                onConfirmed: _onDepositConfirmed,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Transaction history', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.md),
              FutureBuilder<List<WalletTransaction>>(
                future: _txFuture,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryAccent,
                        ),
                      ),
                    );
                  }
                  if (snap.hasError) {
                    return Text(
                      "Couldn't load transactions: ${snap.error}",
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.loss,
                      ),
                    );
                  }
                  final txs = snap.data ?? const [];
                  if (txs.isEmpty) {
                    return _EmptyHistory(currency: w.currency);
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.surfaceBorder),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < txs.length; i++) ...[
                          _TransactionRow(
                            tx: txs[i],
                            currency: w.currency,
                          ),
                          if (i != txs.length - 1)
                            const Divider(
                              height: 1,
                              color: AppColors.surfaceBorder,
                            ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
//  Header
// =============================================================================

class _Header extends StatelessWidget {
  final String? displayName;
  final double balance;
  final String currency;
  final VoidCallback onClose;

  const _Header({
    required this.displayName,
    required this.balance,
    required this.currency,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName ?? '(no display name)',
                  style: AppTypography.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$currency ${balance.toStringAsFixed(2)}',
                  style: AppTypography.numericMedium.copyWith(
                    fontSize: 28,
                    color: balance > 0
                        ? AppColors.profit
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textMuted),
            onPressed: onClose,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Confirm Deposit form
// =============================================================================

class _DepositForm extends StatefulWidget {
  final String targetUserId;
  final String currency;
  final ValueChanged<double> onConfirmed;

  const _DepositForm({
    required this.targetUserId,
    required this.currency,
    required this.onConfirmed,
  });

  @override
  State<_DepositForm> createState() => _DepositFormState();
}

class _DepositFormState extends State<_DepositForm> {
  final _amountCtrl = TextEditingController();
  final _refCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _refCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    final reference = _refCtrl.text.trim();
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a positive amount.');
      return;
    }
    if (reference.isEmpty) {
      setState(() => _error = 'Reference is required for audit.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final result = await context.read<WalletRepository>().confirmDeposit(
            targetUserId: widget.targetUserId,
            amount: amount,
            reference: reference,
          );
      if (!mounted) return;
      _amountCtrl.clear();
      _refCtrl.clear();
      setState(() => _submitting = false);
      widget.onConfirmed(result.newBalance);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Deposit confirmed. New balance: '
            '${widget.currency} ${result.newBalance.toStringAsFixed(2)}.',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Confirm deposit',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Records a deposit on this wallet. Use the bank txn id, '
            'crypto txid, or any reference traceable to the actual '
            'incoming payment.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _amountCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: _inputDecoration().copyWith(
                    hintText: 'Amount',
                    prefixText: '${widget.currency} ',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _refCtrl,
                  decoration: _inputDecoration().copyWith(
                    hintText: 'Reference (txn id / note)',
                  ),
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.loss),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.textOnDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textOnDark,
                      ),
                    )
                  : const Text('Confirm deposit'),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() => InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.surfaceBorder),
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
      );
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${positive ? '+' : ''}'
                '$currency ${tx.amount.toStringAsFixed(2)}',
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 14,
                  color: positive ? AppColors.profit : AppColors.loss,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$currency ${tx.balanceAfter.toStringAsFixed(2)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
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
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Center(
        child: Text(
          'No transactions yet — confirm a $currency deposit above to seed.',
          style: AppTypography.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
