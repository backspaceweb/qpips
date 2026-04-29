import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/account.dart';
import '../../../../domain/order_control_settings.dart';
import '../../../../domain/symbol_map.dart';
import '../../../../repositories/trading_repository.dart';
import '../../../../core/api/generated/api.swagger.dart';

/// Per-slave settings dialog. Two tabs:
///   1. Risk & Stops — risk multiplier, copy SL/TP, scalper mode, order filter
///   2. Order Control — auto-close triggers, equity bands, pending-order limits
///
/// Backed by `getRiskSettings` + `getOrderControlSettings` (read on open)
/// and `updateRiskSettings` + `updateOrderControlSettings` (write on save).
/// Dispatches MT4/MT5 internally based on the passed [Account].
///
/// Class name kept as `Mt5RiskDialog` for backward compatibility with the
/// dashboard import; the dialog itself works for both MT4 and MT5 slaves.
class Mt5RiskDialog extends StatefulWidget {
  final Account account;

  const Mt5RiskDialog({super.key, required this.account});

  @override
  State<Mt5RiskDialog> createState() => _Mt5RiskDialogState();
}

class _Mt5RiskDialogState extends State<Mt5RiskDialog> {
  bool _isLoading = true;
  bool _isSaving = false;

  // Risk Settings
  int _riskType = 0; // 0=Risk multiplier by equity, 1=Lot multiplier, 2=Fixed lot, 3=Auto risk
  double _multiplier = 1.0;

  // Stops/Limits
  bool _copySLTP = true;
  int _scalperMode = 0; // 0=Off, 1=Permanent, 2=Rollover
  int _orderFilter = 0; // 0=Buy & Sell, 1=Buy only, 2=Sell only, 3=All
  int _scalperValue = 0;

  // Order Control (auto-close triggers)
  OrderControlSettings _orderControl = OrderControlSettings.empty;

  // Symbol mapping state
  List<String> _suffixMappings = const [];
  List<String> _specialMappings = const [];
  SymbolMapType _newMapType = SymbolMapType.suffix;
  bool _isAddingMap = false;

  // Persistent controllers so the input cursor doesn't jump to end
  // every time the user types a digit (which is what happens if you
  // recreate a TextEditingController on every build).
  late final TextEditingController _multiplierCtrl;
  late final TextEditingController _scalperValueCtrl;
  late final Map<String, TextEditingController> _ocCtrls;
  late final TextEditingController _sourceSymbolCtrl;
  late final TextEditingController _followSymbolCtrl;

  @override
  void initState() {
    super.initState();
    _multiplierCtrl = TextEditingController(text: '1.0');
    _scalperValueCtrl = TextEditingController(text: '0');
    _ocCtrls = {
      for (final k in _orderControlFieldKeys) k: TextEditingController(text: '0'),
    };
    _sourceSymbolCtrl = TextEditingController();
    _followSymbolCtrl = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _multiplierCtrl.dispose();
    _scalperValueCtrl.dispose();
    for (final c in _ocCtrls.values) {
      c.dispose();
    }
    _sourceSymbolCtrl.dispose();
    _followSymbolCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final repo = context.read<TradingRepository>();
    final results = await Future.wait([
      repo.getRiskSettings(account: widget.account),
      repo.getOrderControlSettings(account: widget.account),
      repo.getSuffixMappings(account: widget.account),
      repo.getSpecialMappings(account: widget.account),
    ]);
    if (!mounted) return;
    final risk = (results[0] as Map<String, dynamic>)['risk'] as Risk?;
    final stops = (results[0] as Map<String, dynamic>)['stops'] as StopsLimits?;
    final oc = results[1] as OrderControlSettings;
    final suffixes = results[2] as List<String>;
    final specials = results[3] as List<String>;

    setState(() {
      if (risk != null) {
        _riskType = risk.riskType ?? 0;
        _multiplier = risk.multiplier?.toDouble() ?? 1.0;
        _multiplierCtrl.text = _multiplier.toString();
      }
      if (stops != null) {
        _copySLTP = stops.copySLTP ?? true;
        _scalperMode = stops.scalperMode ?? 0;
        _orderFilter = stops.orderFilter ?? 0;
        _scalperValue = stops.scalperValue?.toInt() ?? 0;
        _scalperValueCtrl.text = _scalperValue.toString();
      }
      _orderControl = oc;
      for (final k in _orderControlFieldKeys) {
        _ocCtrls[k]!.text = _readOcField(k).toString();
      }
      _suffixMappings = suffixes;
      _specialMappings = specials;
      _isLoading = false;
    });
  }

  Future<void> _reloadSymbolMappings() async {
    final repo = context.read<TradingRepository>();
    final results = await Future.wait([
      repo.getSuffixMappings(account: widget.account),
      repo.getSpecialMappings(account: widget.account),
    ]);
    if (!mounted) return;
    setState(() {
      _suffixMappings = results[0];
      _specialMappings = results[1];
    });
  }

  Future<void> _handleAddSymbolMap() async {
    final source = _sourceSymbolCtrl.text.trim();
    final follow = _followSymbolCtrl.text.trim();
    if (source.isEmpty || follow.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both source and follow symbols are required')),
      );
      return;
    }

