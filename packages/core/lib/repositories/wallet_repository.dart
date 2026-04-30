import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/wallet.dart';
import '../domain/wallet_transaction.dart';

/// Reads + writes against the wallets / wallet_transactions tables.
///
/// Two distinct contexts share this repo:
///   - **Trader app:** reads own wallet + transaction history. RLS
///     guarantees they can only see their own.
///   - **Admin app:** reads all wallets + writes deposits via the
///     `confirm_deposit` RPC (which itself checks admin role).
///
/// 1A surfaces deposit only. Slot-purchase / renewal RPCs land in 1B
/// and add corresponding methods here.
abstract class WalletRepository {
  // ---- Trader-side ----
  Future<Wallet?> getMyWallet();
  Future<List<WalletTransaction>> getMyTransactions({int limit = 50});

  // ---- Admin-side ----
  Future<List<WalletWithProfile>> listAllWallets();
  Future<List<WalletTransaction>> getTransactionsForWallet(
    String walletId, {
    int limit = 50,
  });
  Future<DepositResult> confirmDeposit({
    required String targetUserId,
    required double amount,
    required String reference,
  });
}

class SupabaseWalletRepository implements WalletRepository {
  final SupabaseClient _client;

  SupabaseWalletRepository(this._client);

  @override
  Future<Wallet?> getMyWallet() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final row = await _client
        .from('wallets')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();
    if (row == null) return null;
    return Wallet.fromJson(row);
  }

  @override
  Future<List<WalletTransaction>> getMyTransactions({int limit = 50}) async {
    final wallet = await getMyWallet();
    if (wallet == null) return const [];
    return getTransactionsForWallet(wallet.id, limit: limit);
  }

  @override
  Future<List<WalletWithProfile>> listAllWallets() async {
    // Two queries — wallets joined to profiles in Dart, since the FK
    // chain (wallets.user_id → auth.users.id ← profiles.user_id) doesn't
    // give PostgREST a direct embedding hint. Cheap at our row counts.
    final walletRows = await _client
        .from('wallets')
        .select()
        .order('updated_at', ascending: false);
    final profileRows = await _client.from('profiles').select();

    final profilesByUserId = <String, Map<String, dynamic>>{};
    for (final p in profileRows as List) {
      final m = p as Map<String, dynamic>;
      profilesByUserId[m['user_id'] as String] = m;
    }

    return (walletRows as List).map((r) {
      final m = r as Map<String, dynamic>;
      final wallet = Wallet.fromJson(m);
      final profile = profilesByUserId[wallet.userId];
      return WalletWithProfile(
        wallet: wallet,
        displayName: profile?['display_name'] as String?,
        role: (profile?['role'] as String?) ?? 'trader',
      );
    }).toList();
  }

  @override
  Future<List<WalletTransaction>> getTransactionsForWallet(
    String walletId, {
    int limit = 50,
  }) async {
    final rows = await _client
        .from('wallet_transactions')
        .select()
        .eq('wallet_id', walletId)
        .order('created_at', ascending: false)
        .limit(limit);
    return (rows as List)
        .map((r) => WalletTransaction.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DepositResult> confirmDeposit({
    required String targetUserId,
    required double amount,
    required String reference,
  }) async {
    final result = await _client.rpc(
      'confirm_deposit',
      params: {
        'target_user_id': targetUserId,
        'deposit_amount': amount,
        'deposit_reference': reference,
      },
    );
    // RPC returns a TABLE — supabase-dart surfaces this as a List of
    // Maps. Take the first row.
    final list = (result as List).cast<Map<String, dynamic>>();
    if (list.isEmpty) {
      throw StateError('confirm_deposit returned no rows');
    }
    final row = list.first;
    return DepositResult(
      transactionId: row['transaction_id'] as String,
      newBalance: (row['new_balance'] as num).toDouble(),
    );
  }
}
