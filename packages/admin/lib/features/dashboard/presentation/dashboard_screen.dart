import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/repositories/auth_repository.dart';
import 'package:qp_core/repositories/subscription_repository.dart';
import 'package:qp_core/repositories/trading_repository.dart';
import 'package:qp_design/app_colors.dart';

import '../../plans/presentation/plans_screen.dart';
import '../../wallets/presentation/wallets_screen.dart';
import 'widgets/price_ticker.dart';

/// Operator dashboard.
///
/// Post-Slice-B.3 the admin is a thin operations console: 4 metric
/// cards (Total Accounts / Account Limit / User Slot Booked /
/// Active Trades) + a price ticker. Trader-account management
/// (registration, settings, deletion, open orders, history) lives
/// entirely on the user app's Accounts tab. Wallet deposits + slot
/// pricing remain admin-side via the Wallets and Plans nav entries.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  bool _isSidebarCollapsed = false;
  bool _isLoading = true;
  Map<String, dynamic> _metrics = {
    'totalAccounts': '0',
    'accountLimit': '--',
    'activeTrades': 'No active trades',
    'latency': 'Checking...',
  };
  int _userSlotBooked = 0;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Smart sync: only re-fetch metrics when the operator brings the
    // tab back to foreground.
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) print('DEBUG: App resumed, refreshing metrics...');
      _refreshData(silent: true);
    }
  }

  Future<void> _refreshData({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    final repo = context.read<TradingRepository>();
    final subs = context.read<SubscriptionRepository>();

    final results = await Future.wait([
      repo.getDashboardMetrics(),
      subs.getActiveSlotCount(),
    ]);

    if (mounted) {
      setState(() {
        _metrics = results[0] as Map<String, dynamic>;
        _userSlotBooked = results[1] as int;
        if (!silent) _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.surfaceDark : AppColors.surfaceMuted,
      body: Row(
        children: [
          _buildSidebar(isDark, AppColors.primaryAccent),
          Expanded(
            child: Column(
              children: [
                _buildHeader(isDark),
                const PriceTicker(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    color: AppColors.primaryAccent,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(32),
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildMetricCards(isDark),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(bool isDark, Color primary) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isSidebarCollapsed ? 80 : 260,
      color: isDark ? AppColors.surfaceDarkRaised : AppColors.surface,
      child: Column(
        children: [
          const SizedBox(height: 24),
          IconButton(
            icon: Icon(
                _isSidebarCollapsed ? Icons.menu_open : Icons.menu,
                color: primary),
            onPressed: () =>
                setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
          ),
          if (!_isSidebarCollapsed) ...[
            const SizedBox(height: 20),
            const Text('QuantumPips',
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ],
          const SizedBox(height: 40),
          _buildNavItem(
            Icons.dashboard_outlined,
            'Dashboard',
            true,
            primary,
            onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
          ),
          _buildNavItem(
            Icons.account_balance_wallet_outlined,
            'Wallets',
            false,
            primary,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const WalletsScreen(),
              ),
            ),
          ),
          _buildNavItem(
            Icons.confirmation_number_outlined,
            'Plans',
            false,
            primary,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const PlansScreen(),
              ),
            ),
          ),
          _buildNavItem(
            Icons.analytics_outlined,
            'Analytics',
            false,
            primary,
            onTap: () => _comingSoon(context, 'Analytics'),
          ),
          _buildNavItem(
            Icons.settings_outlined,
            'Settings',
            false,
            primary,
            onTap: () => _comingSoon(context, 'Settings'),
          ),
          const Spacer(),
          _buildNavItem(Icons.logout, 'Logout', false, Colors.redAccent,
              onTap: () async {
            await context.read<AuthRepository>().signOut();
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/registration');
            }
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool active, Color color,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: active ? color : Colors.grey, size: 22),
      title: _isSidebarCollapsed
          ? null
          : Text(label,
              style: TextStyle(
                  color: active ? color : Colors.grey,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      onTap: onTap,
    );
  }

  void _comingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label section coming soon.'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      color: isDark ? AppColors.surfaceDarkRaised : AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Trading Dashboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          CircleAvatar(radius: 18, backgroundColor: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildMetricCards(bool isDark) {
    return Row(
      children: [
        _buildMetricCard(
            'Total Accounts',
            _metrics['totalAccounts']?.toString() ?? '0',
            Icons.account_balance,
            Colors.blue,
            isDark),
        const SizedBox(width: 24),
        _buildMetricCard(
            'Account Limit',
            _metrics['accountLimit']?.toString() ?? '--',
            Icons.lock_clock,
            Colors.orange,
            isDark),
        const SizedBox(width: 24),
        _buildMetricCard(
            'User Slot Booked',
            _userSlotBooked.toString(),
            Icons.confirmation_number_outlined,
            AppColors.primaryAccent,
            isDark),
        const SizedBox(width: 24),
        _buildMetricCard(
            'Active Trades',
            _metrics['activeTrades']?.toString() ?? 'No active trades',
            Icons.trending_up,
            Colors.green,
            isDark),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDarkRaised : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDark
                  ? Colors.white10
                  : Colors.black.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
