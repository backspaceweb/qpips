import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum CancelDtoPlatformType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3),
  @JsonValue(4)
  value_4(4),
  @JsonValue(5)
  value_5(5);

  final int? value;

  const CancelDtoPlatformType(this.value);
}

enum CancelDtoAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const CancelDtoAccountStatus(this.value);
}

enum ApiV1GetOrdersMt4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrdersMt4PostAccountStatus(this.value);
}

enum ApiV1ModifyOrderMt4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyOrderMt4PostAccountStatus(this.value);
}

enum ApiV1CloseOrderMt4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseOrderMt4PostAccountStatus(this.value);
}

enum ApiV1Mt4PartialCloseOrderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1Mt4PartialCloseOrderPostAccountStatus(this.value);
}

enum ApiV1SendPendingOrderMt4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1SendPendingOrderMt4PostAccountStatus(this.value);
}

enum ApiV1ModifyPendingOrderMt4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyPendingOrderMt4PostAccountStatus(this.value);
}

enum ApiV1ClosePendingOrderMt4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ClosePendingOrderMt4PostAccountStatus(this.value);
}

enum ApiV1CloseAllOrdersForMT4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrdersForMT4PostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySellMT4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySellMT4PostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderByBuyMT4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderByBuyMT4PostAccountStatus(this.value);
}

enum ApiV1GetOrderHistoryMt4PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrderHistoryMt4PostAccountStatus(this.value);
}

enum ApiV1Mt4UpdateRiskPostRiskType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1Mt4UpdateRiskPostRiskType(this.value);
}

enum ApiV1Mt4UpdateStopsLimitsPostScalperMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2);

  final int? value;

  const ApiV1Mt4UpdateStopsLimitsPostScalperMode(this.value);
}

enum ApiV1Mt4UpdateStopsLimitsPostOrderFilter {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1Mt4UpdateStopsLimitsPostOrderFilter(this.value);
}

enum ApiV1SendOrderMt5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1SendOrderMt5PostAccountStatus(this.value);
}

enum ApiV1GetOrdersMt5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrdersMt5PostAccountStatus(this.value);
}

enum ApiV1ModifyOrderMt5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyOrderMt5PostAccountStatus(this.value);
}

enum ApiV1CloseOrderForMT5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseOrderForMT5PostAccountStatus(this.value);
}

enum ApiV1Mt5PartialCloseOrderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1Mt5PartialCloseOrderPostAccountStatus(this.value);
}

enum ApiV1SendPendingOrderMt5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1SendPendingOrderMt5PostAccountStatus(this.value);
}

enum ApiV1ModifyPendingOrderForMT5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyPendingOrderForMT5PostAccountStatus(this.value);
}

enum ApiV1ClosePendingOrderMt5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ClosePendingOrderMt5PostAccountStatus(this.value);
}

enum ApiV1CloseAllOrdersForMT5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrdersForMT5PostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySellMT5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySellMT5PostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderByBuyMT5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderByBuyMT5PostAccountStatus(this.value);
}

enum ApiV1GetOrderHistoryMt5PostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrderHistoryMt5PostAccountStatus(this.value);
}

enum ApiV1Mt5UpdateRiskPostRiskType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1Mt5UpdateRiskPostRiskType(this.value);
}

enum ApiV1Mt5UpdateStopsLimitsPostScalperMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2);

  final int? value;

  const ApiV1Mt5UpdateStopsLimitsPostScalperMode(this.value);
}

enum ApiV1Mt5UpdateStopsLimitsPostOrderFilter {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1Mt5UpdateStopsLimitsPostOrderFilter(this.value);
}

enum ApiV1SendOrderCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1SendOrderCtraderPostAccountStatus(this.value);
}

enum ApiV1GetOrdersCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrdersCtraderPostAccountStatus(this.value);
}

enum ApiV1ModifyOrderCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyOrderCtraderPostAccountStatus(this.value);
}

enum ApiV1CloseOrderCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseOrderCtraderPostAccountStatus(this.value);
}

enum ApiV1CtraderPartialCloseOrderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CtraderPartialCloseOrderPostAccountStatus(this.value);
}

enum ApiV1SendPendingOrderCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1SendPendingOrderCtraderPostAccountStatus(this.value);
}

enum ApiV1ModifyPendingOrderCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyPendingOrderCtraderPostAccountStatus(this.value);
}

enum ApiV1ClosePendingOrderCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ClosePendingOrderCtraderPostAccountStatus(this.value);
}

enum ApiV1CloseAllOrdersForCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrdersForCtraderPostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySellCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySellCtraderPostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderByBuyCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderByBuyCtraderPostAccountStatus(this.value);
}

enum ApiV1GetOrderHistoryCtraderPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrderHistoryCtraderPostAccountStatus(this.value);
}

enum ApiV1GetOrderHistoryCtraderMasterPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrderHistoryCtraderMasterPostAccountStatus(this.value);
}

enum ApiV1GetAllSymbolCtraderUserIdGetAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetAllSymbolCtraderUserIdGetAccountStatus(this.value);
}

enum ApiV1GetAllSymbolMT5UserIdGetAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetAllSymbolMT5UserIdGetAccountStatus(this.value);
}

enum ApiV1GetAllSymbolMT4UserIdGetAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetAllSymbolMT4UserIdGetAccountStatus(this.value);
}

