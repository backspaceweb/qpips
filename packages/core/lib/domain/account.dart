/// Domain model for a trading account as it flows between the
/// trading server, Supabase, and the UI.
///
/// Replaces the `Map<String, dynamic>` bag we used to pass around. Two
/// upstream sources (trading server REST + Supabase rows) have different
/// key casings and field names; [Account.fromMap] normalizes both.
library;

enum AccountType {
  master,
  slave;

  /// Wire string used by Supabase rows and the trading server.
  String get wireValue => this == AccountType.master ? 'Master' : 'Slave';

  static AccountType parse(dynamic value) {
    final s = value?.toString().toLowerCase().trim();
    if (s == 'slave' || s == 'follow') return AccountType.slave;
    return AccountType.master;
  }
}

enum Platform {
  mt4,
  mt5,
  ctrader,
  dxtrade,
  tradelocker,
  matchtrade;

  /// Wire string used by Supabase rows and the trading server.
  String get wireValue {
    switch (this) {
      case Platform.mt4:
        return 'MT4';
      case Platform.mt5:
        return 'MT5';
      case Platform.ctrader:
        return 'cTrader';
      case Platform.dxtrade:
        return 'DxTrade';
      case Platform.tradelocker:
        return 'TradeLocker';
      case Platform.matchtrade:
        return 'MatchTrade';
    }
  }

  static Platform parse(dynamic value) {
    final s = value?.toString().toLowerCase().trim();
    switch (s) {
      case 'mt5':
        return Platform.mt5;
      case 'ctrader':
        return Platform.ctrader;
      case 'dxtrade':
        return Platform.dxtrade;
      case 'tradelocker':
        return Platform.tradelocker;
      case 'matchtrade':
        return Platform.matchtrade;
      case 'mt4':
      default:
        return Platform.mt4;
    }
  }
}

class Account {
  /// The trading server's user ID for this account (returned by register*).
  /// This is the ID that activate / risk / delete endpoints expect.
  final int serverId;

  /// The platform login (e.g. MT5 account number) that the user types in.
  /// May or may not equal [serverId] depending on the platform.
  final String loginNumber;

  /// User-defined display name.
  final String accountName;

  final AccountType accountType;
  final Platform platform;

  /// Raw status string from the trading server. Upstream values are
  /// inconsistent ('CONNECTED'/'DISCONNECTED'/'Online'/'Offline') so we
  /// keep this as a String for now — see [isOnline] for the truth check.
  final String status;

  /// Display-formatted balance/equity. Currently placeholders ('0.00')
  /// because no live-balance endpoint is wired; will become real numbers
  /// when Step 3 lands the per-platform read endpoints.
  final String balance;
  final String equity;

  /// For slave accounts, the [serverId] of the master they follow.
  final int? masterId;

  const Account({
    required this.serverId,
    required this.loginNumber,
    required this.accountName,
    required this.accountType,
    required this.platform,
    this.status = 'Offline',
    this.balance = '0.00',
    this.equity = '0.00',
    this.masterId,
  });

  bool get isMaster => accountType == AccountType.master;
  bool get isOnline => status == 'CONNECTED' || status == 'Online';

  /// Build an Account from any of the upstream stringy maps we deal with:
  /// trading-server sync output (camelCase 'accountName', 'accountType', ...)
  /// or Supabase rows (snake_case 'account_name', 'account_type', ...).
  factory Account.fromMap(Map<String, dynamic> m) {
    final rawId = m['id'] ?? m['server_id'] ?? m['serverId'];
    final loginRaw = m['accountNumber'] ?? m['login_number'] ?? m['loginNumber'];

    return Account(
      serverId: _parseInt(rawId) ?? 0,
      loginNumber: (loginRaw ?? rawId ?? '').toString(),
      accountName: (m['accountName'] ?? m['account_name'] ?? '').toString(),
      accountType: AccountType.parse(m['accountType'] ?? m['account_type']),
      platform: Platform.parse(m['platform']),
      status: (m['status'] ?? 'Offline').toString(),
      balance: (m['balance'] ?? '0.00').toString(),
      equity: (m['equity'] ?? '0.00').toString(),
      masterId: _parseInt(m['masterId'] ?? m['master_id']),
    );
  }

  /// Shape we write to the Supabase `trading_accounts` table.
  Map<String, dynamic> toSupabaseRow() {
    return {
      'login_number': loginNumber,
      'account_name': accountName,
      'platform': platform.wireValue,
      'account_type': accountType.wireValue,
      'server_id': serverId.toString(),
      'master_id': masterId?.toString(),
    };
  }

  Account copyWith({
    int? serverId,
    String? loginNumber,
    String? accountName,
    AccountType? accountType,
    Platform? platform,
    String? status,
    String? balance,
    String? equity,
    int? masterId,
  }) {
    return Account(
      serverId: serverId ?? this.serverId,
      loginNumber: loginNumber ?? this.loginNumber,
      accountName: accountName ?? this.accountName,
      accountType: accountType ?? this.accountType,
      platform: platform ?? this.platform,
      status: status ?? this.status,
      balance: balance ?? this.balance,
      equity: equity ?? this.equity,
      masterId: masterId ?? this.masterId,
    );
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}
