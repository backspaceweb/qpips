import 'dart:convert';
import 'dart:async';
import 'widgets/price_ticker.dart';
import 'widgets/mt5_risk_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repositories/trading_repository.dart';
import '../../../repositories/auth_repository.dart';

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
  List<Map<String, dynamic>> _accounts = [];
  List<int> _registeredUserIds = [];
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
      print('DEBUG: App resumed, triggering smart sync...');
      _refreshData(silent: true);
    }
  }

  Future<void> _loadInitialData({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedIds = prefs.getStringList('registeredUserIds') ?? [];
    final String? metadataJson = prefs.getString('accountMetadata');
    Map<String, dynamic> metadata = {};
    if (metadataJson != null) {
      try {
        metadata = jsonDecode(metadataJson);
      } catch (e) {
        print('Error decoding metadata: $e');
      }
    }
    
    // IMMEDIATE STATE UPDATE: Use local data while sync is happening
    setState(() {
      _registeredUserIds = savedIds.map((id) => int.parse(id)).toList();
      // Pre-populate _accounts with what we know from local storage
      _accounts = _registeredUserIds.map((id) {
        final idStr = id.toString();
        final m = metadata[idStr];
        return {
          'id': idStr,
          'accountName': m?['accountName'] ?? 'Loading...',
          'accountNumber': m?['accountNumber'] ?? idStr,
          'accountType': m?['accountType'] ?? 'Unknown',
          'platform': m?['platform'] ?? 'MT4',
          'status': 'Offline',
          'balance': '0.00',
          'equity': '0.00',
        };
      }).toList();
    });

    // Run server sync
    final repo = context.read<TradingRepository>();
    final synchedAccounts = await repo.syncAccountsWithServer();
    
    if (mounted) {
      setState(() {
        _accounts = synchedAccounts;
        _registeredUserIds = synchedAccounts.map((a) => int.parse(a['id'])).toList();
        if (!silent) _isLoading = false;
      });
    }
    
    _refreshData(silent: silent);
  }

  Future<void> _saveAccounts() async {
    // Registered IDs are now handled by Supabase, but we keep this for basic session persistence if needed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('registeredUserIds', _registeredUserIds.map((id) => id.toString()).toList());
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
        _accounts = results[1] as List<Map<String, dynamic>>;
        _registeredUserIds = _accounts.map((a) => int.parse(a['id'])).toList();
        
        if (!silent) _isLoading = false;
      });
    }
  }

  // Conservative loop to "catch" new accounts without spamming the API
  void _startDiscoveryLoop({int retries = 3}) async {
    if (retries <= 0 || !mounted) return;

    print('DEBUG: Discovery Loop pulse ($retries retries left)');
    await _loadInitialData(silent: true);

    // Check if we still have temporary IDs (long IDs like 415614138)
    bool hasTempIds = _registeredUserIds.any((id) => id.toString().length > 8);

    if (hasTempIds) {
      // Wait 5 seconds between retries instead of 2
      Future.delayed(const Duration(seconds: 5), () => _startDiscoveryLoop(retries: retries - 1));
    } else {
      print('DEBUG: Discovery successful, all IDs permanent.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAccountForm(context),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Row(
        children: [
          _buildSidebar(isDark, primaryColor),
          Expanded(
            child: Column(
              children: [
                _buildHeader(isDark, primaryColor),
                const PriceTicker(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    color: primaryColor,
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
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 24),
          IconButton(
            icon: Icon(_isSidebarCollapsed ? Icons.menu_open : Icons.menu, color: primary),
            onPressed: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
          ),
          if (!_isSidebarCollapsed) ...[
            const SizedBox(height: 20),
            const Text('QuantumPips', style: TextStyle(color: Color(0xFF6366F1), fontSize: 22, fontWeight: FontWeight.bold)),
          ],
          const SizedBox(height: 40),
          _buildNavItem(Icons.dashboard_outlined, 'Dashboard', true, primary),
          _buildNavItem(Icons.account_balance_outlined, 'Accounts', false, primary),
          _buildNavItem(Icons.analytics_outlined, 'Analytics', false, primary),
          _buildNavItem(Icons.settings_outlined, 'Settings', false, primary),
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

  Widget _buildHeader(bool isDark, Color primary) {
    final hasKey = const String.fromEnvironment('API_KEY', defaultValue: '').isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
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
              const SizedBox(width: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (hasKey ? Colors.green : Colors.red).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: hasKey ? Colors.green : Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      hasKey ? 'API Connected' : 'API Disconnected',
                      style: TextStyle(color: hasKey ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
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
        _buildMetricCard('Active Trades', _metrics['activeTrades']?.toString() ?? 'No active trades', Icons.trending_up, Colors.green, isDark),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
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
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
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
                    icon: const Icon(Icons.sync, size: 20, color: Color(0xFF6366F1)),
                    onPressed: _loadInitialData,
                    tooltip: 'Sync with server',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20, color: Color(0xFF6366F1)),
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
                rows: _accounts.map((acc) => DataRow(cells: [
                  DataCell(Text(acc['id']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w500))),
                  DataCell(Text(acc['accountName']?.toString() ?? 'Pending...')),
                  DataCell(Text(
                    // If accountNumber matches ID, it means we don't have the real login yet
                    (acc['accountNumber'] == acc['id'] && acc['id'].toString().length < 7) 
                      ? 'Connecting...' 
                      : (acc['accountNumber']?.toString() ?? 'N/A')
                  )),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (acc['accountType'] == 'Master' ? Colors.purple : Colors.teal).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(acc['accountType'] ?? 'Unknown', style: TextStyle(color: acc['accountType'] == 'Master' ? Colors.purple : Colors.teal, fontSize: 12, fontWeight: FontWeight.bold)),
                  )),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (acc['platform'] == 'MT5' ? Colors.blue : Colors.orange).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(acc['platform'] ?? 'MT4', style: TextStyle(color: acc['platform'] == 'MT5' ? Colors.blue : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                  )),
                  DataCell(Text('\$${acc['balance'] ?? '0.00'}')),
                  DataCell(Text('\$${acc['equity'] ?? '0.00'}')),
                  DataCell(Switch(
                    value: acc['status'] == 'CONNECTED' || acc['status'] == 'Online',
                    activeColor: Colors.green,
                    onChanged: (val) => _toggleActivation(acc, val),
                  )),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (acc['platform'] == 'MT5')
                        IconButton(
                          icon: const Icon(Icons.settings_outlined, size: 20, color: Color(0xFF6366F1)),
                          onPressed: () => _showRiskSettings(acc),
                          tooltip: 'Risk Settings',
                        ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, size: 20),
                        onPressed: () => _showAccountDetails(context, int.parse(acc['id'])),
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
                ])).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isOnline = status == 'Online';
    final color = isOnline ? Colors.green : Colors.redAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _toggleActivation(Map<String, dynamic> acc, bool value) async {
    final repo = context.read<TradingRepository>();
    final success = await repo.toggleAccountActivation(
      userId: int.parse(acc['id']),
      isMaster: acc['accountType'] == 'Master',
      activate: value,
    );

    if (success) {
      setState(() {
        acc['status'] = value ? 'CONNECTED' : 'DISCONNECTED';
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

  void _showRiskSettings(Map<String, dynamic> acc) {
    showDialog(
      context: context,
      builder: (context) => Mt5RiskDialog(account: acc),
    );
  }

  void _showAccountDetails(BuildContext context, int userId) async {
    final repo = context.read<TradingRepository>();
    final details = await repo.getAccountDetails(userId);
    
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Details: $userId', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...details.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key, style: const TextStyle(color: Colors.grey)),
                  Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )).toList(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showAccountForm(BuildContext context, {Map<String, dynamic>? account}) {
    final isEditing = account != null;
    final accountNameController = TextEditingController(text: isEditing ? (account['accountName'] ?? '') : '');
    final accountNumberController = TextEditingController(text: isEditing ? (account['accountNumber'] ?? '') : '');
    final passwordController = TextEditingController();
    final serverController = TextEditingController();
    
    // Additional controllers for other platforms
    final clientIdController = TextEditingController();
    final clientSecretController = TextEditingController();
    final refreshTokenController = TextEditingController();
    final expireInController = TextEditingController();
    final emailController = TextEditingController();
    final userNameController = TextEditingController();
    final brokerIdController = TextEditingController();
    
    String platformType = isEditing ? (account['platform'] ?? 'MT4') : 'MT4';
    bool isMaster = isEditing ? (account['accountType'] == 'Master') : true;
    final masterIdController = TextEditingController();
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
                    ChoiceChip(
                      label: const Text('Master'),
                      selected: isMaster,
                      onSelected: (val) => setDialogState(() => isMaster = true),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Slave'),
                      selected: !isMaster,
                      onSelected: (val) => setDialogState(() => isMaster = false),
                    ),
                  ],
                ),
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
                print('DEBUG: Submit button pressed');
                if (accountNumberController.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account Number is required')));
                   return;
                }
                
                setDialogState(() => isSubmitting = true);
                print('DEBUG: isSubmitting set to true');
                
                final repo = context.read<TradingRepository>();
                final tradeAccountNumber = int.tryParse(accountNumberController.text);
                if (tradeAccountNumber == null) {
                   print('DEBUG: Invalid account number format');
                   setDialogState(() => isSubmitting = false);
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Account Number format')));
                   return;
                }
                
                print('\n--- [SUPABASE FORM SUBMIT] ---');
                print('Platform: $platformType');
                print('Account Name: ${accountNameController.text}');
                print('Account Number (Login): ${accountNumberController.text}');
                print('Type: ${isMaster ? 'Master' : 'Slave'}');
                print('-----------------------------\n');

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

                  print('DEBUG: Repository call result: $result');
                  
                  if (context.mounted) {
                  setDialogState(() => isSubmitting = false);
                  final message = result['message'];
                  final isSuccess = result['success'] == true;
                  final apiId = result['id'];

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                  
                  if (isSuccess) {
                    final storedId = apiId ?? tradeAccountNumber.toString();
                    
                    if (!isEditing) {
                      final newId = int.tryParse(storedId) ?? tradeAccountNumber;
                      if (!_registeredUserIds.contains(newId)) {
                         _registeredUserIds.add(newId);
                      }
                      
                      final newAccount = {
                        'id': storedId,
                        'accountName': result['accountName'] ?? accountNameController.text,
                        'accountNumber': result['accountNumber'] ?? tradeAccountNumber.toString(),
                        'accountType': result['accountType'] ?? (isMaster ? 'Master' : 'Slave'),
                        'platform': result['platform'] ?? platformType,
                        'status': 'Offline',
                        'balance': '0.00',
                        'equity': '0.00',
                      };

                      final existingIndex = _accounts.indexWhere((acc) => acc['id'] == storedId);
                      if (existingIndex != -1) {
                        _accounts[existingIndex] = newAccount;
                      } else {
                        _accounts.add(newAccount);
                      }
                    } else {
                      final index = _accounts.indexWhere((acc) => acc['id'] == account['id']);
                      if (index != -1) {
                        _accounts[index]['platform'] = platformType;
                        _accounts[index]['accountType'] = isMaster ? 'Master' : 'Slave';
                        _accounts[index]['accountName'] = accountNameController.text;
                        _accounts[index]['accountNumber'] = accountNumberController.text;
                      }
                    }
                    
                    await _saveAccounts();
                    _startDiscoveryLoop(); // Start dynamic discovery loop

                    // Log the final state in the dashboard for this account
                    final finalAcc = _accounts.firstWhere((acc) => acc['id'] == storedId, orElse: () => {});
                    print('\n--- [DASHBOARD STATE AFTER REGISTRATION] ---');
                    print('Account ID: ${finalAcc['id']}');
                    print('Name: ${finalAcc['accountName']}');
                    print('Number: ${finalAcc['accountNumber']}');
                    print('Platform: ${finalAcc['platform']}');
                    print('Type: ${finalAcc['accountType']}');
                    print('--------------------------------------------\n');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
              ),
              child: isSubmitting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(isEditing ? 'Update' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> account) {
    bool isDeleting = false;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Delete Account'),
          content: Text('Are you sure you want to delete account ${account['id']}?'),
          actions: [
            TextButton(onPressed: isDeleting ? null : () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: isDeleting ? null : () async {
                final repo = context.read<TradingRepository>();
                final userId = int.parse(account['id']);
                final isMaster = account['accountType'] == 'Master';
                
                setDialogState(() => isDeleting = true); 

                final result = await repo.deleteTradingAccount(
                  userId: userId, 
                  isMaster: isMaster,
                  platform: account['platform'],
                  loginNumber: account['accountNumber']?.toString(),
                );
                
                if (context.mounted) {
                  setDialogState(() => isDeleting = false);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                  if (result.toLowerCase().contains('success')) {
                    _registeredUserIds.removeWhere((id) => id == userId);
                    
                    // CLEAN-ON-DELETE: Purge all metadata keys associated with this account
                    final prefs = await SharedPreferences.getInstance();
                    final String? metadataJson = prefs.getString('accountMetadata');
                    if (metadataJson != null) {
                      Map<String, dynamic> metadata = jsonDecode(metadataJson);
                      final accountNumber = account['accountNumber']?.toString();
                      
                      metadata.remove(userId.toString()); // Remove by ID
                      if (accountNumber != null) metadata.remove(accountNumber); // Remove by Login
                      
                      await prefs.setString('accountMetadata', jsonEncode(metadata));
                    }
                    
                    await _saveAccounts();
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