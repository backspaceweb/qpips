import 'dart:async';
import 'widgets/price_ticker.dart';
import 'widgets/mt5_risk_dialog.dart';
import 'widgets/account_details_sheet.dart';
import '../../wallets/presentation/wallets_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account.dart';
import 'package:qp_core/repositories/trading_repository.dart';
import 'package:qp_core/repositories/auth_repository.dart';
import 'package:qp_design/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with WidgetsBindingObserver {
  bool _isSidebarCollapsed = false;
  bool _isLoading = true;
  Map<String, dynamic> _metrics = {
    'totalAccounts': '0',
    'accountLimit': '--',
    'activeTrades': 'No active trades',
    'latency': 'Checking...',
  };
  List<Account> _accounts = [];
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadInitialData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // SMART SYNC: Only fetch data when the user actually brings the app to foreground
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) print('DEBUG: App resumed, triggering smart sync...');
      _refreshData(silent: true);
    }
  }

  Future<void> _loadInitialData({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);

    final repo = context.read<TradingRepository>();
    final synchedAccounts = await repo.syncAccountsWithServer();

    if (mounted) {
      setState(() {
        _accounts = synchedAccounts;
        if (!silent) _isLoading = false;
      });
    }

    _refreshData(silent: silent);
  }

  Future<void> _refreshData({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    final repo = context.read<TradingRepository>();

    final results = await Future.wait([
      repo.getDashboardMetrics(),
      repo.syncAccountsWithServer(),
    ]);

    if (mounted) {
      setState(() {
        _metrics = results[0] as Map<String, dynamic>;
        _accounts = results[1] as List<Account>;
        if (!silent) _isLoading = false;
      });
    }
  }

  // Conservative loop to "catch" new accounts without spamming the API
  void _startDiscoveryLoop({int retries = 3}) async {
    if (retries <= 0 || !mounted) return;

    if (kDebugMode) print('DEBUG: Discovery Loop pulse ($retries retries left)');
    await _loadInitialData(silent: true);

    // Check if we still have temporary IDs (long IDs like 415614138)
    final hasTempIds = _accounts.any((a) => a.serverId.toString().length > 8);

    if (hasTempIds) {
      // Wait 5 seconds between retries instead of 2
      Future.delayed(const Duration(seconds: 5), () => _startDiscoveryLoop(retries: retries - 1));
    } else {
      if (kDebugMode) print('DEBUG: Discovery successful, all IDs permanent.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceMuted,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAccountForm(context),
        backgroundColor: AppColors.primaryAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Row(
        children: [
          _buildSidebar(isDark, AppColors.primaryAccent),
          Expanded(
            child: Column(
              children: [
                _buildHeader(isDark, AppColors.primaryAccent),
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
                              const SizedBox(height: 40),
                              _buildAccountTable(isDark),
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
            icon: Icon(_isSidebarCollapsed ? Icons.menu_open : Icons.menu, color: primary),
            onPressed: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
          ),
          if (!_isSidebarCollapsed) ...[
            const SizedBox(height: 20),
            const Text('QuantumPips', style: TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
          const SizedBox(height: 40),
          _buildNavItem(
            Icons.dashboard_outlined,
            'Dashboard',
            true,
            primary,
            onTap: () =>
                Navigator.of(context).popUntil((r) => r.isFirst),
          ),
          _buildNavItem(
            Icons.account_balance_outlined,
            'Accounts',
            false,
            primary,
            onTap: () =>
                Navigator.of(context).popUntil((r) => r.isFirst),
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
          _buildNavItem(Icons.logout, 'Logout', false, Colors.redAccent, onTap: () async {
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

  Widget _buildNavItem(IconData icon, String label, bool active, Color color, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: active ? color : Colors.grey, size: 22),
      title: _isSidebarCollapsed ? null : Text(label, style: TextStyle(color: active ? color : Colors.grey, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
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

  Widget _buildHeader(bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      color: isDark ? AppColors.surfaceDarkRaised : AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Trading Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _showAccountForm(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 20),
              const CircleAvatar(radius: 18, backgroundColor: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCards(bool isDark) {
    return Row(
      children: [
        _buildMetricCard('Total Accounts', _metrics['totalAccounts']?.toString() ?? '0', Icons.account_balance, Colors.blue, isDark),
        const SizedBox(width: 24),
        _buildMetricCard('Account Limit', _metrics['accountLimit']?.toString() ?? '--', Icons.lock_clock, Colors.orange, isDark),
        const SizedBox(width: 24),
        // 1A placeholder — wired to active subscriptions in 1B.
        _buildMetricCard('User Slot Booked', '0', Icons.confirmation_number_outlined, AppColors.primaryAccent, isDark),
        const SizedBox(width: 24),
        _buildMetricCard('Active Trades', _metrics['activeTrades']?.toString() ?? 'No active trades', Icons.trending_up, Colors.green, isDark),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDarkRaised : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTable(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkRaised : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Connected Trading Accounts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.sync, size: 20, color: AppColors.primaryAccent),
                    onPressed: _loadInitialData,
                    tooltip: 'Sync with server',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20, color: AppColors.primaryAccent),
                    onPressed: _refreshData,
                    tooltip: 'Refresh status',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_accounts.isEmpty)
             const Padding(
               padding: EdgeInsets.symmetric(vertical: 40),
               child: Center(child: Text('No accounts connected.', style: TextStyle(color: Colors.grey))),
             )
          else
            SizedBox(
              width: double.infinity,
              child: DataTable(
                horizontalMargin: 0,
                columnSpacing: 24,
                headingRowColor: WidgetStateProperty.all(isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.withValues(alpha: 0.05)),
                columns: const [
                  DataColumn(label: Text('Account ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Account Number')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Platform')),
                  DataColumn(label: Text('Balance')),
                  DataColumn(label: Text('Equity')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _accounts.map((acc) {
                  final masterColor = acc.isMaster ? Colors.purple : Colors.teal;
                  final platformColor = acc.platform == Platform.mt5 ? Colors.blue : Colors.orange;
                  // If loginNumber matches serverId AND it's a short id, the
                  // server hasn't issued the platform login yet.
                  final loginPending = acc.loginNumber == acc.serverId.toString() &&
                      acc.serverId.toString().length < 7;
                  return DataRow(cells: [
                    DataCell(Text(acc.serverId.toString(), style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(acc.accountName.isEmpty ? 'Pending...' : acc.accountName)),
                    DataCell(Text(loginPending ? 'Connecting...' : acc.loginNumber)),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: masterColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        acc.accountType.wireValue,
                        style: TextStyle(color: masterColor, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: platformColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        acc.platform.wireValue,
                        style: TextStyle(color: platformColor, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )),
                    DataCell(Text('\$${acc.balance}')),
                    DataCell(Text('\$${acc.equity}')),
                    DataCell(Switch(
                      value: acc.isOnline,
                      activeColor: Colors.green,
                      onChanged: (val) => _toggleActivation(acc, val),
                    )),
                    DataCell(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Slave Settings (Risk & Stops + Order Control) apply
                        // only to slaves — masters trade manually and have no
                        // risk-management surface here. Supported on MT4 + MT5.
                        if (!acc.isMaster &&
                            (acc.platform == Platform.mt5 || acc.platform == Platform.mt4))
                          IconButton(
                            icon: const Icon(Icons.settings_outlined, size: 20, color: AppColors.primaryAccent),
                            onPressed: () => _showRiskSettings(acc),
                            tooltip: 'Slave Settings',
                          ),
                        IconButton(
                          icon: const Icon(Icons.info_outline, size: 20),
                          onPressed: () => _showAccountDetails(acc),
                          tooltip: 'Details',
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blueAccent),
                          onPressed: () => _showAccountForm(context, account: acc),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                          onPressed: () => _showDeleteConfirmation(context, acc),
                          tooltip: 'Delete',
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _toggleActivation(Account acc, bool value) async {
    final repo = context.read<TradingRepository>();
    final success = await repo.toggleAccountActivation(
      account: acc,
      activate: value,
    );

    if (success) {
      setState(() {
        // Account is immutable; replace the entry with a status-updated copy.
        final idx = _accounts.indexWhere((a) => a.serverId == acc.serverId);
        if (idx != -1) {
          _accounts[idx] = _accounts[idx].copyWith(
            status: value ? 'CONNECTED' : 'DISCONNECTED',
          );
        }
      });
      // SMART SYNC: Trigger background refresh to confirm status with API
      _refreshData(silent: true);
      // Wait 3 seconds and sync again to be absolutely sure
      Future.delayed(const Duration(seconds: 3), () => _refreshData(silent: true));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to ${value ? 'activate' : 'deactivate'} account')),
        );
      }
    }
  }

  void _showRiskSettings(Account acc) {
    showDialog(
      context: context,
      builder: (context) => Mt5RiskDialog(account: acc),
    );
  }

  void _showAccountDetails(Account account) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      // Override the Material 3 default (maxWidth: 640) so the trade
      // tables breathe on wide desktop displays.
      constraints: const BoxConstraints(maxWidth: 960),
      builder: (sheetContext) => AccountDetailsSheet(account: account),
    );
  }

  void _showAccountForm(BuildContext context, {Account? account}) {
    final isEditing = account != null;

    // Track every controller we create so we can dispose them when the
    // dialog closes. Without this, each Add/Edit reopen leaks ~12 controllers.
    final controllers = <TextEditingController>[];
    TextEditingController makeController([String text = '']) {
      final c = TextEditingController(text: text);
      controllers.add(c);
      return c;
    }

    final accountNameController = makeController(isEditing ? account.accountName : '');
    final accountNumberController = makeController(isEditing ? account.loginNumber : '');
    final passwordController = makeController();
    final serverController = makeController();

    // Additional controllers for other platforms
    final clientIdController = makeController();
    final clientSecretController = makeController();
    final refreshTokenController = makeController();
    final expireInController = makeController();
    final emailController = makeController();
    final userNameController = makeController();
    final brokerIdController = makeController();

    String platformType = isEditing ? account.platform.wireValue : 'MT4';
    bool isMaster = isEditing ? account.isMaster : true;
    final masterIdController = makeController();
    bool isSubmitting = false;

    final platforms = ['MT4', 'MT5', 'cTrader', 'DxTrade', 'TradeLocker', 'MatchTrade'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Trading Account' : 'Add Trading Account', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: platforms.contains(platformType) ? platformType : platforms.first,
                  decoration: const InputDecoration(labelText: 'Platform'),
                  items: platforms.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: isEditing ? null : (val) => setDialogState(() => platformType = val!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: accountNameController,
                  decoration: const InputDecoration(labelText: 'Account Name', hintText: 'e.g. My Primary Master'),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: accountNumberController,
                  enabled: !isEditing,
                  decoration: const InputDecoration(labelText: 'Account Number', hintText: 'Enter trade account number'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                
                // Common fields for most but not all
                if (platformType != 'cTrader') ...[
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: isEditing ? 'New Password (leave empty to keep current)' : 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: serverController,
                    decoration: const InputDecoration(labelText: 'Server', hintText: 'e.g. Broker-Live'),
                  ),
                  const SizedBox(height: 16),
                ],

                // Platform specific fields (simplified for brevity, matching previous implementation)
                if (platformType == 'cTrader') ...[
                  TextField(controller: clientIdController, decoration: const InputDecoration(labelText: 'Client ID')),
                  const SizedBox(height: 16),
                  TextField(controller: clientSecretController, decoration: const InputDecoration(labelText: 'Client Secret')),
                  const SizedBox(height: 16),
                  TextField(controller: refreshTokenController, decoration: const InputDecoration(labelText: 'Refresh Token')),
                  const SizedBox(height: 16),
                  TextField(controller: expireInController, decoration: const InputDecoration(labelText: 'Expire In')),
                  const SizedBox(height: 16),
                  TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 16),
                  TextField(controller: accountNameController, decoration: const InputDecoration(labelText: 'Account Name')),
                  const SizedBox(height: 16),
                ],

                if (platformType == 'DxTrade') ...[
                  TextField(controller: userNameController, decoration: const InputDecoration(labelText: 'User Name')),
                  const SizedBox(height: 16),
                ],

                if (platformType == 'TradeLocker' || platformType == 'MatchTrade') ...[
                  TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 16),
                ],

                if (platformType == 'MatchTrade') ...[
                  TextField(controller: brokerIdController, decoration: const InputDecoration(labelText: 'Broker ID')),
                  const SizedBox(height: 16),
                ],

                Row(
                  children: [
                    const Text('Account Type: ', style: TextStyle(fontWeight: FontWeight.w500)),
                    const Spacer(),
                    // Account type is locked in edit mode: the trading API
                    // exposes update_Master_* and update_slave_* as separate
                    // endpoints with no convert path. To switch type, delete
                    // and re-register as the other type.
                    ChoiceChip(
                      label: const Text('Master'),
                      selected: isMaster,
                      onSelected: isEditing ? null : (val) => setDialogState(() => isMaster = true),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Slave'),
                      selected: !isMaster,
                      onSelected: isEditing ? null : (val) => setDialogState(() => isMaster = false),
                    ),
                  ],
                ),
                if (isEditing) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Type cannot be changed. To switch, delete this account and re-register as the other type.',
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ],
                if (!isMaster) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: masterIdController,
                    decoration: const InputDecoration(labelText: 'Master Account ID', hintText: 'Required for Slave'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isSubmitting ? null : () async {
                if (accountNumberController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account Number is required')));
                   return;
                }

                setDialogState(() => isSubmitting = true);

                final repo = context.read<TradingRepository>();
                final tradeAccountNumber = int.tryParse(accountNumberController.text);
                if (tradeAccountNumber == null) {
                   setDialogState(() => isSubmitting = false);
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Account Number format')));
                   return;
                }

                final result = isEditing
                  ? await repo.updateTradingAccount(
                      userId: tradeAccountNumber,
                      platformType: platformType,
                      accountName: accountNameController.text,
                      password: passwordController.text.isEmpty ? null : passwordController.text,
                      server: serverController.text,
                      isMaster: isMaster,
                      masterId: isMaster ? null : int.tryParse(masterIdController.text),
                    )
                  : await repo.addAccount(
                      userId: tradeAccountNumber,
                      platformType: platformType,
                      accountName: accountNameController.text,
                      password: passwordController.text,
                      server: serverController.text,
                      isMaster: isMaster,
                      masterId: isMaster ? null : int.tryParse(masterIdController.text),
                    );

                if (context.mounted) {
                  // Don't setDialogState(false) here — we're about to pop,
                  // and a rebuild scheduled after pop runs against unmounted
                  // widgets (and post-pop disposed controllers).
                  final message = result['message'];
                  final isSuccess = result['success'] == true;
                  final apiId = result['id'];

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

                  if (isSuccess) {
                    final newServerId = int.tryParse(apiId?.toString() ?? '') ?? tradeAccountNumber;

                    if (!isEditing) {
                      final newAccount = Account(
                        serverId: newServerId,
                        loginNumber: tradeAccountNumber.toString(),
                        accountName: accountNameController.text,
                        accountType: isMaster ? AccountType.master : AccountType.slave,
                        platform: Platform.parse(platformType),
                        masterId: isMaster ? null : int.tryParse(masterIdController.text),
                      );

                      final existingIndex = _accounts.indexWhere((a) => a.serverId == newServerId);
                      if (existingIndex != -1) {
                        _accounts[existingIndex] = newAccount;
                      } else {
                        _accounts.add(newAccount);
                      }
                    } else {
                      final index = _accounts.indexWhere((a) => a.serverId == account.serverId);
                      if (index != -1) {
                        _accounts[index] = _accounts[index].copyWith(
                          platform: Platform.parse(platformType),
                          accountType: isMaster ? AccountType.master : AccountType.slave,
                          accountName: accountNameController.text,
                          loginNumber: accountNumberController.text,
                        );
                      }
                    }

                    _startDiscoveryLoop(); // Start dynamic discovery loop
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: Colors.white,
              ),
              child: isSubmitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(isEditing ? 'Update' : 'Submit'),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      // Defer disposal one frame: any rebuild scheduled by the submit
      // handler before the dialog pop must complete against live
      // controllers. Without this, you can hit "TextEditingController
      // was used after being disposed" on the failure path.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final c in controllers) {
          c.dispose();
        }
      });
    });
  }

  void _showDeleteConfirmation(BuildContext context, Account account) {
    bool isDeleting = false;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Delete Account'),
          content: Text('Are you sure you want to delete account ${account.serverId}?'),
          actions: [
            TextButton(onPressed: isDeleting ? null : () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: isDeleting ? null : () async {
                final repo = context.read<TradingRepository>();

                setDialogState(() => isDeleting = true);

                final result = await repo.deleteTradingAccount(
                  userId: account.serverId,
                  isMaster: account.isMaster,
                  platform: account.platform.wireValue,
                  loginNumber: account.loginNumber,
                );

                if (context.mounted) {
                  setDialogState(() => isDeleting = false);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  if (result.toLowerCase().contains('success')) {
                    await _refreshData();
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              child: isDeleting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}