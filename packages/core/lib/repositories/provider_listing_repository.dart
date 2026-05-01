import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/provider_listing.dart';

/// Owner-side reads + writes for `provider_listings`.
///
/// The Discover surface uses a separate read-path (E.1.3) that joins
/// `provider_listings` with `account_ownership` for the public card
/// model. This repository covers the *trader's own* application flow:
/// list mine, fetch by master, apply, edit, resubmit after rejection.
///
/// All writes go through Postgres directly under the trader's JWT —
/// the ownership trigger + RLS policies on the table enforce that a
/// trader can only see/touch their own rows.
abstract class ProviderListingRepository {
  /// All listings owned by the current trader (any status).
  Future<List<ProviderListing>> listMine();

  /// Listing for one specific master, or null if the trader hasn't
  /// applied for it yet. Used by the Accounts table to decide whether
  /// to show "Apply as Provider" vs the existing-listing status pill.
  Future<ProviderListing?> getByMasterAccountId(int masterAccountId);

  /// Submit a new application for one of the trader's masters.
  /// Returns the freshly-inserted row (status='pending').
  Future<ProviderListing> apply({
    required int masterAccountId,
    required String displayName,
    String? bio,
    double? minDeposit,
    String currency = 'USD',
  });

  /// Update an existing listing's trader-controlled fields. Operator-
  /// controlled fields (status, tier, gain_pct, etc) are unchanged —
  /// those flip via admin RPCs only.
  Future<ProviderListing> update({
    required String listingId,
    required String displayName,
    String? bio,
    double? minDeposit,
    String? currency,
  });

  /// Flip a rejected listing back to 'pending' so the admin queue
  /// picks it up again. Called when the trader edits + resubmits.
  Future<ProviderListing> resubmit(String listingId);

  // ---------------------------------------------------------------
  // Admin-side
  // ---------------------------------------------------------------

  /// All pending listings across all traders. Admin-only — returns
  /// empty for non-admins via RLS policy "provider_listings select
  /// admin". Newest application first.
  Future<List<ProviderListing>> listAllByStatus(ProviderListingStatus status);

  /// Set status='approved' + operator-controlled fields via the
  /// approve_provider_listing SECURITY DEFINER RPC. Admin-only.
  Future<void> approve({
    required String listingId,
    required String tier,
    required String riskScore,
    required double gainPct,
    required double drawdownPct,
    int followersCount = 0,
  });

  /// Set status='rejected' + reason via reject_provider_listing RPC.
  Future<void> reject({
    required String listingId,
    required String reason,
  });
}

class SupabaseProviderListingRepository implements ProviderListingRepository {
  final SupabaseClient _supabase;
  SupabaseProviderListingRepository(this._supabase);

  String get _myUserId {
    final id = _supabase.auth.currentUser?.id;
    if (id == null) {
      throw StateError('Not authenticated');
    }
    return id;
  }

  @override
  Future<List<ProviderListing>> listMine() async {
    final rows = await _supabase
        .from('provider_listings')
        .select()
        .eq('owner_user_id', _myUserId)
        .order('submitted_at', ascending: false);
    return (rows as List)
        .map((r) => ProviderListing.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProviderListing?> getByMasterAccountId(int masterAccountId) async {
    final rows = await _supabase
        .from('provider_listings')
        .select()
        .eq('owner_user_id', _myUserId)
        .eq('master_account_id', masterAccountId)
        .limit(1);
    final list = rows as List;
    if (list.isEmpty) return null;
    return ProviderListing.fromJson(list.first as Map<String, dynamic>);
  }

  @override
  Future<ProviderListing> apply({
    required int masterAccountId,
    required String displayName,
    String? bio,
    double? minDeposit,
    String currency = 'USD',
  }) async {
    final inserted = await _supabase
        .from('provider_listings')
        .insert({
          'master_account_id': masterAccountId,
          'owner_user_id': _myUserId,
          'display_name': displayName,
          'bio': bio,
          'min_deposit': minDeposit,
          'currency': currency,
        })
        .select()
        .single();
    return ProviderListing.fromJson(inserted);
  }

  @override
  Future<ProviderListing> update({
    required String listingId,
    required String displayName,
    String? bio,
    double? minDeposit,
    String? currency,
  }) async {
    final patch = <String, dynamic>{
      'display_name': displayName,
      'bio': bio,
      'min_deposit': minDeposit,
    };
    if (currency != null) patch['currency'] = currency;
    final updated = await _supabase
        .from('provider_listings')
        .update(patch)
        .eq('id', listingId)
        .eq('owner_user_id', _myUserId)
        .select()
        .single();
    return ProviderListing.fromJson(updated);
  }

  @override
  Future<ProviderListing> resubmit(String listingId) async {
    final updated = await _supabase
        .from('provider_listings')
        .update({
          'status': 'pending',
          'rejection_reason': null,
        })
        .eq('id', listingId)
        .eq('owner_user_id', _myUserId)
        .select()
        .single();
    return ProviderListing.fromJson(updated);
  }

  @override
  Future<List<ProviderListing>> listAllByStatus(
    ProviderListingStatus status,
  ) async {
    final rows = await _supabase
        .from('provider_listings')
        .select()
        .eq('status', status.name)
        .order('submitted_at', ascending: false);
    return (rows as List)
        .map((r) => ProviderListing.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> approve({
    required String listingId,
    required String tier,
    required String riskScore,
    required double gainPct,
    required double drawdownPct,
    int followersCount = 0,
  }) async {
    await _supabase.rpc(
      'approve_provider_listing',
      params: {
        'p_listing_id': listingId,
        'p_tier': tier,
        'p_risk_score': riskScore,
        'p_gain_pct': gainPct,
        'p_drawdown_pct': drawdownPct,
        'p_followers_count': followersCount,
      },
    );
  }

  @override
  Future<void> reject({
    required String listingId,
    required String reason,
  }) async {
    await _supabase.rpc(
      'reject_provider_listing',
      params: {
        'p_listing_id': listingId,
        'p_reason': reason,
      },
    );
  }
}
