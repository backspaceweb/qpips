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
