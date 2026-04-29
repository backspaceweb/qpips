import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/account.dart';
import '../../../../domain/trade_order.dart';
import '../../../../repositories/trading_repository.dart';

/// Bottom sheet showing live order data for a single account.
///
/// Loads `getOpenOrders` and `getOrderHistory` (last 7 days, trades
/// only) in parallel and renders two tables. Used by the dashboard's
/// info-icon action.
class AccountDetailsSheet extends StatefulWidget {
  final Account account;

  const AccountDetailsSheet({super.key, required this.account});

  @override
  State<AccountDetailsSheet> createState() => _AccountDetailsSheetState();
}

class _AccountDetailsSheetState extends State<AccountDetailsSheet> {
  bool _loading = true;
  List<TradeOrder> _open = [];
  List<TradeOrder> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = context.read<TradingRepository>();
    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 7));

    final results = await Future.wait([
      repo.getOpenOrders(account: widget.account),
      repo.getOrderHistory(
        account: widget.account,
        from: from,
        to: now,
        tradesOnly: true,
      ),
    ]);

    if (!mounted) return;
    setState(() {
      _open = results[0];
      _history = results[1];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (sheetContext, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(sheetContext).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(isDark),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Open Orders', _open.length),
                      const SizedBox(height: 12),
                      _loading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : _open.isEmpty
                              ? _buildEmpty('No open orders.')
                              : _buildOrdersTable(_open, isOpenView: true, isDark: isDark),
                      const SizedBox(height: 32),
                      _buildSectionHeader('Recent History (last 7 days)', _history.length),
                      const SizedBox(height: 12),
                      _loading
                          ? const SizedBox.shrink()
                          : _history.isEmpty
                              ? _buildEmpty('No closed trades in this period.')
                              : _buildOrdersTable(_history, isOpenView: false, isDark: isDark),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    final acc = widget.account;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                acc.accountName.isEmpty ? 'Account ${acc.serverId}' : acc.accountName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loading
                  ? null
                  : () {
                      setState(() => _loading = true);
                      _load();
                    },
              tooltip: 'Reload',
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _chip('Login: ${acc.loginNumber}', Colors.grey),
            _chip(acc.accountType.wireValue, acc.isMaster ? Colors.purple : Colors.teal),
            _chip(acc.platform.wireValue, acc.platform == Platform.mt5 ? Colors.blue : Colors.orange),
            _chip('Server ID: ${acc.serverId}', Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSectionHeader(String label, int count) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildEmpty(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.grey))),
    );
  }

  Widget _buildOrdersTable(List<TradeOrder> orders, {required bool isOpenView, required bool isDark}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowColor: WidgetStateProperty.all(
          isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.withValues(alpha: 0.08),
        ),
        columns: [
          const DataColumn(label: Text('Ticket')),
          const DataColumn(label: Text('Symbol')),
          const DataColumn(label: Text('Side')),
          const DataColumn(label: Text('Lots'), numeric: true),
          const DataColumn(label: Text('Open'), numeric: true),
          DataColumn(label: Text(isOpenView ? 'Current' : 'Close'), numeric: true),
          const DataColumn(label: Text('SL'), numeric: true),
          const DataColumn(label: Text('TP'), numeric: true),
          const DataColumn(label: Text('Profit'), numeric: true),
          const DataColumn(label: Text('Time')),
        ],
        rows: orders.map((o) => DataRow(cells: [
          DataCell(Text(o.ticket.toString(), style: const TextStyle(fontFamily: 'monospace'))),
          DataCell(Text(o.symbol)),
          DataCell(_sideChip(o)),
          DataCell(Text(_fmtLots(o.lots))),
          DataCell(Text(_fmtPrice(o.openPrice))),
          DataCell(Text(_fmtPrice(o.closePrice))),
          DataCell(Text(o.stopLoss == 0 ? '—' : _fmtPrice(o.stopLoss))),
          DataCell(Text(o.takeProfit == 0 ? '—' : _fmtPrice(o.takeProfit))),
          DataCell(Text(
            _fmtMoney(o.profit),
            style: TextStyle(
              color: o.profit > 0
                  ? Colors.green
                  : o.profit < 0
                      ? Colors.redAccent
                      : null,
              fontWeight: FontWeight.bold,
            ),
          )),
          DataCell(Text(_fmtTime(isOpenView ? o.openTime : o.lastUpdateTime))),
        ])).toList(),
      ),
    );
  }

  Widget _sideChip(TradeOrder o) {
    final color = o.isBuy ? Colors.green : (o.isSell ? Colors.redAccent : Colors.grey);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        o.orderType,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _fmtLots(double lots) => lots.toStringAsFixed(2);

  String _fmtPrice(double p) {
    if (p == 0) return '—';
    return p.toStringAsFixed(p > 1000 ? 2 : 5);
  }

  String _fmtMoney(double m) {
    final sign = m < 0 ? '-' : '';
    return '$sign\$${m.abs().toStringAsFixed(2)}';
  }

  String _fmtTime(DateTime? t) {
    if (t == null) return '—';
    final local = t.toLocal();
    final mm = local.month.toString().padLeft(2, '0');
    final dd = local.day.toString().padLeft(2, '0');
    final hh = local.hour.toString().padLeft(2, '0');
    final mn = local.minute.toString().padLeft(2, '0');
    return '$mm/$dd $hh:$mn';
  }
}