enum ApiV1CtraderUpdateRiskPostRiskType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1CtraderUpdateRiskPostRiskType(this.value);
}

enum ApiV1CtraderUpdateStopsLimitsPostScalperMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2);

  final int? value;

  const ApiV1CtraderUpdateStopsLimitsPostScalperMode(this.value);
}

enum ApiV1CtraderUpdateStopsLimitsPostOrderFilter {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1CtraderUpdateStopsLimitsPostOrderFilter(this.value);
}

enum ApiV1GetOpenPositionDxTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOpenPositionDxTradePostAccountStatus(this.value);
}

enum ApiV1ModifyPositionDxtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyPositionDxtradePostAccountStatus(this.value);
}

enum ApiV1ClosePositionDxtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ClosePositionDxtradePostAccountStatus(this.value);
}

enum ApiV1PartialCloseOrderDxtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1PartialCloseOrderDxtradePostAccountStatus(this.value);
}

enum ApiV1CloseAllOrdersForDxtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrdersForDxtradePostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySellForDxtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySellForDxtradePostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus(this.value);
}

enum ApiV1GetPendingOrdersDxTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetPendingOrdersDxTradePostAccountStatus(this.value);
}

enum ApiV1ModifyPendingOrderDxtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyPendingOrderDxtradePostAccountStatus(this.value);
}

enum ApiV1ClosePendingOrderDxtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ClosePendingOrderDxtradePostAccountStatus(this.value);
}

enum ApiV1GetOrderHistoryDxtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrderHistoryDxtradePostAccountStatus(this.value);
}

enum ApiV1DxTradeUpdateRiskPostRiskType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1DxTradeUpdateRiskPostRiskType(this.value);
}

enum ApiV1DxTradeUpdateStopsLimitsPostScalperMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2);

  final int? value;

  const ApiV1DxTradeUpdateStopsLimitsPostScalperMode(this.value);
}

enum ApiV1DxTradeUpdateStopsLimitsPostOrderFilter {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1DxTradeUpdateStopsLimitsPostOrderFilter(this.value);
}

enum ApiV1SendPositionTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1SendPositionTradeLockerPostAccountStatus(this.value);
}

enum ApiV1GetOrdersTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrdersTradeLockerPostAccountStatus(this.value);
}

enum ApiV1GetOrderHistoryTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrderHistoryTradeLockerPostAccountStatus(this.value);
}

enum ApiV1ModifyPositionTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyPositionTradeLockerPostAccountStatus(this.value);
}

enum ApiV1ClosePositionTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ClosePositionTradeLockerPostAccountStatus(this.value);
}

enum ApiV1PartialCloseTradeLockerPostionPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1PartialCloseTradeLockerPostionPostAccountStatus(this.value);
}

enum ApiV1CloseAllOrdersForTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrdersForTradeLockerPostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus(this.value);
}

enum ApiV1SendPendingOrderTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1SendPendingOrderTradeLockerPostAccountStatus(this.value);
}

enum ApiV1ModifyPendingOrderTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyPendingOrderTradeLockerPostAccountStatus(this.value);
}

enum ApiV1ClosePendingOrderTradeLockerPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ClosePendingOrderTradeLockerPostAccountStatus(this.value);
}

enum ApiV1TradeLockerUpdateRiskPostRiskType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1TradeLockerUpdateRiskPostRiskType(this.value);
}

enum ApiV1TradeLockerUpdateStopsLimitsPostScalperMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2);

  final int? value;

  const ApiV1TradeLockerUpdateStopsLimitsPostScalperMode(this.value);
}

enum ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter(this.value);
}

enum ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus(this.value);
}

enum ApiV1SendPositionMatchTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1SendPositionMatchTradePostAccountStatus(this.value);
}

enum ApiV1GetOrdersMatchTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetOrdersMatchTradePostAccountStatus(this.value);
}

enum ApiV1ModifyPositionMatchTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyPositionMatchTradePostAccountStatus(this.value);
}

enum ApiV1ClosePositionMatchTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ClosePositionMatchTradePostAccountStatus(this.value);
}

enum ApiV1PartialCloseMatchTradePostionPostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1PartialCloseMatchTradePostionPostAccountStatus(this.value);
}

enum ApiV1CloseAllOrdersForMatchtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrdersForMatchtradePostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus(this.value);
}

enum ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus(this.value);
}

enum ApiV1SendPendingOrderMatchTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1SendPendingOrderMatchTradePostAccountStatus(this.value);
}

enum ApiV1ModifyPendingOrderMatchTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ModifyPendingOrderMatchTradePostAccountStatus(this.value);
}

enum ApiV1ClosePendingOrderMatchTradePostAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1ClosePendingOrderMatchTradePostAccountStatus(this.value);
}

enum ApiV1MatchTradeUpdateRiskPostRiskType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1MatchTradeUpdateRiskPostRiskType(this.value);
}

enum ApiV1MatchTradeUpdateStopsLimitsPostScalperMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2);

  final int? value;

  const ApiV1MatchTradeUpdateStopsLimitsPostScalperMode(this.value);
}

enum ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2),
  @JsonValue(3)
  value_3(3);

  final int? value;

  const ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter(this.value);
}

enum ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1);

  final int? value;

  const ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus(this.value);
}
