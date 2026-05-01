import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account.dart';
import 'package:qp_core/domain/trade_order.dart';
import 'package:qp_core/repositories/trader_live_state_controller.dart';
import 'package:qp_core/repositories/trading_repository.dart';
import 'package:qp_design/app_colors.dart';

/// Bottom sheet showing live order data for a single account.
///
/// Open-orders are sourced from [TraderLiveStateController] (already
/// polling at 3s for the whole fleet — no extra API cost). History
/// is fetched on mount and auto-refreshed every 30s while the sheet
/// is open. Manual refresh button forces both.
class AccountDetailsSheet extends StatefulWidget {
  final Account account;

  const AccountDetailsSheet({super.key, required this.account});

  @override
  State<AccountDetailsSheet> createState() => _AccountDetailsSheetState();
}

class _AccountDetailsSheetState extends State<AccountDetailsSheet> {
  bool _historyLoading = true;
  List<TradeOrder> _history = [];
  Timer? _historyTimer;

  // Per-tab scroll controllers so horizontal + vertical Scrollbars can
  // anchor onto the right inner scroll view. Without explicit controllers
  // the always-visible scrollbar can't track which view it belongs to.
  final _openHCtrl = ScrollController();
  final _openVCtrl = ScrollController();
  final _historyHCtrl = ScrollController();
  final _historyVCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _historyTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _loadHistory(silent: true),
    );
  }

  @override
  void dispose() {
    _historyTimer?.cancel();
    _openHCtrl.dispose();
    _openVCtrl.dispose();
    _historyHCtrl.dispose();
    _historyVCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadHistory({bool silent = false}) async {
    if (!silent) {
      setState(() => _historyLoading = true);
    }
    try {
      final repo = context.read<TradingRepository>();
      final now = DateTime.now();
      final from = now.subtract(const Duration(days: 7));
      final history = await repo.getOrderHistory(
        account: widget.account,
        from: from,
        to: now,
        tradesOnly: true,
      );
      if (!mounted) return;
      setState(() {
        _history = history;
        _historyLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _historyLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    // Card-style on wide screens: cap width, round all four corners,
    // float above the bottom edge so the page doesn't feel "consumed."
    // On narrow screens (<900px) fall back to a full-width sheet docked
    // to the bottom — that's the right shape on phones/tablets.
    final isWide = screenW >= 900;
    // Modal-card width: proportional to screen, clamped so it never feels
    // cramped on a small laptop or lost on an ultrawide. 65% of screen
    // hits a good "focused panel" feel.
    final cardMaxWidth = (screenW * 0.65).clamp(880.0, 1180.0);
    final bottomGap = isWide ? 64.0 : 0.0;
    final sideGap = isWide ? 24.0 : 0.0;
    final radius = isWide
        ? BorderRadius.circular(24)
        : const BorderRadius.vertical(top: Radius.circular(28));

    return Consumer<TraderLiveStateController>(
      builder: (context, ctrl, _) {
        final open = ctrl.openOrdersFor(widget.account.serverId);
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(sideGap, 0, sideGap, bottomGap),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: cardMaxWidth),
              child: DefaultTabController(
                length: 2,
                child: Container(
                  width: double.infinity,
                  height: screenH * (isWide ? 0.78 : 0.9),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: radius,
                    boxShadow: isWide
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      _buildDragHandle(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 4, 16, 0),
                  child: _buildHeader(isDark, ctrl),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: _buildStatsStrip(isDark, open),
                ),
                const SizedBox(height: 20),
                _buildTabBar(isDark, open),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTabContent(
                        isOpenView: true,
                        orders: open,
                        loading: false,
                        isDark: isDark,
                        emptyText: 'No open orders right now.',
                        emptyIcon: Icons.trending_flat,
                        hCtrl: _openHCtrl,
                        vCtrl: _openVCtrl,
                      ),
                      _buildTabContent(
                        isOpenView: false,
                        orders: _history,
                        loading: _historyLoading,
                        isDark: isDark,
                        emptyText: 'No closed trades in the last 7 days.',
                        emptyIcon: Icons.history_toggle_off,
                        hCtrl: _historyHCtrl,
                        vCtrl: _historyVCtrl,
                      ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
      },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 44,
      height: 4,
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(bool isDark, TraderLiveStateController ctrl) {
    final acc = widget.account;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    acc.accountName.isEmpty ? 'Account ${acc.serverId}' : acc.accountName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.1),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Login ${acc.loginNumber} · Server ID ${acc.serverId}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _historyLoading
                  ? null
                  : () {
                      ctrl.refresh();
                      _loadHistory();
                    },
              tooltip: 'Reload',
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Close',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _chip(acc.accountType.wireValue, acc.isMaster ? Colors.purple : Colors.teal),
            _chip(acc.platform.wireValue, acc.platform == Platform.mt5 ? Colors.blue : Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  /// Top metric strip: open count, open P&L, history count, history net P&L.
  Widget _buildStatsStrip(bool isDark, List<TradeOrder> open) {
    final openPnl = open.fold<double>(0, (s, o) => s + o.profit);
    final histPnl = _history.fold<double>(
      0,
      (s, o) => s + o.profit + o.commission + o.swap,
    );

    return Row(
      children: [
        Expanded(child: _statCard('Open Trades', '${open.length}', isDark)),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            'Open P&L',
            _fmtMoney(openPnl),
            isDark,
            valueColor: _pnlColor(openPnl),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            'History (7d)',
            _historyLoading ? '—' : '${_history.length}',
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            'Net P&L (7d)',
            _historyLoading ? '—' : _fmtMoney(histPnl),
            isDark,
            valueColor: _pnlColor(histPnl),
          ),
        ),
      ],
    );
  }

  Color? _pnlColor(double v) =>
      v > 0 ? Colors.green : v < 0 ? Colors.redAccent : null;

  Widget _statCard(String label, String value, bool isDark, {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark, List<TradeOrder> open) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: TabBar(
        labelColor: AppColors.primaryAccent,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppColors.primaryAccent,
        indicatorWeight: 2.5,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        tabs: [
          Tab(text: 'Open Orders (${open.length})'),
          Tab(
            text: _historyLoading
                ? 'History (7d)'
                : 'History (${_history.length})',
          ),
        ],
      ),
    );
  }

  // Shared column layout for header + body rows so they line up exactly.
  // Flex weights add to ~95; at popup width 1100 each unit is ~11px.
  static const _columnFlex = [14, 9, 7, 7, 9, 9, 9, 9, 11, 11];
  static const _columnNumeric = [
    false, false, false, true, true, true, true, true, true, false,
  ];

  Widget _buildTabContent({
    required bool isOpenView,
    required List<TradeOrder> orders,
    required bool loading,
    required bool isDark,
    required String emptyText,
    required IconData emptyIcon,
    required ScrollController hCtrl,
    required ScrollController vCtrl,
  }) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders.isEmpty) {
      return _buildEmpty(emptyText, emptyIcon);
    }
    // Header pinned outside the vertical scroll so it stays visible while
    // body rows scroll. Header and body share `_columnFlex` so columns
    // line up perfectly. On narrow screens (<900) we wrap in a horizontal
    // scroll to keep columns from collapsing — header + body scroll
    // together because they live in the same horizontal scroll view.
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const minTableWidth = 900.0;
          final needsHScroll = constraints.maxWidth < minTableWidth;
          final tableWidth =
              needsHScroll ? minTableWidth : constraints.maxWidth;

          Widget pinnedTable = SizedBox(
            width: tableWidth,
            child: Column(
              children: [
                _buildHeaderRow(isOpenView, isDark),
                Expanded(
                  child: Scrollbar(
                    controller: vCtrl,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: vCtrl,
                      itemCount: orders.length,
                      itemBuilder: (_, i) =>
                          _buildBodyRow(orders[i], isOpenView, isDark),
                    ),
                  ),
                ),
              ],
            ),
          );

          if (!needsHScroll) return pinnedTable;
          return Scrollbar(
            controller: hCtrl,
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              controller: hCtrl,
              scrollDirection: Axis.horizontal,
              child: pinnedTable,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty(String text, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.grey.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(bool isOpenView, bool isDark) {
    final headers = [
      'Ticket', 'Symbol', 'Side', 'Lots', 'Open',
      isOpenView ? 'Current' : 'Close', 'SL', 'TP', 'Profit', 'Time',
    ];
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.grey.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white12
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < headers.length; i++)
            _cell(
              i,
              Text(
                headers[i],
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBodyRow(TradeOrder o, bool isOpenView, bool isDark) {
    const cellStyle = TextStyle(fontSize: 12.5);
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.04),
          ),
        ),
      ),
      child: Row(
        children: [
          _cell(
            0,
            Text(
              o.ticket.toString(),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          _cell(1, Text(o.symbol, style: cellStyle)),
          _cell(2, _sideChip(o)),
          _cell(3, Text(_fmtLots(o.lots), style: cellStyle)),
          _cell(4, Text(_fmtPrice(o.openPrice), style: cellStyle)),
          _cell(5, Text(_fmtPrice(o.closePrice), style: cellStyle)),
          _cell(
            6,
            Text(
              o.stopLoss == 0 ? '—' : _fmtPrice(o.stopLoss),
              style: cellStyle,
            ),
          ),
          _cell(
            7,
            Text(
              o.takeProfit == 0 ? '—' : _fmtPrice(o.takeProfit),
              style: cellStyle,
            ),
          ),
          _cell(
            8,
            Text(
              _fmtMoney(o.profit),
              style: TextStyle(
                fontSize: 12.5,
                color: o.profit > 0
                    ? Colors.green
                    : o.profit < 0
                        ? Colors.redAccent
                        : null,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _cell(
            9,
            Text(
              _fmtTime(isOpenView ? o.openTime : o.lastUpdateTime),
              style: cellStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(int idx, Widget child) {
    return Expanded(
      flex: _columnFlex[idx],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Align(
          alignment: _columnNumeric[idx]
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: child,
        ),
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
