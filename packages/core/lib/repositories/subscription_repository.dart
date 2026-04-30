import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/plan_tier.dart';
import '../domain/user_subscription.dart';

/// Reads + writes against the slot-subscription tables.
///
/// Three concerns share this repo:
///   - **Trader app:** lists own subscriptions, books new slots via
///     the `book_slots` RPC (which atomically debits wallet + inserts
///     a subscription row + writes a wallet_transaction).
///   - **Admin app:** reads all subscriptions, updates tier / discount
///     pricing via admin-only RPCs, and reads aggregate metrics
///     (total active slots) for the dashboard card.
///   - **Both:** read the public pricing tables (any authenticated
///     user can see current pricing — required to render the Buy Slots
///     screen, and trivially harmless because pricing is intended to
///     be operator-published).
///
/// 1C will add `cancelSubscription`, auto-renewal logic; 1B is
/// purchase-only.
abstract class SubscriptionRepository {
  // ---- Pricing config (read by both, written by admin) ----
  Future<List<PlanTierConfig>> listTierConfigs();
  Future<List<CommitmentDiscount>> listCommitmentDiscounts();
  Future<PlanTierConfig> updateTierConfig({
    required PlanTier tier,
    required int minSlots,
    int? maxSlots,
    required double basePricePerSlot,
  });
  Future<CommitmentDiscount> updateCommitmentDiscount({
    required int commitmentMonths,
    required double discountPercent,
  });

  // ---- Trader-side ----
  Future<List<UserSubscription>> getMyActiveSubscriptions();
  Future<BookSlotsResult> bookSlots({
    required int slotCount,
    required int commitmentMonths,
  });

  // ---- Admin-side ----
  Future<List<UserSubscription>> listAllSubscriptions();

  /// Sum of [UserSubscription.slotCount] across rows where status =
  /// 'active'. Drives the "User Slot Booked" metric card.
  Future<int> getActiveSlotCount();
}

class SupabaseSubscriptionRepository implements SubscriptionRepository {
  final SupabaseClient _client;

  SupabaseSubscriptionRepository(this._client);

  @override
  Future<List<PlanTierConfig>> listTierConfigs() async {
    final rows = await _client
        .from('plan_tier_config')
        .select()
        .order('min_slots', ascending: true);
    return (rows as List)
        .map((r) => PlanTierConfig.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CommitmentDiscount>> listCommitmentDiscounts() async {
    final rows = await _client
        .from('commitment_discount')
        .select()
        .order('commitment_months', ascending: true);
    return (rows as List)
        .map((r) => CommitmentDiscount.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PlanTierConfig> updateTierConfig({
    required PlanTier tier,
    required int minSlots,
    int? maxSlots,
    required double basePricePerSlot,
  }) async {
    final result = await _client.rpc(
      'update_tier_config',
      params: {
        'p_tier': tier.wireValue,
        'p_min_slots': minSlots,
        'p_max_slots': maxSlots,
        'p_base_price_per_slot': basePricePerSlot,
      },
    );
    // RPC returns a row — supabase-dart unboxes a single-record set as
    // a Map directly (or List with one entry depending on driver mood).
    final row = _firstRow(result);
    return PlanTierConfig.fromJson(row);
  }

  @override
  Future<CommitmentDiscount> updateCommitmentDiscount({
    required int commitmentMonths,
    required double discountPercent,
  }) async {
    final result = await _client.rpc(
      'update_commitment_discount',
      params: {
        'p_commitment_months': commitmentMonths,
        'p_discount_percent': discountPercent,
      },
    );
    final row = _firstRow(result);
    return CommitmentDiscount.fromJson(row);
  }

  @override
  Future<List<UserSubscription>> getMyActiveSubscriptions() async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];
    final rows = await _client
        .from('user_subscriptions')
        .select()
        .eq('user_id', user.id)
        .eq('status', 'active')
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => UserSubscription.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BookSlotsResult> bookSlots({
    required int slotCount,
    required int commitmentMonths,
  }) async {
    final result = await _client.rpc(
      'book_slots',
      params: {
        'p_slot_count': slotCount,
        'p_commitment_months': commitmentMonths,
      },
    );
    final list = (result as List).cast<Map<String, dynamic>>();
    if (list.isEmpty) {
      throw StateError('book_slots returned no rows');
    }
    final row = list.first;
    return BookSlotsResult(
      subscriptionId: row['subscription_id'] as String,
      totalPaid: (row['total_paid'] as num).toDouble(),
      expiresAt: DateTime.parse(row['expires_at'] as String),
      newWalletBalance: (row['new_wallet_balance'] as num).toDouble(),
    );
  }

  @override
  Future<List<UserSubscription>> listAllSubscriptions() async {
    final rows = await _client
        .from('user_subscriptions')
        .select()
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => UserSubscription.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getActiveSlotCount() async {
    final rows = await _client
        .from('user_subscriptions')
        .select('slot_count')
        .eq('status', 'active');
    var total = 0;
    for (final r in rows as List) {
      total += (r as Map<String, dynamic>)['slot_count'] as int;
    }
    return total;
  }

  /// Normalises Supabase RPC return values. RPCs that `RETURNS row` /
  /// `RETURNS table` come back as a List in supabase-dart 2.x; legacy
  /// drivers return a single Map. Handle both.
  Map<String, dynamic> _firstRow(dynamic result) {
    if (result is List) {
      if (result.isEmpty) {
        throw StateError('RPC returned empty list');
      }
      return result.first as Map<String, dynamic>;
    }
    if (result is Map<String, dynamic>) return result;
    throw StateError('Unexpected RPC return shape: ${result.runtimeType}');
  }
}
