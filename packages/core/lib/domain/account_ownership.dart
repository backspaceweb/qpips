import 'account.dart';

/// One row in `account_ownership`. Represents a single trading account
/// (master OR slave) registered by a specific trader. The Edge Function
/// writes this row when the trading API confirms registration.
///
/// Two IDs:
///   * [tradingAccountId] — the trading API's internal serverId,
///     returned in the register response. Used for masterId binding,
///     delete endpoints, and any other API call that needs to address
///     this account. Internal glue — not shown to traders.
///   * [loginNumber] — the broker login the trader typed in. Display-
///     only; what the trader recognises as "their account number".
///
/// Live state (connection, balance) comes from the trading API
/// separately and gets joined in the UI. This object is purely the
/// ownership/identity record from Supabase.
class AccountOwnership {
  /// Trading API's internal serverId. Primary key. Pass this as
  /// `masterId` when registering a slave that follows this master.
  final int tradingAccountId;

  /// Broker login number — what the trader typed when registering.
  /// Display only; never sent to the trading API beyond the initial
  /// register call.
  final String loginNumber;

  final String userId;
  final Platform platform;
  final AccountType accountType;

  /// Trader-set label. Optional (uses login number when blank).
  final String? displayName;

  final DateTime registeredAt;

  /// Slot expired and the cron picked this account to "uncover". When
  /// true, the trading proxy refuses mirror calls; trader needs to
  /// re-up to reactivate (see slice B.4).
  final bool mirroringDisabled;

  const AccountOwnership({
    required this.tradingAccountId,
    required this.loginNumber,
    required this.userId,
    required this.platform,
    required this.accountType,
    this.displayName,
    required this.registeredAt,
    required this.mirroringDisabled,
  });

  factory AccountOwnership.fromJson(Map<String, dynamic> json) =>
      AccountOwnership(
        tradingAccountId: (json['trading_account_id'] as num).toInt(),
        loginNumber: json['login_number']?.toString() ??
            (json['trading_account_id'] as num).toInt().toString(),
        userId: json['user_id'] as String,
        platform: Platform.parse(json['platform']),
        accountType: AccountType.parse(json['account_type']),
        displayName: json['display_name'] as String?,
        registeredAt: DateTime.parse(json['registered_at'] as String),
        mirroringDisabled: json['mirroring_disabled'] as bool? ?? false,
      );

  /// Falls back to login number when [displayName] is null/empty.
  String get effectiveLabel {
    final n = displayName?.trim();
    if (n == null || n.isEmpty) return loginNumber;
    return n;
  }
}

/// `(used, quota)` pair returned by `get_my_slot_usage()` RPC.
///
/// `used`  = count of trader's owned accounts (account_ownership rows).
/// `quota` = sum of slot_count across active subscriptions.
/// `free`  = quota − used (≥ 0; clamped, never negative for display).
class SlotUsage {
  final int used;
  final int quota;

  const SlotUsage({required this.used, required this.quota});

  factory SlotUsage.fromJson(Map<String, dynamic> json) => SlotUsage(
        used: (json['used'] as num).toInt(),
        quota: (json['quota'] as num).toInt(),
      );

  static const empty = SlotUsage(used: 0, quota: 0);

  int get free => (quota - used).clamp(0, 1 << 31);
  bool get exhausted => quota == 0 || used >= quota;

  /// 0–1 fraction for the progress bar. Clamps at 1.0 if used > quota.
  double get fraction {
    if (quota <= 0) return 1.0;
    return (used / quota).clamp(0.0, 1.0);
  }
}
