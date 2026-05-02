import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/admin_alert.dart';

/// Operator-side reads + writes for admin-only configuration and the
/// alert inbox. All methods are admin-gated server-side via RLS / RPC
/// security checks; non-admin callers will see permission errors.
///
/// Today this covers:
///   * `account_limit` — the operator's bought capacity from the trading
///     API team. Read by the slot inventory bar; written by the admin
///     when they buy more capacity.
///   * `admin_alerts` — un-dismissed alerts surfaced as a banner on the
///     Plans tab. The only writer is `check_capacity_alerts()` on a
///     pg_cron schedule.
///
/// Future capacity for this repository: notification channel config,
/// rate-limit thresholds, audit-log queries.
abstract class OperatorRepository {
  /// Reads the current `account_limit` from `operator_settings`.
  /// Returns null if unset (fresh install before the migration's seed,
  /// or if the row was deleted by hand).
  Future<int?> getAccountLimit();

  /// Updates `account_limit`. Throws if not admin or if [value] < 0.
  Future<int> setAccountLimit(int value);

  /// Lists un-dismissed alerts, newest first. The Plans tab banner
  /// renders this list directly.
  Future<List<AdminAlert>> listActiveAlerts();

  /// Marks an alert as dismissed by the calling admin. Returns the
  /// updated row so the UI can patch local state without a roundtrip.
  Future<AdminAlert> dismissAlert(String alertId);

  /// Runs `check_capacity_alerts()` on demand — same SQL the hourly
  /// cron runs, but immediate. Useful for smoke-testing thresholds and
  /// for "Run check now" buttons on the admin UI.
  Future<void> runCapacityCheck();
}

class SupabaseOperatorRepository implements OperatorRepository {
  final SupabaseClient _client;

  SupabaseOperatorRepository(this._client);

  @override
  Future<int?> getAccountLimit() async {
    final rows = await _client
        .from('operator_settings')
        .select('value')
        .eq('key', 'account_limit')
        .limit(1);
    final list = rows as List;
    if (list.isEmpty) return null;
    final raw = (list.first as Map<String, dynamic>)['value'];
    // operator_settings.value is jsonb. supabase-dart returns it
    // already-decoded — int is the common case for account_limit.
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  @override
  Future<int> setAccountLimit(int value) async {
    final result = await _client.rpc(
      'set_account_limit',
      params: {'p_value': value},
    );
    if (result is int) return result;
    if (result is num) return result.toInt();
    throw StateError(
      'set_account_limit returned unexpected shape: ${result.runtimeType}',
    );
  }

  @override
  Future<List<AdminAlert>> listActiveAlerts() async {
    final rows = await _client
        .from('admin_alerts')
        .select()
        .filter('dismissed_at', 'is', null)
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => AdminAlert.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AdminAlert> dismissAlert(String alertId) async {
    final result = await _client.rpc(
      'dismiss_admin_alert',
      params: {'p_alert_id': alertId},
    );
    final row = _firstRow(result);
    return AdminAlert.fromJson(row);
  }

  @override
  Future<void> runCapacityCheck() async {
    await _client.rpc('check_capacity_alerts');
  }

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
