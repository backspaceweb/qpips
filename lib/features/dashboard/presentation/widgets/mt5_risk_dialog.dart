import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../repositories/trading_repository.dart';
import '../../../../core/api/generated/api.swagger.dart';

class Mt5RiskDialog extends StatefulWidget {
  final Map<String, dynamic> account;

  const Mt5RiskDialog({super.key, required this.account});

  @override
  State<Mt5RiskDialog> createState() => _Mt5RiskDialogState();
}

class _Mt5RiskDialogState extends State<Mt5RiskDialog> {
  bool _isLoading = true;
  bool _isSaving = false;

  // Risk Settings
  int _riskType = 0; // 0 = Risk multiplier by equity, 1 = Lot multiplier, 2 = Fixed lot, 3 = Auto risk
  double _multiplier = 1.0;

  // Stops/Limits
  bool _copySLTP = true;
  int _scalperMode = 0; // 0 = Off, 1 = Permanent Scalp-Mode, 2 = Rollover Scalp-Mode
  int _orderFilter = 0; // 0 = Copy buy & sell orders, 1 = Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders
  int _scalperValue = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final repo = context.read<TradingRepository>();
    final settings = await repo.getMT5RiskSettings(int.parse(widget.account['id']));

    if (mounted) {
      setState(() {
        final risk = settings['risk'] as Risk?;
        final stops = settings['stops'] as StopsLimits?;

        if (risk != null) {
          _riskType = risk.riskType ?? 0;
          _multiplier = risk.multiplier?.toDouble() ?? 1.0;
        }

        if (stops != null) {
          _copySLTP = stops.copySLTP ?? true;
          _scalperMode = stops.scalperMode ?? 0;
          _orderFilter = stops.orderFilter ?? 0;
          _scalperValue = stops.scalperValue?.toInt() ?? 0;
        }

        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    final repo = context.read<TradingRepository>();
    
    final success = await repo.updateMT5RiskSettings(
      userId: int.parse(widget.account['id']),
      riskType: _riskType,
      multiplier: _multiplier,
      copySLTP: _copySLTP,
      scalperMode: _scalperMode,
      orderFilter: _orderFilter,
      scalperValue: _scalperValue,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Risk settings updated successfully')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update risk settings')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: _isLoading
            ? const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()))
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('MT5 Risk Settings', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Account: ${widget.account['accountNumber']} (${widget.account['accountName']})', 
                         style: const TextStyle(color: Colors.grey)),
                    const Divider(height: 40),
                    
                    // Risk Type
                    const Text('Risk Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      'Risk Type',
                      _riskType,
                      {
                        0: 'Risk multiplier by equity',
                        1: 'Lot multiplier',
                        2: 'Fixed lot',
                        3: 'Auto risk',
                      },
                      (val) => setState(() => _riskType = val!),
                    ),
                    const SizedBox(height: 20),
                    _buildNumberInput('Multiplier / Lot Size', _multiplier, (val) => _multiplier = val),
                    
                    const Divider(height: 40),
                    const Text('Stops & Limits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    
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
                      {
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
                      {
                        0: 'Off',
                        1: 'Permanent Scalp-Mode',
                        2: 'Rollover Scalp-Mode',
                      },
                      (val) => setState(() => _scalperMode = val!),
                    ),
                    if (_scalperMode == 2) ...[
                      const SizedBox(height: 20),
                      _buildNumberInput('Rollover Value', _scalperValue.toDouble(), (val) => _scalperValue = val.toInt()),
                    ],
                    
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
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
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDropdown(String label, int value, Map<int, String> options, Function(int?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
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

  Widget _buildNumberInput(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          controller: TextEditingController(text: value.toString()),
          onChanged: (val) {
            final parsed = double.tryParse(val);
            if (parsed != null) onChanged(parsed);
          },
        ),
      ],
    );
  }
}
