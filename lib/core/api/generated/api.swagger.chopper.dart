// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$Api extends Api {
  _$Api([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = Api;

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterMasterMt4Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/register_master_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterSlaveMt4Post({
    required int? userId,
    required String? password,
    required String? server,
    required int? masterId,
    String? comment,
    required int? copyOrderType,
  }) {
    final Uri $url = Uri.parse('/api/v1/register_slave_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'masterId': masterId,
      'comment': comment,
      'copyOrderType': copyOrderType,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateMasterMt4Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_Master_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateSlaveMt4Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_slave_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendOrderMt4Post({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_order_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'orderType': orderType,
      'lots': lots,
      'symbol': symbol,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<MT4OrderDtoListResponseDto>> _apiV1GetOrdersMt4Post({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_orders_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'userId': userId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<MT4OrderDtoListResponseDto, MT4OrderDtoListResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ModifyOrderMt4Post({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_order_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'ticket': ticket,
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseOrderMt4Post({
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_order_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1Mt4PartialCloseOrderPost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/mt4/partialCloseOrder');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'lots': lots,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendPendingOrderMt4Post({
    required int? userId,
    required String? orderType,
    required num? lots,
    required num? price,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_pending_order_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'orderType': orderType,
      'lots': lots,
      'price': price,
      'symbol': symbol,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1ModifyPendingOrderMt4Post({
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_pending_order_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1ClosePendingOrderMt4Post({
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_pending_order_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrdersForMT4Post({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrdersForMT4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<CancelDto>> _apiV1CloseAllOrderBySymbolForMT4Post({
    required int? userid,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySymbolForMT4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<CancelDto, CancelDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrderBySellMT4Post({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySell/MT4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrderByBuyMT4Post({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderByBuy/MT4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetOrderHistoryMt4Post({
    required String? accountStatus,
    required int? id,
    required DateTime? from,
    required DateTime? to,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_order_history_mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'id': id,
      'from': from,
      'to': to,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveMasterMT4Post({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_master/MT4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveSlaveMT4Post({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_slave/MT4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1SymbolMapMt4Post({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    final Uri $url = Uri.parse('/api/v1/symbol_map/mt4');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'sourceSymbol': sourceSymbol,
      'followSymbol': followSymbol,
      'type': type,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSuffixMt4UserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSuffix/mt4/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSpecialMt4UserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSpecial/mt4/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Risk>> _apiV1Mt4GetRiskGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/mt4/getRisk');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Risk, Risk>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1Mt4UpdateRiskPost({
    required int? userId,
    required String? riskType,
    required num? multiplier,
  }) {
    final Uri $url = Uri.parse('/api/v1/mt4/updateRisk');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'riskType': riskType,
      'multiplier': multiplier,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StopsLimits>> _apiV1Mt4GetStopsLimitsGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/mt4/getStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StopsLimits, StopsLimits>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1Mt4UpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required String? scalperMode,
    required String? orderFilter,
    required int? scalperValue,
  }) {
    final Uri $url = Uri.parse('/api/v1/mt4/updateStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'copySLTP': copySLTP,
      'scalperMode': scalperMode,
      'orderFilter': orderFilter,
      'scalperValue': scalperValue,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<FollowRiskSetting>> _apiV1Mt4GetOrderControlSettingsGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/mt4/getOrderControlSettings');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<FollowRiskSetting, FollowRiskSetting>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1Mt4UpdateOrderControlSettingPost({
    required int? userId,
    required int? profitOverPoint,
    required int? lossOverPoint,
    required int? profitForEveryOrder,
    required int? lossForEveryOrder,
    required int? profitForAllOrder,
    required int? lossForAllOrder,
    required int? equityUnderLow,
    required int? equityUnderHigh,
    required int? pendingOrderProfitPoint,
    required int? pendingOrderLossPoint,
    required int? pendingTimeout,
  }) {
    final Uri $url = Uri.parse('/api/v1/mt4/updateOrderControlSetting');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'profitOverPoint': profitOverPoint,
      'lossOverPoint': lossOverPoint,
      'profitForEveryOrder': profitForEveryOrder,
      'lossForEveryOrder': lossForEveryOrder,
      'profitForAllOrder': profitForAllOrder,
      'lossForAllOrder': lossForAllOrder,
      'equityUnderLow': equityUnderLow,
      'equityUnderHigh': equityUnderHigh,
      'pendingOrderProfitPoint': pendingOrderProfitPoint,
      'pendingOrderLossPoint': pendingOrderLossPoint,
      'pendingTimeout': pendingTimeout,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterMasterForMT5Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/RegisterMasterForMT5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterSlaveForMT5Post({
    required int? userId,
    required String? password,
    required String? server,
    required int? masterId,
    String? comment,
    required int? copyOrderType,
  }) {
    final Uri $url = Uri.parse('/api/v1/RegisterSlaveForMT5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'masterId': masterId,
      'comment': comment,
      'copyOrderType': copyOrderType,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateMasterMt5Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_Master_mt5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateSlaveMt5Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_slave_mt5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendOrderMt5Post({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_order_mt5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'orderType': orderType,
      'lots': lots,
      'symbol': symbol,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetOrdersMt5Post({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_orders_mt5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'userId': userId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ModifyOrderMt5Post({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_order_mt5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'ticket': ticket,
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseOrderForMT5Post({
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/closeOrderForMT5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1Mt5PartialCloseOrderPost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/mt5/partialCloseOrder');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'lots': lots,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendPendingOrderMt5Post({
    required int? userId,
    required String? orderType,
    required num? lots,
    required num? price,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_pending_order_mt5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'orderType': orderType,
      'lots': lots,
      'price': price,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1ModifyPendingOrderForMT5Post({
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modifyPendingOrderForMT5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1ClosePendingOrderMt5Post({
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_pending_order_mt5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrdersForMT5Post({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrdersForMT5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<CancelDto>> _apiV1CloseAllOrderBySymbolForMT5Post({
    required int? userid,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySymbolForMT5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<CancelDto, CancelDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrderBySellMT5Post({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySell/MT5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrderByBuyMT5Post({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderByBuy/MT5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetOrderHistoryMt5Post({
    required String? accountStatus,
    required int? id,
    required DateTime? from,
    required DateTime? to,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_order_history_mt5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'AccountStatus': accountStatus,
      'Id': id,
      'From': from,
      'To': to,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveMasterMT5Post({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_master/MT5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveSlaveMT5Post({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_slave/MT5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1SymbolMapMt5Post({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    final Uri $url = Uri.parse('/api/v1/symbol_map/mt5');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'sourceSymbol': sourceSymbol,
      'followSymbol': followSymbol,
      'type': type,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSuffixMt5UserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSuffix/mt5/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSpecialMt5UserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSpecial/mt5/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Risk>> _apiV1Mt5GetRiskGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/mt5/getRisk');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Risk, Risk>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1Mt5UpdateRiskPost({
    required int? userId,
    required String? riskType,
    required num? multiplier,
  }) {
    final Uri $url = Uri.parse('/api/v1/mt5/updateRisk');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'riskType': riskType,
      'multiplier': multiplier,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StopsLimits>> _apiV1Mt5GetStopsLimitsGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/mt5/getStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StopsLimits, StopsLimits>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1Mt5UpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required String? scalperMode,
    required String? orderFilter,
    required int? scalperValue,
  }) {
    final Uri $url = Uri.parse('/api/v1/mt5/updateStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'copySLTP': copySLTP,
      'scalperMode': scalperMode,
      'orderFilter': orderFilter,
      'scalperValue': scalperValue,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<FollowRiskSetting>> _apiV1Mt5GetOrderControlSettingsGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/mt5/getOrderControlSettings');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<FollowRiskSetting, FollowRiskSetting>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1Mt5UpdateOrderControlSettingPost({
    required int? userId,
    required int? profitOverPoint,
    required int? lossOverPoint,
    required int? profitForEveryOrder,
    required int? lossForEveryOrder,
    required int? profitForAllOrder,
    required int? lossForAllOrder,
    required int? equityUnderLow,
    required int? equityUnderHigh,
    required int? pendingOrderProfitPoint,
    required int? pendingOrderLossPoint,
    required int? pendingTimeout,
  }) {
    final Uri $url = Uri.parse('/api/v1/mt5/updateOrderControlSetting');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'profitOverPoint': profitOverPoint,
      'lossOverPoint': lossOverPoint,
      'profitForEveryOrder': profitForEveryOrder,
      'lossForEveryOrder': lossForEveryOrder,
      'profitForAllOrder': profitForAllOrder,
      'lossForAllOrder': lossForAllOrder,
      'equityUnderLow': equityUnderLow,
      'equityUnderHigh': equityUnderHigh,
      'pendingOrderProfitPoint': pendingOrderProfitPoint,
      'pendingOrderLossPoint': pendingOrderLossPoint,
      'pendingTimeout': pendingTimeout,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterMasterCtraderPost({
    required int? userId,
    required String? clientId,
    required String? clientSecret,
    required String? refreshToken,
    required String? expireIn,
    required String? email,
    required String? accountName,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/register_master_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'refreshToken': refreshToken,
      'expireIn': expireIn,
      'email': email,
      'accountName': accountName,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterSlaveCtraderPost({
    required int? userId,
    required String? clientId,
    required String? clientSecret,
    required String? refreshToken,
    String? expireIn,
    required int? masterId,
    String? email,
    required String? accountName,
    String? comment,
    required int? copyOrderType,
  }) {
    final Uri $url = Uri.parse('/api/v1/register_slave_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'refreshToken': refreshToken,
      'expireIn': expireIn,
      'masterId': masterId,
      'email': email,
      'accountName': accountName,
      'comment': comment,
      'copyOrderType': copyOrderType,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateMasterCtraderPost({
    required int? userId,
    required String? refreshToken,
    int? expireIn,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_Master_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'refreshToken': refreshToken,
      'expireIn': expireIn,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateSlaveCtraderPost({
    required int? userId,
    required String? refreshToken,
    int? expireIn,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_slave_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'refreshToken': refreshToken,
      'expireIn': expireIn,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendOrderCtraderPost({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_order_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'orderType': orderType,
      'lots': lots,
      'symbol': symbol,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<String>> _apiV1GetOrdersCtraderPost({
    required int? userId,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_orders_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ModifyOrderCtraderPost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_order_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'ticket': ticket,
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseOrderCtraderPost({
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_order_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CtraderPartialCloseOrderPost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/ctrader/partialCloseOrder');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'lots': lots,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendPendingOrderCtraderPost({
    required int? userId,
    required String? orderType,
    required String? symbol,
    required num? lots,
    required num? price,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_pending_order_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'orderType': orderType,
      'symbol': symbol,
      'lots': lots,
      'price': price,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1ModifyPendingOrderCtraderPost({
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_pending_order_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1ClosePendingOrderCtraderPost({
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_pending_order_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrdersForCtraderPost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrdersForCtrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<CancelDto>> _apiV1CloseAllOrderBySymbolForCtraderPost({
    required int? userid,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySymbolForCtrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<CancelDto, CancelDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrderBySellCtraderPost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySell/Ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrderByBuyCtraderPost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderByBuy/Ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetOrderHistoryCtraderPost({
    required String? accountStatus,
    required int? id,
    required DateTime? from,
    required DateTime? to,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_order_history_ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'id': id,
      'from': from,
      'to': to,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetOrderHistoryCtraderMasterPost({
    required String? accountStatus,
    required int? id,
    required DateTime? from,
    required DateTime? to,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_order_history_ctraderMaster');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'id': id,
      'from': from,
      'to': to,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveMasterCtraderPost({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_master/Ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveSlaveCtraderPost({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_slave/Ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1SymbolMapCtraderPost({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    final Uri $url = Uri.parse('/api/v1/symbol_map/ctrader');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'sourceSymbol': sourceSymbol,
      'followSymbol': followSymbol,
      'type': type,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSuffixCtraderUserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSuffix/ctrader/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSpecialCtraderUserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSpecial/ctrader/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetAllSymbolCtraderUserIdGet({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/getAllSymbol/ctrader/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetAllSymbolMT5UserIdGet({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/getAllSymbol/MT5/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetAllSymbolMT4UserIdGet({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/getAllSymbol/MT4/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<Risk>> _apiV1CtraderGetRiskGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/ctrader/getRisk');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Risk, Risk>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CtraderUpdateRiskPost({
    required int? userId,
    required String? riskType,
    required num? multiplier,
  }) {
    final Uri $url = Uri.parse('/api/v1/ctrader/updateRisk');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'riskType': riskType,
      'multiplier': multiplier,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StopsLimits>> _apiV1CtraderGetStopsLimitsGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/ctrader/getStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StopsLimits, StopsLimits>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CtraderUpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required String? scalperMode,
    required String? orderFilter,
    required int? scalperValue,
  }) {
    final Uri $url = Uri.parse('/api/v1/ctrader/updateStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'copySLTP': copySLTP,
      'scalperMode': scalperMode,
      'orderFilter': orderFilter,
      'scalperValue': scalperValue,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<FollowRiskSetting>> _apiV1CtraderGetOrderControlSettingsGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/ctrader/getOrderControlSettings');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<FollowRiskSetting, FollowRiskSetting>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CtraderUpdateOrderControlSettingPost({
    required int? userId,
    required int? profitOverPoint,
    required int? lossOverPoint,
    required int? profitForEveryOrder,
    required int? lossForEveryOrder,
    required int? profitForAllOrder,
    required int? lossForAllOrder,
    required int? equityUnderLow,
    required int? equityUnderHigh,
    required int? pendingOrderProfitPoint,
    required int? pendingOrderLossPoint,
    required int? pendingTimeout,
  }) {
    final Uri $url = Uri.parse('/api/v1/ctrader/updateOrderControlSetting');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'profitOverPoint': profitOverPoint,
      'lossOverPoint': lossOverPoint,
      'profitForEveryOrder': profitForEveryOrder,
      'lossForEveryOrder': lossForEveryOrder,
      'profitForAllOrder': profitForAllOrder,
      'lossForAllOrder': lossForAllOrder,
      'equityUnderLow': equityUnderLow,
      'equityUnderHigh': equityUnderHigh,
      'pendingOrderProfitPoint': pendingOrderProfitPoint,
      'pendingOrderLossPoint': pendingOrderLossPoint,
      'pendingTimeout': pendingTimeout,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterMasterDxTradePost({
    required int? userId,
    required String? userName,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/register_master_DxTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterSlaveDxTradePost({
    required int? userId,
    required String? userName,
    required String? password,
    required String? server,
    String? comment,
    required int? masterId,
  }) {
    final Uri $url = Uri.parse('/api/v1/register_slave_dxTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'password': password,
      'server': server,
      'comment': comment,
      'masterId': masterId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateMasterDxtradePost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_Master_dxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateSlaveDxtradePost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_slave_dxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendPositionDxTradePost({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_position_dxTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'orderType': orderType,
      'lots': lots,
      'symbol': symbol,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<DxTradePositionDtoListResponseDto>>
      _apiV1GetOpenPositionDxTradePost({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_Open_Position_dxTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'userId': userId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<DxTradePositionDtoListResponseDto,
        DxTradePositionDtoListResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ModifyPositionDxtradePost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required String? side,
    required num? lots,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_position_dxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'ticket': ticket,
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'Side': side,
      'lots': lots,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ClosePositionDxtradePost({
    required num? lots,
    required String? symbol,
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_position_dxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'lots': lots,
      'symbol': symbol,
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1PartialCloseOrderDxtradePost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/partialCloseOrderDxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'lots': lots,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrdersForDxtradePost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrdersForDxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<CancelDto>> _apiV1CloseAllOrderBySymbolForDxtradePost({
    required int? userid,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySymbolForDxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<CancelDto, CancelDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1CloseAllOrderBySellForDxtradePost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySellForDxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1CloseAllOrderByBuyForDxtradePost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderByBuyForDxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendPendingOrderDxTradePost({
    required int? userId,
    required String? side,
    required String? type,
    required num? lots,
    required String? symbol,
    required num? price,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_pending_order_dxTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'Side': side,
      'Type': type,
      'lots': lots,
      'symbol': symbol,
      'price': price,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<DxTradePositionDtoListResponseDto>>
      _apiV1GetPendingOrdersDxTradePost({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_pending_orders_dxTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'userId': userId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<DxTradePositionDtoListResponseDto,
        DxTradePositionDtoListResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ModifyPendingOrderDxtradePost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required num? price,
    required num? lots,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_pendingOrder_dxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'ticket': ticket,
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'price': price,
      'lots': lots,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ClosePendingOrderDxtradePost({
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_pending_order_dxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetOrderHistoryDxtradePost({
    required String? accountStatus,
    required int? userId,
    required DateTime? from,
    required DateTime? to,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_order_history_dxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'userId': userId,
      'from': from,
      'to': to,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveMasterDxtradePost({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_master_dxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveSlaveDxtradePost({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_slave_dxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1SymbolMapDxtradePost({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    final Uri $url = Uri.parse('/api/v1/symbol_map_dxtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'sourceSymbol': sourceSymbol,
      'followSymbol': followSymbol,
      'type': type,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSuffixDxTradeUserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSuffixDxTrade/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSpecialDxTradeUserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSpecialDxTrade/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Risk>> _apiV1DxTradeGetRiskGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/DxTrade/getRisk');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Risk, Risk>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1DxTradeUpdateRiskPost({
    required int? userId,
    required String? riskType,
    required num? multiplier,
  }) {
    final Uri $url = Uri.parse('/api/v1/DxTrade/updateRisk');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'riskType': riskType,
      'multiplier': multiplier,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StopsLimits>> _apiV1DxTradeGetStopsLimitsGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/DxTrade/getStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StopsLimits, StopsLimits>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1DxTradeUpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required String? scalperMode,
    required String? orderFilter,
    required int? scalperValue,
  }) {
    final Uri $url = Uri.parse('/api/v1/DxTrade/updateStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'copySLTP': copySLTP,
      'scalperMode': scalperMode,
      'orderFilter': orderFilter,
      'scalperValue': scalperValue,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<FollowRiskSetting>> _apiV1DxTradeGetOrderControlSettingsGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/DxTrade/getOrderControlSettings');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<FollowRiskSetting, FollowRiskSetting>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1DxTradeUpdateOrderControlSettingPost({
    required int? userId,
    required int? profitOverPoint,
    required int? lossOverPoint,
    required int? profitForEveryOrder,
    required int? lossForEveryOrder,
    required int? profitForAllOrder,
    required int? lossForAllOrder,
    required int? equityUnderLow,
    required int? equityUnderHigh,
    required int? pendingOrderProfitPoint,
    required int? pendingOrderLossPoint,
    required int? pendingTimeout,
  }) {
    final Uri $url = Uri.parse('/api/v1/DxTrade/updateOrderControlSetting');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'profitOverPoint': profitOverPoint,
      'lossOverPoint': lossOverPoint,
      'profitForEveryOrder': profitForEveryOrder,
      'lossForEveryOrder': lossForEveryOrder,
      'profitForAllOrder': profitForAllOrder,
      'lossForAllOrder': lossForAllOrder,
      'equityUnderLow': equityUnderLow,
      'equityUnderHigh': equityUnderHigh,
      'pendingOrderProfitPoint': pendingOrderProfitPoint,
      'pendingOrderLossPoint': pendingOrderLossPoint,
      'pendingTimeout': pendingTimeout,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterMasterTradeLockerPost({
    required int? userId,
    required String? emailId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/register_master_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'emailId': emailId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterSlaveTradeLockerPost({
    required int? userId,
    required String? emailId,
    required String? password,
    required String? server,
    String? comment,
    required int? masterAcountId,
  }) {
    final Uri $url = Uri.parse('/api/v1/register_slave_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'emailId': emailId,
      'password': password,
      'server': server,
      'comment': comment,
      'masterAcountId': masterAcountId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateMasterTradeLockerPost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_master_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateSlaveTradeLockerPost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_slave_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendPositionTradeLockerPost({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_position_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'orderType': orderType,
      'lots': lots,
      'symbol': symbol,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<MT4OrderDtoListResponseDto>> _apiV1GetOrdersTradeLockerPost({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_orders_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'userId': userId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<MT4OrderDtoListResponseDto, MT4OrderDtoListResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetOrderHistoryTradeLockerPost({
    required String? accountStatus,
    required int? id,
    required DateTime? from,
    required DateTime? to,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_order_history_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'id': id,
      'from': from,
      'to': to,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ModifyPositionTradeLockerPost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_position_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'ticket': ticket,
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ClosePositionTradeLockerPost({
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_position_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1PartialCloseTradeLockerPostionPost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/partial_Close_tradeLocker_postion');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'lots': lots,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrdersForTradeLockerPost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrdersForTradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<CancelDto>> _apiV1CloseAllOrderBySymbolForTradeLockerPost({
    required int? userid,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySymbolForTradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<CancelDto, CancelDto>($request);
  }

  @override
  Future<Response<StringResponseDto>>
      _apiV1CloseAllOrderBySellForTradeLockerPost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySellForTradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>>
      _apiV1CloseAllOrderByBuyForTradeLockerPost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderByBuyForTradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendPendingOrderTradeLockerPost({
    required int? userId,
    required String? side,
    required String? type,
    required num? lots,
    required String? symbol,
    required num? price,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_pending_order_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'Side': side,
      'Type': type,
      'lots': lots,
      'symbol': symbol,
      'price': price,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ModifyPendingOrderTradeLockerPost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required num? price,
    required num? lots,
    required String? type,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_pendingOrder_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'ticket': ticket,
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'price': price,
      'lots': lots,
      'Type': type,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ClosePendingOrderTradeLockerPost({
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_pending_order_tradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveMasterTradeLockerPost({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_master_TradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveSlaveTradeLockerPost({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_slave_TradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1SymbolMapTradeLockerPost({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    final Uri $url = Uri.parse('/api/v1/symbol_map_TradeLocker');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'sourceSymbol': sourceSymbol,
      'followSymbol': followSymbol,
      'type': type,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSuffixTradeLockerUserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSuffixTradeLocker/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSpecialTradeLockerUserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSpecialTradeLocker/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Risk>> _apiV1TradeLockerGetRiskGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/TradeLocker/getRisk');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Risk, Risk>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1TradeLockerUpdateRiskPost({
    required int? userId,
    required String? riskType,
    required num? multiplier,
  }) {
    final Uri $url = Uri.parse('/api/v1/TradeLocker/updateRisk');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'riskType': riskType,
      'multiplier': multiplier,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StopsLimits>> _apiV1TradeLockerGetStopsLimitsGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/TradeLocker/getStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StopsLimits, StopsLimits>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1TradeLockerUpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required String? scalperMode,
    required String? orderFilter,
    required int? scalperValue,
  }) {
    final Uri $url = Uri.parse('/api/v1/TradeLocker/updateStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'copySLTP': copySLTP,
      'scalperMode': scalperMode,
      'orderFilter': orderFilter,
      'scalperValue': scalperValue,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<FollowRiskSetting>>
      _apiV1TradeLockerGetOrderControlSettingsGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/TradeLocker/getOrderControlSettings');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<FollowRiskSetting, FollowRiskSetting>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1TradeLockerUpdateOrderControlSettingPost({
    required int? userId,
    required int? profitOverPoint,
    required int? lossOverPoint,
    required int? profitForEveryOrder,
    required int? lossForEveryOrder,
    required int? profitForAllOrder,
    required int? lossForAllOrder,
    required int? equityUnderLow,
    required int? equityUnderHigh,
    required int? pendingOrderProfitPoint,
    required int? pendingOrderLossPoint,
    required int? pendingTimeout,
  }) {
    final Uri $url = Uri.parse('/api/v1/TradeLocker/updateOrderControlSetting');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'profitOverPoint': profitOverPoint,
      'lossOverPoint': lossOverPoint,
      'profitForEveryOrder': profitForEveryOrder,
      'lossForEveryOrder': lossForEveryOrder,
      'profitForAllOrder': profitForAllOrder,
      'lossForAllOrder': lossForAllOrder,
      'equityUnderLow': equityUnderLow,
      'equityUnderHigh': equityUnderHigh,
      'pendingOrderProfitPoint': pendingOrderProfitPoint,
      'pendingOrderLossPoint': pendingOrderLossPoint,
      'pendingTimeout': pendingTimeout,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetAllSymbolTradeLockerUserIdGet({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/getAllSymbol/TradeLocker/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterMasterMatchTradePost({
    required int? userId,
    required String? emailId,
    required String? password,
    required String? server,
    String? brokerId,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/register_master_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'emailId': emailId,
      'password': password,
      'server': server,
      'brokerId': brokerId,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1RegisterSlaveMatchTradePost({
    required int? userId,
    required String? emailId,
    required String? password,
    required String? server,
    String? brokerId,
    String? comment,
    required int? masterAcountId,
  }) {
    final Uri $url = Uri.parse('/api/v1/register_slave_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'emailId': emailId,
      'password': password,
      'server': server,
      'brokerId': brokerId,
      'comment': comment,
      'masterAcountId': masterAcountId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateMasterMatchTradePost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_master_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1UpdateSlaveMatchTradePost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    final Uri $url = Uri.parse('/api/v1/update_slave_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'password': password,
      'server': server,
      'comment': comment,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendPositionMatchTradePost({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_position_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'orderType': orderType,
      'lots': lots,
      'symbol': symbol,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<MT4OrderDtoListResponseDto>> _apiV1GetOrdersMatchTradePost({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/get_orders_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus,
      'userId': userId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<MT4OrderDtoListResponseDto, MT4OrderDtoListResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ModifyPositionMatchTradePost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required String? side,
    required num? lots,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_position_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'ticket': ticket,
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'Side': side,
      'lots': lots,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ClosePositionMatchTradePost({
    required int? userId,
    required int? ticket,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_position_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1PartialCloseMatchTradePostionPost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required String? symbol,
    required String? side,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/partial_Close_MatchTrade_Postion');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'lots': lots,
      'symbol': symbol,
      'Side': side,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1CloseAllOrdersForMatchtradePost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrdersForMatchtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<CancelDto>> _apiV1CloseAllOrderBySymbolForMatchtradePost({
    required int? userid,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySymbolForMatchtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<CancelDto, CancelDto>($request);
  }

  @override
  Future<Response<StringResponseDto>>
      _apiV1CloseAllOrderBySellForMatchTradePost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderBySellForMatchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>>
      _apiV1CloseAllOrderByBuyForMatchTradePost({
    required int? userid,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/CloseAllOrderByBuyForMatchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1SendPendingOrderMatchTradePost({
    required int? userId,
    required String? side,
    required String? type,
    required num? lots,
    required String? symbol,
    required num? price,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/send_pending_order_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'Side': side,
      'Type': type,
      'lots': lots,
      'symbol': symbol,
      'price': price,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ModifyPendingOrderMatchTradePost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required num? price,
    required num? lots,
    required String? side,
    required String? type,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/modify_pendingOrder_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'ticket': ticket,
      'userId': userId,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'price': price,
      'lots': lots,
      'Side': side,
      'Type': type,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ClosePendingOrderMatchTradePost({
    required int? userId,
    required int? ticket,
    required String? side,
    required String? type,
    required String? symbol,
    required String? accountStatus,
  }) {
    final Uri $url = Uri.parse('/api/v1/close_pending_order_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'ticket': ticket,
      'Side': side,
      'Type': type,
      'symbol': symbol,
      'accountStatus': accountStatus,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveMasterMatchTradePost({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_master_matchTrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1ActiveSlaveMatchtradePost({
    required int? id,
    required bool? status,
  }) {
    final Uri $url = Uri.parse('/api/v1/active_slave_matchtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'id': id,
      'status': status,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1SymbolMapMatchtradePost({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    final Uri $url = Uri.parse('/api/v1/symbol_map_matchtrade');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userid': userid,
      'sourceSymbol': sourceSymbol,
      'followSymbol': followSymbol,
      'type': type,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSuffixMatchTradeUserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSuffixMatchTrade/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetSpecialMatchTradeUserIdGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getSpecialMatchTrade/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Risk>> _apiV1MatchTradeGetRiskGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/MatchTrade/getRisk');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Risk, Risk>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1MatchTradeUpdateRiskPost({
    required int? userId,
    required String? riskType,
    required num? multiplier,
  }) {
    final Uri $url = Uri.parse('/api/v1/MatchTrade/updateRisk');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'riskType': riskType,
      'multiplier': multiplier,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StopsLimits>> _apiV1MatchTradeGetStopsLimitsGet(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/MatchTrade/getStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StopsLimits, StopsLimits>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1MatchTradeUpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required String? scalperMode,
    required String? orderFilter,
    required int? scalperValue,
  }) {
    final Uri $url = Uri.parse('/api/v1/MatchTrade/updateStopsLimits');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'copySLTP': copySLTP,
      'scalperMode': scalperMode,
      'orderFilter': orderFilter,
      'scalperValue': scalperValue,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<FollowRiskSetting>>
      _apiV1MatchTradeGetOrderControlSettingsGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/MatchTrade/getOrderControlSettings');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<FollowRiskSetting, FollowRiskSetting>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1MatchTradeUpdateOrderControlSettingPost({
    required int? userId,
    required int? profitOverPoint,
    required int? lossOverPoint,
    required int? profitForEveryOrder,
    required int? lossForEveryOrder,
    required int? profitForAllOrder,
    required int? lossForAllOrder,
    required int? equityUnderLow,
    required int? equityUnderHigh,
    required int? pendingOrderProfitPoint,
    required int? pendingOrderLossPoint,
    required int? pendingTimeout,
  }) {
    final Uri $url = Uri.parse('/api/v1/MatchTrade/updateOrderControlSetting');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'profitOverPoint': profitOverPoint,
      'lossOverPoint': lossOverPoint,
      'profitForEveryOrder': profitForEveryOrder,
      'lossForEveryOrder': lossForEveryOrder,
      'profitForAllOrder': profitForAllOrder,
      'lossForAllOrder': lossForAllOrder,
      'equityUnderLow': equityUnderLow,
      'equityUnderHigh': equityUnderHigh,
      'pendingOrderProfitPoint': pendingOrderProfitPoint,
      'pendingOrderLossPoint': pendingOrderLossPoint,
      'pendingTimeout': pendingTimeout,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetAllSymbolMatchTradeUserIdGet({
    required String? accountStatus,
    required int? userId,
  }) {
    final Uri $url = Uri.parse('/api/v1/getAllSymbol/MatchTrade/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'accountStatus': accountStatus
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetUserInfoGet(
      {required int? userid}) {
    final Uri $url = Uri.parse('/api/v1/getUserInfo');
    final Map<String, dynamic> $params = <String, dynamic>{'userid': userid};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1GetIdGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/get_id');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<StringResponseDto>> _apiV1GetAPIInfoGet(
      {required String? key}) {
    final Uri $url = Uri.parse('/api/v1/getAPIInfo');
    final Map<String, dynamic> $params = <String, dynamic>{'key': key};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<StringResponseDto, StringResponseDto>($request);
  }

  @override
  Future<Response<List<int>>> _apiV1GetbyidGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getbyid');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<List<int>>> _apiV1GetStatusGet({required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/getStatus');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<int>, int>($request);
  }

  @override
  Future<Response<BooleanResponseDto>> _apiV1FollowUserIdDelete(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/follow/${userId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<BooleanResponseDto, BooleanResponseDto>($request);
  }

  @override
  Future<Response<BooleanResponseDto>> _apiV1SourceUserIdDelete(
      {required int? userId}) {
    final Uri $url = Uri.parse('/api/v1/source/${userId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<BooleanResponseDto, BooleanResponseDto>($request);
  }

  @override
  Future<Response<List<UserStatusDto>>> _apiV1GetStatusbyIDGet(
      {required List<int>? userId}) {
    final Uri $url = Uri.parse('/api/v1/getStatusbyID');
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<UserStatusDto>, UserStatusDto>($request);
  }
}
