/// Audit-log row for any change to a wallet's balance.
///
/// Pre-declared with all transaction types we expect across slices 1A
/// (deposit) and 1B (slot_purchase, slot_renewal, refund, adjustment).
/// 1A only ever inserts `deposit` rows; later slices add the others.
class WalletTransaction {
  final String id;
  final String walletId;
  final WalletTransactionType type;

  /// Signed amount: positive for credits (deposit, refund), negative
  /// for debits (slot_purchase, slot_renewal). `adjustment` can be
  /// either sign — used for manual operator corrections.
  final double amount;

  /// Wallet balance immediately after this transaction was applied.
  /// Stored alongside the transaction so the audit log is verifiable
  /// without replaying every prior row.
  final double balanceAfter;

  /// Free-text reference — bank txn id, crypto txid, Stripe charge id,
  /// internal note, etc. Operator-supplied for deposits; auto-filled
  /// for slot purchases (e.g. "subscription:abc123").
  final String? reference;

  /// Auth user that initiated the change. Admin user id for deposits;
  /// trader user id for slot purchases (when 1B ships).
  final String? createdBy;

  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    this.reference,
    this.createdBy,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      WalletTransaction(
        id: json['id'] as String,
        walletId: json['wallet_id'] as String,
        type: WalletTransactionType.fromString(json['type'] as String),
        amount: (json['amount'] as num).toDouble(),
        balanceAfter: (json['balance_after'] as num).toDouble(),
        reference: json['reference'] as String?,
        createdBy: json['created_by'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  bool get isCredit => amount > 0;
}

enum WalletTransactionType {
  deposit('deposit', 'Deposit'),
  slotPurchase('slot_purchase', 'Slot purchase'),
  slotRenewal('slot_renewal', 'Slot renewal'),
  refund('refund', 'Refund'),
  adjustment('adjustment', 'Adjustment');

  final String wireValue;
  final String displayLabel;
  const WalletTransactionType(this.wireValue, this.displayLabel);

  static WalletTransactionType fromString(String s) =>
      WalletTransactionType.values.firstWhere(
        (t) => t.wireValue == s,
        orElse: () => throw ArgumentError('Unknown wallet transaction type: $s'),
      );
}

/// Result returned by `confirm_deposit` RPC.
class DepositResult {
  final String transactionId;
  final double newBalance;

  const DepositResult({required this.transactionId, required this.newBalance});
}
