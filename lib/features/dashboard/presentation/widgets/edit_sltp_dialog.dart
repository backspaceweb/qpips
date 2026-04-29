import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/account.dart';
import '../../../../domain/trade_order.dart';
import '../../../../repositories/trading_repository.dart';

/// Dialog for editing the Stop Loss and Take Profit of an open order.
///
/// Pops with `true` on a successful modify, `null` on cancel. The caller
/// should refresh its open-orders list when the future resolves to true.
class EditSlTpDialog extends StatefulWidget {
  final Account account;
  final TradeOrder order;

  const EditSlTpDialog({super.key, required this.account, required this.order});

  @override
  State<EditSlTpDialog> createState() => _EditSlTpDialogState();
}

class _EditSlTpDialogState extends State<EditSlTpDialog> {
  late final TextEditingController _slCtrl;
  late final TextEditingController _tpCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _slCtrl = TextEditingController(text: _initial(widget.order.stopLoss));
    _tpCtrl = TextEditingController(text: _initial(widget.order.takeProfit));
  }

  @override
  void dispose() {
    _slCtrl.dispose();
    _tpCtrl.dispose();
    super.dispose();
  }

  /// Render 0 as empty so the user sees "(none)" hint instead of a literal 0.
  String _initial(double v) => v == 0 ? '' : v.toString();

  num _parse(String s) {
    final trimmed = s.trim();
    if (trimmed.isEmpty) return 0;
    return num.tryParse(trimmed) ?? 0;
  }

  Future<void> _save() async {
    final sl = _parse(_slCtrl.text);
    final tp = _parse(_tpCtrl.text);

    setState(() => _isSaving = true);
    final repo = context.read<TradingRepository>();
    final ok = await repo.modifyOrder(
      account: widget.account,
      ticket: widget.order.ticket,
      stopLoss: sl,
      takeProfit: tp,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order #${widget.order.ticket} updated')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order #${widget.order.ticket}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        width: 720,
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Edit SL / TP',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Order summary card — Wrap so chips reflow on any width
            // instead of overlapping when ticket / symbol / etc. are long.
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  _kv('Ticket', '#${o.ticket}', mono: true),
                  _kv('Symbol', o.symbol),
                  _kv('Side', o.orderType, color: o.isBuy ? Colors.green : (o.isSell ? Colors.redAccent : Colors.grey)),
                  _kv('Lots', _fmtLots(o.lots)),
                  _kv('Open', _fmtPrice(o.openPrice)),
                  _kv('Current', _fmtPrice(o.closePrice)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SL / TP inputs side-by-side
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _slCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Stop Loss',
                      hintText: 'leave empty',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    controller: _tpCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Take Profit',
                      hintText: 'leave empty',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Empty or 0 clears that level.',
              style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),

            // Footer buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// A compact label-over-value pair. Used inside the Wrap so order
  /// metadata reflows cleanly instead of overlapping or truncating.
  Widget _kv(String label, String value, {Color? color, bool mono = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
            fontFamily: mono ? 'monospace' : null,
          ),
        ),
      ],
    );
  }

  String _fmtLots(double lots) => lots.toStringAsFixed(2);
  String _fmtPrice(double p) => p == 0 ? '—' : p.toStringAsFixed(p > 1000 ? 2 : 5);
}
