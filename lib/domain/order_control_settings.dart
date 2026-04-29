import '../core/api/generated/api.swagger.dart';

/// User-editable subset of the trading server's `FollowRiskSetting`.
///
/// The server's GET response (`FollowRiskSetting`) returns 21 fields,
/// but the corresponding update endpoint accepts only 11 — the remaining
/// fields are server-computed ranges (`*_From`/`*_To`) that we don't
/// expose to the user.
///
/// Field naming is taken from the update endpoint's parameter names. The
/// labels below come from the OpenAPI docstrings:
///
/// | Field                     | Server-side meaning                              |
/// |---------------------------|--------------------------------------------------|
/// | profitOverPoint           | Close per-order at this profit-points threshold  |
/// | lossOverPoint             | Close per-order at this loss-points threshold    |
/// | profitForEveryOrder       | Close per-order when profit reaches this amount  |
/// | lossForEveryOrder         | Close per-order when loss reaches this amount    |
/// | profitForAllOrder         | Close ALL orders when total profit reaches this  |
/// | lossForAllOrder           | Close ALL orders when total loss reaches this    |
/// | equityUnderLow            | Close ALL if equity drops below this             |
/// | equityUnderHigh           | Close ALL if equity rises above this             |
/// | pendingOrderProfitPoint   | Pending order: source profit-point trigger       |
/// | pendingOrderLossPoint     | Pending order: source loss-point trigger         |
/// | pendingTimeout            | Pending order: timeout in MINUTES                |
///
/// All fields are integers per the server contract. Setting a field to
/// 0 disables that auto-close trigger (default state for fresh accounts).
class OrderControlSettings {
  final int profitOverPoint;
  final int lossOverPoint;
  final int profitForEveryOrder;
  final int lossForEveryOrder;
  final int profitForAllOrder;
  final int lossForAllOrder;
  final int equityUnderLow;
  final int equityUnderHigh;
  final int pendingOrderProfitPoint;
  final int pendingOrderLossPoint;
  final int pendingTimeout;

  const OrderControlSettings({
    this.profitOverPoint = 0,
    this.lossOverPoint = 0,
    this.profitForEveryOrder = 0,
    this.lossForEveryOrder = 0,
    this.profitForAllOrder = 0,
    this.lossForAllOrder = 0,
    this.equityUnderLow = 0,
    this.equityUnderHigh = 0,
    this.pendingOrderProfitPoint = 0,
    this.pendingOrderLossPoint = 0,
    this.pendingTimeout = 0,
  });

  static const empty = OrderControlSettings();

  /// Build from the swagger-generated FollowRiskSetting GET response.
  /// Mapping is taken from the OpenAPI update-endpoint docstrings, which
  /// describe each update param in terms of the GET field it overwrites.
  factory OrderControlSettings.fromFollowRiskSetting(FollowRiskSetting r) {
    return OrderControlSettings(
      profitOverPoint: (r.closeProfitPointHigh ?? 0).toInt(),
      lossOverPoint: (r.closeLossPointHigh ?? 0).toInt(),
      profitForEveryOrder: (r.closeprofithigh ?? 0).toInt(),
      lossForEveryOrder: (r.closelosshigh ?? 0).toInt(),
      profitForAllOrder: (r.closeallprofithigh ?? 0).toInt(),
      lossForAllOrder: (r.closealllosshigh ?? 0).toInt(),
      equityUnderLow: (r.closeallequitylow ?? 0).toInt(),
      equityUnderHigh: (r.closeallequityhigh ?? 0).toInt(),
      pendingOrderProfitPoint: (r.sourcePendingProfitPointCloseFollow ?? 0).toInt(),
      pendingOrderLossPoint: (r.sourcePendingLossPointCloseFollow ?? 0).toInt(),
      pendingTimeout: (r.closePendingTimeOut ?? 0).toInt(),
    );
  }

  OrderControlSettings copyWith({
    int? profitOverPoint,
    int? lossOverPoint,
    int? profitForEveryOrder,
    int? lossForEveryOrder,
    int? profitForAllOrder,
    int? lossForAllOrder,
    int? equityUnderLow,
    int? equityUnderHigh,
    int? pendingOrderProfitPoint,
    int? pendingOrderLossPoint,
    int? pendingTimeout,
  }) {
    return OrderControlSettings(
      profitOverPoint: profitOverPoint ?? this.profitOverPoint,
      lossOverPoint: lossOverPoint ?? this.lossOverPoint,
      profitForEveryOrder: profitForEveryOrder ?? this.profitForEveryOrder,
      lossForEveryOrder: lossForEveryOrder ?? this.lossForEveryOrder,
      profitForAllOrder: profitForAllOrder ?? this.profitForAllOrder,
      lossForAllOrder: lossForAllOrder ?? this.lossForAllOrder,
      equityUnderLow: equityUnderLow ?? this.equityUnderLow,
      equityUnderHigh: equityUnderHigh ?? this.equityUnderHigh,
      pendingOrderProfitPoint: pendingOrderProfitPoint ?? this.pendingOrderProfitPoint,
      pendingOrderLossPoint: pendingOrderLossPoint ?? this.pendingOrderLossPoint,
      pendingTimeout: pendingTimeout ?? this.pendingTimeout,
    );
  }
}