    setState(() => _isAddingMap = true);
    final repo = context.read<TradingRepository>();
    final ok = await repo.addSymbolMap(
      account: widget.account,
      sourceSymbol: source,
      followSymbol: follow,
      type: _newMapType,
    );
    if (!mounted) return;
    setState(() => _isAddingMap = false);

    if (ok) {
      _sourceSymbolCtrl.clear();
      _followSymbolCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_newMapType.label} mapping added: $source → $follow')),
      );
      await _reloadSymbolMappings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add symbol mapping')),
      );
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    final repo = context.read<TradingRepository>();

    final results = await Future.wait([
      repo.updateRiskSettings(
        account: widget.account,
        riskType: _riskType,
        multiplier: _multiplier,
        copySLTP: _copySLTP,
        scalperMode: _scalperMode,
        orderFilter: _orderFilter,
        scalperValue: _scalperValue,
      ),
      repo.updateOrderControlSettings(
        account: widget.account,
        settings: _orderControl,
      ),
    ]);

    if (!mounted) return;
    final riskOk = results[0];
    final ocOk = results[1];
    setState(() => _isSaving = false);

    if (riskOk && ocOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved')),
      );
      Navigator.of(context).pop();
    } else {
      final parts = <String>[];
      if (!riskOk) parts.add('Risk & Stops');
      if (!ocOk) parts.add('Order Control');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: ${parts.join(', ')}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 810,
          constraints: const BoxConstraints(maxHeight: 720),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: _isLoading
              ? const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const TabBar(
                      tabs: [
                        Tab(text: 'Risk & Stops'),
                        Tab(text: 'Order Control'),
                        Tab(text: 'Symbols'),
                      ],
                      labelColor: Color(0xFF6366F1),
                      indicatorColor: Color(0xFF6366F1),
                    ),
                    Flexible(
                      child: TabBarView(
                        children: [
                          _buildRiskTab(),
                          _buildOrderControlTab(),
                          _buildSymbolsTab(),
                        ],
                      ),
                    ),
                    _buildFooter(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Slave Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  '${widget.account.accountName} (${widget.account.loginNumber}) · ${widget.account.platform.wireValue}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isSaving ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
              ),
              child: _isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Risk Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _buildDropdown(
            'Risk Type',
            _riskType,
            const {
              0: 'Risk multiplier by equity',
              1: 'Lot multiplier',
              2: 'Fixed lot',
              3: 'Auto risk',
            },
            (val) => setState(() => _riskType = val!),
          ),
          const SizedBox(height: 20),
          _buildDoubleInput('Multiplier / Lot Size', _multiplierCtrl, (v) => _multiplier = v),
          const Divider(height: 40),
          const Text('Stops & Limits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Copy SL/TP'),
            subtitle: const Text('Enable copying of stop loss and take profit'),
            value: _copySLTP,
            onChanged: (val) => setState(() => _copySLTP = val),
            contentPadding: EdgeInsets.zero,
          ),
          _buildDropdown(
            'Order Filter',
            _orderFilter,
            const {
              0: 'Copy Buy & Sell',
              1: 'Copy Buy only',
              2: 'Copy Sell only',
              3: 'Copy All',
            },
            (val) => setState(() => _orderFilter = val!),
          ),
          const SizedBox(height: 20),
          _buildDropdown(
            'Scalper Mode',
            _scalperMode,
            const {
              0: 'Off',
              1: 'Permanent Scalp-Mode',
              2: 'Rollover Scalp-Mode',
            },
            (val) => setState(() => _scalperMode = val!),
          ),
          if (_scalperMode == 2) ...[
            const SizedBox(height: 20),
            _buildIntInput('Rollover Value', _scalperValueCtrl, (v) => _scalperValue = v),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderControlTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.amber),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Auto-close triggers. Set 0 to disable a trigger. These act on the slave\'s open positions, so misconfiguration can close real trades.',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Per-Order Limits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _ocIntInput('Close at profit (per order)', 'profitForEveryOrder'),
          const SizedBox(height: 16),
          _ocIntInput('Close at loss (per order)', 'lossForEveryOrder'),
          const SizedBox(height: 16),
          _ocIntInput('Close at profit points', 'profitOverPoint'),
          const SizedBox(height: 16),
          _ocIntInput('Close at loss points', 'lossOverPoint'),
          const Divider(height: 40),
          const Text('Account-Wide', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _ocIntInput('Close all when total profit reaches', 'profitForAllOrder'),
          const SizedBox(height: 16),
          _ocIntInput('Close all when total loss reaches', 'lossForAllOrder'),
          const SizedBox(height: 16),
          _ocIntInput('Close all if equity drops below', 'equityUnderLow'),
          const SizedBox(height: 16),
          _ocIntInput('Close all if equity rises above', 'equityUnderHigh'),
          const Divider(height: 40),
          const Text('Pending Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _ocIntInput('Source profit-point trigger', 'pendingOrderProfitPoint'),
          const SizedBox(height: 16),
          _ocIntInput('Source loss-point trigger', 'pendingOrderLossPoint'),
          const SizedBox(height: 16),
          _ocIntInput('Pending timeout (minutes)', 'pendingTimeout'),
        ],
      ),
    );
  }

  Widget _buildSymbolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add-mapping form
          const Text(
            'Add Symbol Mapping',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Translate a symbol when the master and slave are on different brokers.',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sourceSymbolCtrl,
                  decoration: InputDecoration(
                    labelText: 'Source (master)',
                    hintText: 'e.g. EURUSD',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.arrow_forward, size: 18, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _followSymbolCtrl,
                  decoration: InputDecoration(
                    labelText: 'Follow (slave)',
                    hintText: 'e.g. EURUSD.x',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Mapping Type',
                  _newMapType.index,
                  {
                    SymbolMapType.suffix.index: 'Suffix',
                    SymbolMapType.special.index: 'Special',
                  },
                  (val) => setState(() {
                    _newMapType = SymbolMapType.values[val ?? 0];
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: ElevatedButton.icon(
                  onPressed: _isAddingMap ? null : _handleAddSymbolMap,
                  icon: _isAddingMap
                      ? const SizedBox(
                          width: 14, height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 40),

          // Existing mappings
          Row(
            children: [
              const Expanded(
                child: Text('Existing Mappings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: _reloadSymbolMappings,
                tooltip: 'Reload',
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSymbolList('Suffix', _suffixMappings),
          const SizedBox(height: 16),
          _buildSymbolList('Special', _specialMappings),
        ],
      ),
    );
  }

  Widget _buildSymbolList(String label, List<String> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('${entries.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('— none —', style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
          )
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: entries
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(s, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
                    ))
                .toList(),
          ),
      ],
    );
  }

  // -------- helpers --------

  Widget _buildDropdown(String label, int value, Map<int, String> options, void Function(int?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              items: options.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoubleInput(String label, TextEditingController controller, void Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (val) {
            final parsed = double.tryParse(val);
            if (parsed != null) onChanged(parsed);
          },
        ),
      ],
    );
  }

  Widget _buildIntInput(String label, TextEditingController controller, void Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (val) {
            final parsed = int.tryParse(val);
            if (parsed != null) onChanged(parsed);
          },
        ),
      ],
    );
  }

  /// Wired Order Control field: persistent controller, writes back to
  /// the [_orderControl] state object via copyWith.
  Widget _ocIntInput(String label, String fieldKey) {
    return _buildIntInput(label, _ocCtrls[fieldKey]!, (v) {
      _orderControl = _writeOcField(fieldKey, v);
    });
  }

  // -------- order control field accessors --------

  static const _orderControlFieldKeys = <String>[
    'profitOverPoint',
    'lossOverPoint',
    'profitForEveryOrder',
    'lossForEveryOrder',
    'profitForAllOrder',
    'lossForAllOrder',
    'equityUnderLow',
    'equityUnderHigh',
    'pendingOrderProfitPoint',
    'pendingOrderLossPoint',
    'pendingTimeout',
  ];

  int _readOcField(String key) {
    switch (key) {
      case 'profitOverPoint': return _orderControl.profitOverPoint;
      case 'lossOverPoint': return _orderControl.lossOverPoint;
      case 'profitForEveryOrder': return _orderControl.profitForEveryOrder;
      case 'lossForEveryOrder': return _orderControl.lossForEveryOrder;
      case 'profitForAllOrder': return _orderControl.profitForAllOrder;
      case 'lossForAllOrder': return _orderControl.lossForAllOrder;
      case 'equityUnderLow': return _orderControl.equityUnderLow;
      case 'equityUnderHigh': return _orderControl.equityUnderHigh;
      case 'pendingOrderProfitPoint': return _orderControl.pendingOrderProfitPoint;
      case 'pendingOrderLossPoint': return _orderControl.pendingOrderLossPoint;
      case 'pendingTimeout': return _orderControl.pendingTimeout;
      default: return 0;
    }
  }

  OrderControlSettings _writeOcField(String key, int v) {
    switch (key) {
      case 'profitOverPoint': return _orderControl.copyWith(profitOverPoint: v);
      case 'lossOverPoint': return _orderControl.copyWith(lossOverPoint: v);
      case 'profitForEveryOrder': return _orderControl.copyWith(profitForEveryOrder: v);
      case 'lossForEveryOrder': return _orderControl.copyWith(lossForEveryOrder: v);
      case 'profitForAllOrder': return _orderControl.copyWith(profitForAllOrder: v);
      case 'lossForAllOrder': return _orderControl.copyWith(lossForAllOrder: v);
      case 'equityUnderLow': return _orderControl.copyWith(equityUnderLow: v);
      case 'equityUnderHigh': return _orderControl.copyWith(equityUnderHigh: v);
      case 'pendingOrderProfitPoint': return _orderControl.copyWith(pendingOrderProfitPoint: v);
      case 'pendingOrderLossPoint': return _orderControl.copyWith(pendingOrderLossPoint: v);
      case 'pendingTimeout': return _orderControl.copyWith(pendingTimeout: v);
      default: return _orderControl;
    }
  }
}
