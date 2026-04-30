/// QuantumPips trader wallet — fiat balance held in operator's Supabase.
///
/// One per user, auto-created via trigger on `auth.users` insert. Balance
/// is updated only via RPCs (`confirm_deposit`, future slot-purchase
/// RPCs) — never written to directly. RLS allows owner + admin reads.
class Wallet {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        balance: (json['balance'] as num).toDouble(),
        currency: json['currency'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}

/// Joined wallet + display info shown in the admin wallets list.
class WalletWithProfile {
  final Wallet wallet;
  final String? displayName;
  final String role;

  const WalletWithProfile({
    required this.wallet,
    required this.role,
    this.displayName,
  });
}
