import 'package:flutter/material.dart';

/// Top-level sections of the trader app, exposed as sidebar items on
/// web and bottom-tab items on mobile. Order matters — both layouts
/// render in this order.
enum TraderTab {
  discover('Discover', Icons.explore_outlined, Icons.explore),
  myFollows('My Follows', Icons.bookmark_outline, Icons.bookmark),
  accounts(
    'Accounts',
    Icons.account_balance_outlined,
    Icons.account_balance,
  ),
  wallet(
    'Wallet',
    Icons.account_balance_wallet_outlined,
    Icons.account_balance_wallet,
  ),
  plans(
    'Plans',
    Icons.confirmation_number_outlined,
    Icons.confirmation_number,
  ),
  settings('Settings', Icons.settings_outlined, Icons.settings);

  final String label;
  final IconData icon;
  final IconData activeIcon;
  const TraderTab(this.label, this.icon, this.activeIcon);
}

/// Holds + broadcasts the active trader tab so descendants can request
/// cross-tab jumps (e.g. the "Browse providers" CTA on My Follows' empty
/// state needs to flip the shell to the Discover tab).
///
/// Owned by `TraderShell` and provided to its subtree. Phase E will
/// likely retire this in favour of go_router URLs — at that point the
/// callers can switch to `Navigator.of(context).pushNamed('/discover')`
/// without touching this controller's API.
class TraderTabController extends ChangeNotifier {
  TraderTab _active = TraderTab.discover;
  TraderTab get active => _active;

  void setTab(TraderTab tab) {
    if (_active == tab) return;
    _active = tab;
    notifyListeners();
  }
}
