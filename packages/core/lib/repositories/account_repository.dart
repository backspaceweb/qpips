import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/account_ownership.dart';

/// Reads against `account_ownership` (the trader's view of which
/// trading accounts they own) + `get_my_slot_usage()` RPC for the
/// header progress bar.
///
/// Mutations don't go through here — they happen via TradingRepository
/// (which calls the Chopper-generated register/delete endpoints).
/// The trading-proxy Edge Function intercepts those calls, runs the
/// quota gate, and writes/deletes the ownership row atomically with the
/// trading API call. So a successful register* via TradingRepository
/// implicitly creates the account_ownership row server-side.
abstract class AccountRepository {
  Future<List<AccountOwnership>> listMyAccounts();
  Future<SlotUsage> getMySlotUsage();
}

class SupabaseAccountRepository implements AccountRepository {
  final SupabaseClient _client;
  SupabaseAccountRepository(this._client);

  @override
  Future<List<AccountOwnership>> listMyAccounts() async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];
    final rows = await _client
        .from('account_ownership')
        .select()
        .eq('user_id', user.id)
        .order('registered_at', ascending: false);
    return (rows as List)
        .map((r) => AccountOwnership.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<SlotUsage> getMySlotUsage() async {
    if (_client.auth.currentUser == null) return SlotUsage.empty;
    final result = await _client.rpc('get_my_slot_usage');
    if (result is List && result.isNotEmpty) {
      return SlotUsage.fromJson(result.first as Map<String, dynamic>);
    }
    if (result is Map<String, dynamic>) {
      return SlotUsage.fromJson(result);
    }
    return SlotUsage.empty;
  }
}
