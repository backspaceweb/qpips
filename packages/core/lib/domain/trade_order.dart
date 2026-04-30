/// A single order/position/balance entry as returned by the trading
/// server's `get_orders_*` and `get_order_history_*` endpoints.
///
/// MT4 and MT5 both go through this model. The shape was derived from a
/// live MT5 probe on 2026-04-29; MT4's exact field names may differ
/// slightly, so [fromMap] is parse-tolerant (accepts common alternate
/// keys like `tp`/`sl`/`openPrice`/`closeTime`).
///
/// Note on `closePrice`:
///   - For an OPEN order, the server reports the current market quote.
///   - For a CLOSED history entry, it reports the actual close price.
/// Same field, different meaning depending on context.
///
/// Note on `dealType: "Balance"`:
///   - History endpoints mix in non-trade entries (e.g. account funding).
///     [isBalanceEntry] filters them out for trade-only views.
library;

class TradeOrder {
  /// Unique broker-side ticket / order ID.
  final int ticket;
  final double takeProfit;
  final double stopLoss;

  /// Open price (MT5 calls this `price`; MT4 sometimes `openPrice`).
  final double openPrice;
  final double lots;

  /// "Buy" / "Sell" / "Balance" / pending-order types.
  final String orderType;
  final String symbol;

  /// "DealBuy" / "DealSell" / "Balance" / etc.
  final String dealType;
  final String comment;

  /// Pending-order target price; 0 for market orders.
  final double limitPrice;

  final DateTime? openTime;
  final DateTime? lastUpdateTime;
  final double profit;
  final double commission;
  final double swap;

  /// Open order: current market quote. Closed history: actual close price.
  final double closePrice;

  /// Server-reserved field; currently always 0 in observed responses.
  final double netprofit;

  const TradeOrder({
    required this.ticket,
    required this.takeProfit,
    required this.stopLoss,
    required this.openPrice,
    required this.lots,
    required this.orderType,
    required this.symbol,
    required this.dealType,
    required this.comment,
    required this.limitPrice,
    required this.openTime,
    required this.lastUpdateTime,
    required this.profit,
    required this.commission,
    required this.swap,
    required this.closePrice,
    required this.netprofit,
  });

  bool get isBalanceEntry => dealType == 'Balance' || orderType == 'Balance';
  bool get isBuy => orderType == 'Buy' || orderType == 'BuyLimit' || orderType == 'BuyStop';
  bool get isSell => orderType == 'Sell' || orderType == 'SellLimit' || orderType == 'SellStop';
  bool get isPending => orderType.contains('Limit') || orderType.contains('Stop');

  factory TradeOrder.fromMap(Map<String, dynamic> m) {
    return TradeOrder(
      ticket: _parseInt(m['ticket']) ?? 0,
      takeProfit: _parseDouble(m['takeProfit'] ?? m['tp']) ?? 0,
      stopLoss: _parseDouble(m['stopLoss'] ?? m['sl']) ?? 0,
      openPrice: _parseDouble(m['price'] ?? m['openPrice']) ?? 0,
      lots: _parseDouble(m['lots']) ?? 0,
      orderType: (m['orderType'] ?? m['type'] ?? '').toString(),
      symbol: (m['symbol'] ?? '').toString(),
      dealType: (m['dealType'] ?? '').toString(),
      comment: (m['comment'] ?? '').toString(),
      limitPrice: _parseDouble(m['limitPrice']) ?? 0,
      openTime: _parseDateTime(m['openTime']),
      lastUpdateTime: _parseDateTime(m['lastUpdateTime'] ?? m['closeTime']),
      profit: _parseDouble(m['profit']) ?? 0,
      commission: _parseDouble(m['commission']) ?? 0,
      swap: _parseDouble(m['swap']) ?? 0,
      closePrice: _parseDouble(m['closePrice']) ?? 0,
      netprofit: _parseDouble(m['netprofit']) ?? 0,
    );
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static DateTime? _parseDateTime(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}
