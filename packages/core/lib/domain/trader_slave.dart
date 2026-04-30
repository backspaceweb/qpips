import 'account.dart';

/// A trader-owned slave account, as it appears in the trader app.
///
/// Differs from the admin-side [Account] in framing: the admin sees
/// every slave under the operator key; a trader sees only their own,
/// with display names + balance information they need to make the
/// follow / pause / unfollow decision.
///
/// Phase E joins `slave_ownership` (Supabase) → trading_accounts +
/// per-account live state from the trading API. Today (D.5) the trader
/// repository serves these from a deterministic mock.
class TraderSlaveAccount {
  /// Trading-server account ID. String for forward-compat.
  final String id;

  /// Trader-set display label ("Main Slave", "XAU experiment").
  final String displayName;

  final Platform platform;

  /// Display-only broker ("Exness", "IC Markets").
  final String broker;

  /// Login number on the broker side. Shown small + monospaced; used
  /// only to disambiguate when a trader has multiple slaves on the
  /// same broker.
  final String loginNumber;

  final double balance;
  final double equity;
  final String currency;

  /// True when the slave is currently bound to a master (following).
  /// On Configure Follow, slaves with [followingMasterDisplayName] != null
  /// can still be re-bound — the server replaces the binding.
  final String? followingMasterDisplayName;

  /// Slave is paused — trader has temporarily stopped mirroring.
  final bool isPaused;

  const TraderSlaveAccount({
    required this.id,
    required this.displayName,
    required this.platform,
    required this.broker,
    required this.loginNumber,
    required this.balance,
    required this.equity,
    required this.currency,
    this.followingMasterDisplayName,
    this.isPaused = false,
  });

  bool get hasExistingBinding => followingMasterDisplayName != null;
}
