// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'api.models.swagger.dart';
import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'api.enums.swagger.dart' as enums;
export 'api.enums.swagger.dart';
export 'api.models.swagger.dart';

part 'api.swagger.chopper.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Api extends ChopperService {
  static Api create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    Iterable<dynamic>? interceptors,
  }) {
    if (client != null) {
      return _$Api(client);
    }

    final newClient = ChopperClient(
        services: [_$Api()],
        converter: converter ?? $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        client: httpClient,
        authenticator: authenticator,
        errorConverter: errorConverter,
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$Api(newClient);
  }

  ///Register Master Account for MT4
  ///@param userId The userId of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MT4 account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1RegisterMasterMt4Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterMasterMt4Post(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Register Master Account for MT4
  ///@param userId The userId of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MT4 account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/register_master_mt4',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1RegisterMasterMt4Post({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Register Slave Account for MT4
  ///@param userId The userId of the slave account.<br /><br/>
  ///@param password The password for the slave account.<br /><br/>
  ///@param server The server name for the MT4 account.<br /><br/>
  ///@param masterId The master userId associated with the slave account.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  ///@param copyOrderType The type of order copy:<br/>- `0`: Copy All Existing Orders<br/>- `1`: Copy  All New Orders
  Future<chopper.Response<StringResponseDto>> apiV1RegisterSlaveMt4Post({
    required int? userId,
    required String? password,
    required String? server,
    required int? masterId,
    String? comment,
    required int? copyOrderType,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterSlaveMt4Post(
        userId: userId,
        password: password,
        server: server,
        masterId: masterId,
        comment: comment,
        copyOrderType: copyOrderType);
  }

  ///Register Slave Account for MT4
  ///@param userId The userId of the slave account.<br /><br/>
  ///@param password The password for the slave account.<br /><br/>
  ///@param server The server name for the MT4 account.<br /><br/>
  ///@param masterId The master userId associated with the slave account.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  ///@param copyOrderType The type of order copy:<br/>- `0`: Copy All Existing Orders<br/>- `1`: Copy  All New Orders
  @Post(
    path: '/api/v1/register_slave_mt4',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1RegisterSlaveMt4Post({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('masterId') required int? masterId,
    @Query('comment') String? comment,
    @Query('copyOrderType') required int? copyOrderType,
  });

  ///Update Master Account for MT4
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MT4 account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1UpdateMasterMt4Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateMasterMt4Post(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Update Master Account for MT4
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MT4 account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/update_Master_mt4',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateMasterMt4Post({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Update Slave Account for MT4
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MT4 account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1UpdateSlaveMt4Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateSlaveMt4Post(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Update Slave Account for MT4
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MT4 account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/update_slave_mt4',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateSlaveMt4Post({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Send Order for MT4
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1SendOrderMt4Post({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendOrderMt4Post(
        userId: userId,
        orderType: orderType,
        lots: lots,
        symbol: symbol,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus);
  }

  ///Send Order for MT4
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  @Post(
    path: '/api/v1/send_order_mt4',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1SendOrderMt4Post({
    @Query('userId') required int? userId,
    @Query('orderType') required String? orderType,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Get Orders for MT4
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The ID of the user for which to retrieve orders.<br /><br/>
  Future<chopper.Response<MT4OrderDtoListResponseDto>> apiV1GetOrdersMt4Post({
    required enums.ApiV1GetOrdersMt4PostAccountStatus? accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(MT4OrderDtoListResponseDto,
        () => MT4OrderDtoListResponseDto.fromJsonFactory);

    return _apiV1GetOrdersMt4Post(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Get Orders for MT4
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The ID of the user for which to retrieve orders.<br /><br/>
  @Post(
    path: '/api/v1/get_orders_mt4',
    optionalBody: true,
  )
  Future<chopper.Response<MT4OrderDtoListResponseDto>> _apiV1GetOrdersMt4Post({
    @Query('accountStatus') required String? accountStatus,
    @Query('userId') required int? userId,
  });

  ///Modify Order for MT4
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response<StringResponseDto>> apiV1ModifyOrderMt4Post({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required enums.ApiV1ModifyOrderMt4PostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ModifyOrderMt4Post(
        ticket: ticket,
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify Order for MT4
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/modify_order_mt4',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ModifyOrderMt4Post({
    @Query('ticket') required int? ticket,
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Order for MT4
  ///@param userId The ID of the user closing the order. Default value is 123456.<br /><br/>
  ///@param ticket The ticket ID of the order to close. Default value is 1234.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response> apiV1CloseOrderMt4Post({
    required int? userId,
    required int? ticket,
    required enums.ApiV1CloseOrderMt4PostAccountStatus? accountStatus,
  }) {
    return _apiV1CloseOrderMt4Post(
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Order for MT4
  ///@param userId The ID of the user closing the order. Default value is 123456.<br /><br/>
  ///@param ticket The ticket ID of the order to close. Default value is 1234.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/close_order_mt4',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseOrderMt4Post({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Partially Close an Order for MT4
  ///@param userId The ID of the user closing the order.
  ///@param ticket The ticket ID of the order to partially close. Default value is 1234.
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response> apiV1Mt4PartialCloseOrderPost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required enums.ApiV1Mt4PartialCloseOrderPostAccountStatus? accountStatus,
  }) {
    return _apiV1Mt4PartialCloseOrderPost(
        userId: userId,
        ticket: ticket,
        lots: lots,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Partially Close an Order for MT4
  ///@param userId The ID of the user closing the order.
  ///@param ticket The ticket ID of the order to partially close. Default value is 1234.
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/mt4/partialCloseOrder',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1Mt4PartialCloseOrderPost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('lots') required num? lots,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Send Pending Order for MT4
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BuyLimit, SellLimit, BuyStop, SellStop,  BuyStopLimit, SellStopLimit).<br /><br/>
  ///@param lots The lot size for the order.<br /><br/>
  ///@param price The price at which the order is to be placed.<br /><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss Stop loss for the order (optional). Default value is 0.<br /><br/>
  ///@param takeProfit Take profit for the order (optional). Default value is 0.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1SendPendingOrderMt4Post({
    required int? userId,
    required String? orderType,
    required num? lots,
    required num? price,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required enums.ApiV1SendPendingOrderMt4PostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendPendingOrderMt4Post(
        userId: userId,
        orderType: orderType,
        lots: lots,
        price: price,
        symbol: symbol,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Send Pending Order for MT4
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BuyLimit, SellLimit, BuyStop, SellStop,  BuyStopLimit, SellStopLimit).<br /><br/>
  ///@param lots The lot size for the order.<br /><br/>
  ///@param price The price at which the order is to be placed.<br /><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss Stop loss for the order (optional). Default value is 0.<br /><br/>
  ///@param takeProfit Take profit for the order (optional). Default value is 0.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/send_pending_order_mt4',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1SendPendingOrderMt4Post({
    @Query('userId') required int? userId,
    @Query('orderType') required String? orderType,
    @Query('lots') required num? lots,
    @Query('price') required num? price,
    @Query('symbol') required String? symbol,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Modify Pending Order for MT4
  ///@param userId The ID of the user requesting the modification.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response> apiV1ModifyPendingOrderMt4Post({
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required int? ticket,
    required enums.ApiV1ModifyPendingOrderMt4PostAccountStatus? accountStatus,
  }) {
    return _apiV1ModifyPendingOrderMt4Post(
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify Pending Order for MT4
  ///@param userId The ID of the user requesting the modification.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/modify_pending_order_mt4',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1ModifyPendingOrderMt4Post({
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Pending Order for MT4
  ///@param userId The ID of the user requesting to close the order.<br /><br/>
  ///@param ticket The ticket ID of the order to close.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response> apiV1ClosePendingOrderMt4Post({
    required int? userId,
    required int? ticket,
    required enums.ApiV1ClosePendingOrderMt4PostAccountStatus? accountStatus,
  }) {
    return _apiV1ClosePendingOrderMt4Post(
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Pending Order for MT4
  ///@param userId The ID of the user requesting to close the order.<br /><br/>
  ///@param ticket The ticket ID of the order to close.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/close_pending_order_mt4',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1ClosePendingOrderMt4Post({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders for MT4
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrdersForMT4Post({
    required int? userid,
    required enums.ApiV1CloseAllOrdersForMT4PostAccountStatus? accountStatus,
  }) {
    return _apiV1CloseAllOrdersForMT4Post(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders for MT4
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrdersForMT4',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrdersForMT4Post({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders by Symbol for MT4
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<CancelDto>> apiV1CloseAllOrderBySymbolForMT4Post({
    required int? userid,
    required String? symbol,
    required enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(CancelDto, () => CancelDto.fromJsonFactory);

    return _apiV1CloseAllOrderBySymbolForMT4Post(
        userid: userid,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders by Symbol for MT4
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySymbolForMT4',
    optionalBody: true,
  )
  Future<chopper.Response<CancelDto>> _apiV1CloseAllOrderBySymbolForMT4Post({
    @Query('userid') required int? userid,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Sell Orders for MT4
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrderBySellMT4Post({
    required int? userid,
    required enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus? accountStatus,
  }) {
    return _apiV1CloseAllOrderBySellMT4Post(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Sell Orders for MT4
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySell/MT4',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrderBySellMT4Post({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Buy Orders for MT4
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrderByBuyMT4Post({
    required int? userid,
    required enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus? accountStatus,
  }) {
    return _apiV1CloseAllOrderByBuyMT4Post(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Buy Orders for MT4
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderByBuy/MT4',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrderByBuyMT4Post({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Get Order History for MT4
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param id The ID of the account for which to retrieve order history.<br /><br/>
  ///@param from The start date for the order history.<br /><br/>
  ///@param to The end date for the order history.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1GetOrderHistoryMt4Post({
    required enums.ApiV1GetOrderHistoryMt4PostAccountStatus? accountStatus,
    required int? id,
    required DateTime? from,
    required DateTime? to,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetOrderHistoryMt4Post(
        accountStatus: accountStatus?.value?.toString(),
        id: id,
        from: from,
        to: to);
  }

  ///Get Order History for MT4
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param id The ID of the account for which to retrieve order history.<br /><br/>
  ///@param from The start date for the order history.<br /><br/>
  ///@param to The end date for the order history.<br /><br/>
  @Post(
    path: '/api/v1/get_order_history_mt4',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1GetOrderHistoryMt4Post({
    @Query('accountStatus') required String? accountStatus,
    @Query('id') required int? id,
    @Query('from') required DateTime? from,
    @Query('to') required DateTime? to,
  });

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveMasterMT4Post({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveMasterMT4Post(id: id, status: status);
  }

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_master/MT4',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveMasterMT4Post({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveSlaveMT4Post({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveSlaveMT4Post(id: id, status: status);
  }

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_slave/MT4',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveSlaveMT4Post({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  Future<chopper.Response> apiV1SymbolMapMt4Post({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    return _apiV1SymbolMapMt4Post(
        userid: userid,
        sourceSymbol: sourceSymbol,
        followSymbol: followSymbol,
        type: type);
  }

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  @Post(
    path: '/api/v1/symbol_map/mt4',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1SymbolMapMt4Post({
    @Query('userid') required int? userid,
    @Query('sourceSymbol') required String? sourceSymbol,
    @Query('followSymbol') required String? followSymbol,
    @Query('type') required String? type,
  });

  ///Get Suffix Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSuffixMt4UserIdGet({required int? userId}) {
    return _apiV1GetSuffixMt4UserIdGet(userId: userId);
  }

  ///Get Suffix Symbols
  ///@param userId
  @Get(path: '/api/v1/getSuffix/mt4/{userId}')
  Future<chopper.Response> _apiV1GetSuffixMt4UserIdGet(
      {@Path('userId') required int? userId});

  ///Get Special Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSpecialMt4UserIdGet({required int? userId}) {
    return _apiV1GetSpecialMt4UserIdGet(userId: userId);
  }

  ///Get Special Symbols
  ///@param userId
  @Get(path: '/api/v1/getSpecial/mt4/{userId}')
  Future<chopper.Response> _apiV1GetSpecialMt4UserIdGet(
      {@Path('userId') required int? userId});

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  Future<chopper.Response<Risk>> apiV1Mt4GetRiskGet({required int? userId}) {
    generatedMapping.putIfAbsent(Risk, () => Risk.fromJsonFactory);

    return _apiV1Mt4GetRiskGet(userId: userId);
  }

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  @Get(path: '/api/v1/mt4/getRisk')
  Future<chopper.Response<Risk>> _apiV1Mt4GetRiskGet(
      {@Query('userId') required int? userId});

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  Future<chopper.Response> apiV1Mt4UpdateRiskPost({
    required int? userId,
    required enums.ApiV1Mt4UpdateRiskPostRiskType? riskType,
    required num? multiplier,
  }) {
    return _apiV1Mt4UpdateRiskPost(
        userId: userId,
        riskType: riskType?.value?.toString(),
        multiplier: multiplier);
  }

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  @Post(
    path: '/api/v1/mt4/updateRisk',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1Mt4UpdateRiskPost({
    @Query('userId') required int? userId,
    @Query('riskType') required String? riskType,
    @Query('multiplier') required num? multiplier,
  });

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  Future<chopper.Response<StopsLimits>> apiV1Mt4GetStopsLimitsGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(
        StopsLimits, () => StopsLimits.fromJsonFactory);

    return _apiV1Mt4GetStopsLimitsGet(userId: userId);
  }

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  @Get(path: '/api/v1/mt4/getStopsLimits')
  Future<chopper.Response<StopsLimits>> _apiV1Mt4GetStopsLimitsGet(
      {@Query('userId') required int? userId});

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  Future<chopper.Response> apiV1Mt4UpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode? scalperMode,
    required enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter? orderFilter,
    required int? scalperValue,
  }) {
    return _apiV1Mt4UpdateStopsLimitsPost(
        userId: userId,
        copySLTP: copySLTP,
        scalperMode: scalperMode?.value?.toString(),
        orderFilter: orderFilter?.value?.toString(),
        scalperValue: scalperValue);
  }

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  @Post(
    path: '/api/v1/mt4/updateStopsLimits',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1Mt4UpdateStopsLimitsPost({
    @Query('userId') required int? userId,
    @Query('copySLTP') required bool? copySLTP,
    @Query('scalperMode') required String? scalperMode,
    @Query('orderFilter') required String? orderFilter,
    @Query('scalperValue') required int? scalperValue,
  });

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for. <br/><br/>
  Future<chopper.Response<FollowRiskSetting>>
      apiV1Mt4GetOrderControlSettingsGet({required int? userId}) {
    generatedMapping.putIfAbsent(
        FollowRiskSetting, () => FollowRiskSetting.fromJsonFactory);

    return _apiV1Mt4GetOrderControlSettingsGet(userId: userId);
  }

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for. <br/><br/>
  @Get(path: '/api/v1/mt4/getOrderControlSettings')
  Future<chopper.Response<FollowRiskSetting>>
      _apiV1Mt4GetOrderControlSettingsGet(
          {@Query('userId') required int? userId});

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  Future<chopper.Response> apiV1Mt4UpdateOrderControlSettingPost({
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
    return _apiV1Mt4UpdateOrderControlSettingPost(
        userId: userId,
        profitOverPoint: profitOverPoint,
        lossOverPoint: lossOverPoint,
        profitForEveryOrder: profitForEveryOrder,
        lossForEveryOrder: lossForEveryOrder,
        profitForAllOrder: profitForAllOrder,
        lossForAllOrder: lossForAllOrder,
        equityUnderLow: equityUnderLow,
        equityUnderHigh: equityUnderHigh,
        pendingOrderProfitPoint: pendingOrderProfitPoint,
        pendingOrderLossPoint: pendingOrderLossPoint,
        pendingTimeout: pendingTimeout);
  }

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  @Post(
    path: '/api/v1/mt4/updateOrderControlSetting',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1Mt4UpdateOrderControlSettingPost({
    @Query('userId') required int? userId,
    @Query('profitOverPoint') required int? profitOverPoint,
    @Query('lossOverPoint') required int? lossOverPoint,
    @Query('profitForEveryOrder') required int? profitForEveryOrder,
    @Query('lossForEveryOrder') required int? lossForEveryOrder,
    @Query('profitForAllOrder') required int? profitForAllOrder,
    @Query('lossForAllOrder') required int? lossForAllOrder,
    @Query('equityUnderLow') required int? equityUnderLow,
    @Query('equityUnderHigh') required int? equityUnderHigh,
    @Query('pendingOrderProfitPoint') required int? pendingOrderProfitPoint,
    @Query('pendingOrderLossPoint') required int? pendingOrderLossPoint,
    @Query('pendingTimeout') required int? pendingTimeout,
  });

  ///Register Master Account for MT5 with userId, password, and server
  ///@param userId The userId of the master account.<br /><br/>
  ///@param password The password for the master account.<br /><br/>
  ///@param server The server name for the MT5 account.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1RegisterMasterForMT5Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterMasterForMT5Post(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Register Master Account for MT5 with userId, password, and server
  ///@param userId The userId of the master account.<br /><br/>
  ///@param password The password for the master account.<br /><br/>
  ///@param server The server name for the MT5 account.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  @Post(
    path: '/api/v1/RegisterMasterForMT5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1RegisterMasterForMT5Post({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Register Slave Account for MT5 with userId, password, server and masterId
  ///@param userId The userId ID of the slave account.
  ///@param password The password for the slave account.
  ///@param server The server name for the MT5 account.
  ///@param masterId The master userId associated with the slave account.
  ///@param comment Optional comment for the registration.
  ///@param copyOrderType The type of order copy:<br/>- `0`: Copy All Existing Orders<br/>- `1`: Copy  All New Orders
  Future<chopper.Response<StringResponseDto>> apiV1RegisterSlaveForMT5Post({
    required int? userId,
    required String? password,
    required String? server,
    required int? masterId,
    String? comment,
    required int? copyOrderType,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterSlaveForMT5Post(
        userId: userId,
        password: password,
        server: server,
        masterId: masterId,
        comment: comment,
        copyOrderType: copyOrderType);
  }

  ///Register Slave Account for MT5 with userId, password, server and masterId
  ///@param userId The userId ID of the slave account.
  ///@param password The password for the slave account.
  ///@param server The server name for the MT5 account.
  ///@param masterId The master userId associated with the slave account.
  ///@param comment Optional comment for the registration.
  ///@param copyOrderType The type of order copy:<br/>- `0`: Copy All Existing Orders<br/>- `1`: Copy  All New Orders
  @Post(
    path: '/api/v1/RegisterSlaveForMT5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1RegisterSlaveForMT5Post({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('masterId') required int? masterId,
    @Query('comment') String? comment,
    @Query('copyOrderType') required int? copyOrderType,
  });

  ///Update Master Account for MT5
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MT5 account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1UpdateMasterMt5Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateMasterMt5Post(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Update Master Account for MT5
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MT5 account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/update_Master_mt5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateMasterMt5Post({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Update Slave Account for MT5
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MT5 account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1UpdateSlaveMt5Post({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateSlaveMt5Post(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Update Slave Account for MT5
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MT5 account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/update_slave_mt5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateSlaveMt5Post({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Send Order for MT5
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1SendOrderMt5Post({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required enums.ApiV1SendOrderMt5PostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendOrderMt5Post(
        userId: userId,
        orderType: orderType,
        lots: lots,
        symbol: symbol,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Send Order for MT5
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/send_order_mt5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1SendOrderMt5Post({
    @Query('userId') required int? userId,
    @Query('orderType') required String? orderType,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Get Order for MT5
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The ID of the user for which to retrieve orders.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1GetOrdersMt5Post({
    required enums.ApiV1GetOrdersMt5PostAccountStatus? accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetOrdersMt5Post(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Get Order for MT5
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The ID of the user for which to retrieve orders.<br /><br/>
  @Post(
    path: '/api/v1/get_orders_mt5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1GetOrdersMt5Post({
    @Query('accountStatus') required String? accountStatus,
    @Query('userId') required int? userId,
  });

  ///Modify Order for MT5
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ModifyOrderMt5Post({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required enums.ApiV1ModifyOrderMt5PostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ModifyOrderMt5Post(
        ticket: ticket,
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify Order for MT5
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/modify_order_mt5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ModifyOrderMt5Post({
    @Query('ticket') required int? ticket,
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Order for MT5
  ///@param userId The ID of the user closing the order. Default value is 123456.<br /><br/>
  ///@param ticket The ticket ID of the order to close. Default value is 1234.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response> apiV1CloseOrderForMT5Post({
    required int? userId,
    required int? ticket,
    required enums.ApiV1CloseOrderForMT5PostAccountStatus? accountStatus,
  }) {
    return _apiV1CloseOrderForMT5Post(
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Order for MT5
  ///@param userId The ID of the user closing the order. Default value is 123456.<br /><br/>
  ///@param ticket The ticket ID of the order to close. Default value is 1234.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/closeOrderForMT5',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseOrderForMT5Post({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Partially Close an Order for MT5
  ///@param userId The ID of the user closing the order.
  ///@param ticket The ticket ID of the order to partially close. Default value is 1234.
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response> apiV1Mt5PartialCloseOrderPost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required enums.ApiV1Mt5PartialCloseOrderPostAccountStatus? accountStatus,
  }) {
    return _apiV1Mt5PartialCloseOrderPost(
        userId: userId,
        ticket: ticket,
        lots: lots,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Partially Close an Order for MT5
  ///@param userId The ID of the user closing the order.
  ///@param ticket The ticket ID of the order to partially close. Default value is 1234.
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/mt5/partialCloseOrder',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1Mt5PartialCloseOrderPost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('lots') required num? lots,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Send Pending Order for MT5
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BuyLimit, SellLimit, BuyStop, SellStop,  BuyStopLimit, SellStopLimit).<br /><br/>
  ///@param lots The lot size for the order.<br /><br/>
  ///@param price The price at which the order is to be placed.<br /><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1SendPendingOrderMt5Post({
    required int? userId,
    required String? orderType,
    required num? lots,
    required num? price,
    required String? symbol,
    required enums.ApiV1SendPendingOrderMt5PostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendPendingOrderMt5Post(
        userId: userId,
        orderType: orderType,
        lots: lots,
        price: price,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Send Pending Order for MT5
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BuyLimit, SellLimit, BuyStop, SellStop,  BuyStopLimit, SellStopLimit).<br /><br/>
  ///@param lots The lot size for the order.<br /><br/>
  ///@param price The price at which the order is to be placed.<br /><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/send_pending_order_mt5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1SendPendingOrderMt5Post({
    @Query('userId') required int? userId,
    @Query('orderType') required String? orderType,
    @Query('lots') required num? lots,
    @Query('price') required num? price,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Modify Pending Order for MT5
  ///@param userId The ID of the user requesting the modification.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response> apiV1ModifyPendingOrderForMT5Post({
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required int? ticket,
    required enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus?
        accountStatus,
  }) {
    return _apiV1ModifyPendingOrderForMT5Post(
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify Pending Order for MT5
  ///@param userId The ID of the user requesting the modification.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/modifyPendingOrderForMT5',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1ModifyPendingOrderForMT5Post({
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Pending Order for MT5
  ///@param userId The ID of the user requesting to close the order.<br /><br/>
  ///@param ticket The ticket ID of the order to close.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response> apiV1ClosePendingOrderMt5Post({
    required int? userId,
    required int? ticket,
    required enums.ApiV1ClosePendingOrderMt5PostAccountStatus? accountStatus,
  }) {
    return _apiV1ClosePendingOrderMt5Post(
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Pending Order for MT5
  ///@param userId The ID of the user requesting to close the order.<br /><br/>
  ///@param ticket The ticket ID of the order to close.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/close_pending_order_mt5',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1ClosePendingOrderMt5Post({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders for MT5
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrdersForMT5Post({
    required int? userid,
    required enums.ApiV1CloseAllOrdersForMT5PostAccountStatus? accountStatus,
  }) {
    return _apiV1CloseAllOrdersForMT5Post(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders for MT5
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrdersForMT5',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrdersForMT5Post({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders by Symbol for MT5
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<CancelDto>> apiV1CloseAllOrderBySymbolForMT5Post({
    required int? userid,
    required String? symbol,
    required enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(CancelDto, () => CancelDto.fromJsonFactory);

    return _apiV1CloseAllOrderBySymbolForMT5Post(
        userid: userid,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders by Symbol for MT5
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySymbolForMT5',
    optionalBody: true,
  )
  Future<chopper.Response<CancelDto>> _apiV1CloseAllOrderBySymbolForMT5Post({
    @Query('userid') required int? userid,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Sell Orders for MT5
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrderBySellMT5Post({
    required int? userid,
    required enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus? accountStatus,
  }) {
    return _apiV1CloseAllOrderBySellMT5Post(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Sell Orders for MT5
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySell/MT5',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrderBySellMT5Post({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Buy Orders for MT5
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrderByBuyMT5Post({
    required int? userid,
    required enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus? accountStatus,
  }) {
    return _apiV1CloseAllOrderByBuyMT5Post(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Buy Orders for MT5
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderByBuy/MT5',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrderByBuyMT5Post({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Get Order History for MT5
  ///@param AccountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param Id The ID of the account for which to retrieve order history.<br /><br/>
  ///@param From The start date for the order history (e.g. YYYY-MM-DD).<br /><br/>
  ///@param To The end date for the order history (e.g. YYYY-MM-DD).<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1GetOrderHistoryMt5Post({
    required enums.ApiV1GetOrderHistoryMt5PostAccountStatus? accountStatus,
    required int? id,
    required DateTime? from,
    required DateTime? to,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetOrderHistoryMt5Post(
        accountStatus: accountStatus?.value?.toString(),
        id: id,
        from: from,
        to: to);
  }

  ///Get Order History for MT5
  ///@param AccountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param Id The ID of the account for which to retrieve order history.<br /><br/>
  ///@param From The start date for the order history (e.g. YYYY-MM-DD).<br /><br/>
  ///@param To The end date for the order history (e.g. YYYY-MM-DD).<br /><br/>
  @Post(
    path: '/api/v1/get_order_history_mt5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1GetOrderHistoryMt5Post({
    @Query('AccountStatus') required String? accountStatus,
    @Query('Id') required int? id,
    @Query('From') required DateTime? from,
    @Query('To') required DateTime? to,
  });

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveMasterMT5Post({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveMasterMT5Post(id: id, status: status);
  }

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_master/MT5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveMasterMT5Post({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveSlaveMT5Post({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveSlaveMT5Post(id: id, status: status);
  }

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_slave/MT5',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveSlaveMT5Post({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  Future<chopper.Response> apiV1SymbolMapMt5Post({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    return _apiV1SymbolMapMt5Post(
        userid: userid,
        sourceSymbol: sourceSymbol,
        followSymbol: followSymbol,
        type: type);
  }

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  @Post(
    path: '/api/v1/symbol_map/mt5',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1SymbolMapMt5Post({
    @Query('userid') required int? userid,
    @Query('sourceSymbol') required String? sourceSymbol,
    @Query('followSymbol') required String? followSymbol,
    @Query('type') required String? type,
  });

  ///Get Suffix Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSuffixMt5UserIdGet({required int? userId}) {
    return _apiV1GetSuffixMt5UserIdGet(userId: userId);
  }

  ///Get Suffix Symbols
  ///@param userId
  @Get(path: '/api/v1/getSuffix/mt5/{userId}')
  Future<chopper.Response> _apiV1GetSuffixMt5UserIdGet(
      {@Path('userId') required int? userId});

  ///Get Special Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSpecialMt5UserIdGet({required int? userId}) {
    return _apiV1GetSpecialMt5UserIdGet(userId: userId);
  }

  ///Get Special Symbols
  ///@param userId
  @Get(path: '/api/v1/getSpecial/mt5/{userId}')
  Future<chopper.Response> _apiV1GetSpecialMt5UserIdGet(
      {@Path('userId') required int? userId});

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  Future<chopper.Response<Risk>> apiV1Mt5GetRiskGet({required int? userId}) {
    generatedMapping.putIfAbsent(Risk, () => Risk.fromJsonFactory);

    return _apiV1Mt5GetRiskGet(userId: userId);
  }

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  @Get(path: '/api/v1/mt5/getRisk')
  Future<chopper.Response<Risk>> _apiV1Mt5GetRiskGet(
      {@Query('userId') required int? userId});

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  Future<chopper.Response> apiV1Mt5UpdateRiskPost({
    required int? userId,
    required enums.ApiV1Mt5UpdateRiskPostRiskType? riskType,
    required num? multiplier,
  }) {
    return _apiV1Mt5UpdateRiskPost(
        userId: userId,
        riskType: riskType?.value?.toString(),
        multiplier: multiplier);
  }

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  @Post(
    path: '/api/v1/mt5/updateRisk',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1Mt5UpdateRiskPost({
    @Query('userId') required int? userId,
    @Query('riskType') required String? riskType,
    @Query('multiplier') required num? multiplier,
  });

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  Future<chopper.Response<StopsLimits>> apiV1Mt5GetStopsLimitsGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(
        StopsLimits, () => StopsLimits.fromJsonFactory);

    return _apiV1Mt5GetStopsLimitsGet(userId: userId);
  }

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  @Get(path: '/api/v1/mt5/getStopsLimits')
  Future<chopper.Response<StopsLimits>> _apiV1Mt5GetStopsLimitsGet(
      {@Query('userId') required int? userId});

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  Future<chopper.Response> apiV1Mt5UpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode? scalperMode,
    required enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter? orderFilter,
    required int? scalperValue,
  }) {
    return _apiV1Mt5UpdateStopsLimitsPost(
        userId: userId,
        copySLTP: copySLTP,
        scalperMode: scalperMode?.value?.toString(),
        orderFilter: orderFilter?.value?.toString(),
        scalperValue: scalperValue);
  }

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  @Post(
    path: '/api/v1/mt5/updateStopsLimits',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1Mt5UpdateStopsLimitsPost({
    @Query('userId') required int? userId,
    @Query('copySLTP') required bool? copySLTP,
    @Query('scalperMode') required String? scalperMode,
    @Query('orderFilter') required String? orderFilter,
    @Query('scalperValue') required int? scalperValue,
  });

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for.
  Future<chopper.Response<FollowRiskSetting>>
      apiV1Mt5GetOrderControlSettingsGet({required int? userId}) {
    generatedMapping.putIfAbsent(
        FollowRiskSetting, () => FollowRiskSetting.fromJsonFactory);

    return _apiV1Mt5GetOrderControlSettingsGet(userId: userId);
  }

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for.
  @Get(path: '/api/v1/mt5/getOrderControlSettings')
  Future<chopper.Response<FollowRiskSetting>>
      _apiV1Mt5GetOrderControlSettingsGet(
          {@Query('userId') required int? userId});

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  Future<chopper.Response> apiV1Mt5UpdateOrderControlSettingPost({
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
    return _apiV1Mt5UpdateOrderControlSettingPost(
        userId: userId,
        profitOverPoint: profitOverPoint,
        lossOverPoint: lossOverPoint,
        profitForEveryOrder: profitForEveryOrder,
        lossForEveryOrder: lossForEveryOrder,
        profitForAllOrder: profitForAllOrder,
        lossForAllOrder: lossForAllOrder,
        equityUnderLow: equityUnderLow,
        equityUnderHigh: equityUnderHigh,
        pendingOrderProfitPoint: pendingOrderProfitPoint,
        pendingOrderLossPoint: pendingOrderLossPoint,
        pendingTimeout: pendingTimeout);
  }

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  @Post(
    path: '/api/v1/mt5/updateOrderControlSetting',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1Mt5UpdateOrderControlSettingPost({
    @Query('userId') required int? userId,
    @Query('profitOverPoint') required int? profitOverPoint,
    @Query('lossOverPoint') required int? lossOverPoint,
    @Query('profitForEveryOrder') required int? profitForEveryOrder,
    @Query('lossForEveryOrder') required int? lossForEveryOrder,
    @Query('profitForAllOrder') required int? profitForAllOrder,
    @Query('lossForAllOrder') required int? lossForAllOrder,
    @Query('equityUnderLow') required int? equityUnderLow,
    @Query('equityUnderHigh') required int? equityUnderHigh,
    @Query('pendingOrderProfitPoint') required int? pendingOrderProfitPoint,
    @Query('pendingOrderLossPoint') required int? pendingOrderLossPoint,
    @Query('pendingTimeout') required int? pendingTimeout,
  });

  ///Register Master Account for cTrader with clientId, clientSecret, refreshToken,  email
  ///@param userId The userId for cTrader.<br /><br/>
  ///@param clientId The client ID for cTrader.<br /><br/>
  ///@param clientSecret The client secret for cTrader.<br /><br/>
  ///@param refreshToken The refresh token for cTrader.<br /><br/>
  ///@param expireIn The expiration time in seconds.<br /><br/>
  ///@param email The email associated with the account.<br /><br/>
  ///@param accountName The name of the account.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1RegisterMasterCtraderPost({
    required int? userId,
    required String? clientId,
    required String? clientSecret,
    required String? refreshToken,
    required String? expireIn,
    required String? email,
    required String? accountName,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterMasterCtraderPost(
        userId: userId,
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        expireIn: expireIn,
        email: email,
        accountName: accountName,
        comment: comment);
  }

  ///Register Master Account for cTrader with clientId, clientSecret, refreshToken,  email
  ///@param userId The userId for cTrader.<br /><br/>
  ///@param clientId The client ID for cTrader.<br /><br/>
  ///@param clientSecret The client secret for cTrader.<br /><br/>
  ///@param refreshToken The refresh token for cTrader.<br /><br/>
  ///@param expireIn The expiration time in seconds.<br /><br/>
  ///@param email The email associated with the account.<br /><br/>
  ///@param accountName The name of the account.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  @Post(
    path: '/api/v1/register_master_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1RegisterMasterCtraderPost({
    @Query('userId') required int? userId,
    @Query('clientId') required String? clientId,
    @Query('clientSecret') required String? clientSecret,
    @Query('refreshToken') required String? refreshToken,
    @Query('expireIn') required String? expireIn,
    @Query('email') required String? email,
    @Query('accountName') required String? accountName,
    @Query('comment') String? comment,
  });

  ///Register Slave Account for cTrader  with clientId, clientSecret, refreshToken,  email, masterId
  ///@param userId The userId for cTrader.<br /><br/>
  ///@param clientId The client ID for cTrader.<br /><br/>
  ///@param clientSecret The client secret for cTrader.<br /><br/>
  ///@param refreshToken The refresh token for cTrader.<br /><br/>
  ///@param expireIn The expiration time in seconds.<br /><br/>
  ///@param masterId The master userId associated with the slave account.<br /><br/>
  ///@param email The email associated with the account.<br /><br/>
  ///@param accountName The name of the account.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  ///@param copyOrderType The type of order copy:<br/>- `0`: Copy All Existing Orders<br/>- `1`: Copy  All New Orders
  Future<chopper.Response<StringResponseDto>> apiV1RegisterSlaveCtraderPost({
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
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterSlaveCtraderPost(
        userId: userId,
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: refreshToken,
        expireIn: expireIn,
        masterId: masterId,
        email: email,
        accountName: accountName,
        comment: comment,
        copyOrderType: copyOrderType);
  }

  ///Register Slave Account for cTrader  with clientId, clientSecret, refreshToken,  email, masterId
  ///@param userId The userId for cTrader.<br /><br/>
  ///@param clientId The client ID for cTrader.<br /><br/>
  ///@param clientSecret The client secret for cTrader.<br /><br/>
  ///@param refreshToken The refresh token for cTrader.<br /><br/>
  ///@param expireIn The expiration time in seconds.<br /><br/>
  ///@param masterId The master userId associated with the slave account.<br /><br/>
  ///@param email The email associated with the account.<br /><br/>
  ///@param accountName The name of the account.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  ///@param copyOrderType The type of order copy:<br/>- `0`: Copy All Existing Orders<br/>- `1`: Copy  All New Orders
  @Post(
    path: '/api/v1/register_slave_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1RegisterSlaveCtraderPost({
    @Query('userId') required int? userId,
    @Query('clientId') required String? clientId,
    @Query('clientSecret') required String? clientSecret,
    @Query('refreshToken') required String? refreshToken,
    @Query('expireIn') String? expireIn,
    @Query('masterId') required int? masterId,
    @Query('email') String? email,
    @Query('accountName') required String? accountName,
    @Query('comment') String? comment,
    @Query('copyOrderType') required int? copyOrderType,
  });

  ///Update Slave Account for cTrader  with  refreshToken, expireIn.
  ///@param userId The user ID for cTrader.<br /><br/>
  ///@param refreshToken The refresh token for cTrader.<br /><br/>
  ///@param expireIn The expiration time in seconds.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1UpdateMasterCtraderPost({
    required int? userId,
    required String? refreshToken,
    int? expireIn,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateMasterCtraderPost(
        userId: userId,
        refreshToken: refreshToken,
        expireIn: expireIn,
        comment: comment);
  }

  ///Update Slave Account for cTrader  with  refreshToken, expireIn.
  ///@param userId The user ID for cTrader.<br /><br/>
  ///@param refreshToken The refresh token for cTrader.<br /><br/>
  ///@param expireIn The expiration time in seconds.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  @Post(
    path: '/api/v1/update_Master_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateMasterCtraderPost({
    @Query('userId') required int? userId,
    @Query('refreshToken') required String? refreshToken,
    @Query('expireIn') int? expireIn,
    @Query('comment') String? comment,
  });

  ///Update Slave Account for cTrader  with  refreshToken, expireIn
  ///@param userId The user ID for cTrader.<br /><br/>
  ///@param refreshToken The refresh token for cTrader.<br /><br/>
  ///@param expireIn The expiration time in seconds.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1UpdateSlaveCtraderPost({
    required int? userId,
    required String? refreshToken,
    int? expireIn,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateSlaveCtraderPost(
        userId: userId,
        refreshToken: refreshToken,
        expireIn: expireIn,
        comment: comment);
  }

  ///Update Slave Account for cTrader  with  refreshToken, expireIn
  ///@param userId The user ID for cTrader.<br /><br/>
  ///@param refreshToken The refresh token for cTrader.<br /><br/>
  ///@param expireIn The expiration time in seconds.<br /><br/>
  ///@param comment Optional comment for the registration.<br /><br/>
  @Post(
    path: '/api/v1/update_slave_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateSlaveCtraderPost({
    @Query('userId') required int? userId,
    @Query('refreshToken') required String? refreshToken,
    @Query('expireIn') int? expireIn,
    @Query('comment') String? comment,
  });

  ///Send Order for cTrader
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size for the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1SendOrderCtraderPost({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required enums.ApiV1SendOrderCtraderPostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendOrderCtraderPost(
        userId: userId,
        orderType: orderType,
        lots: lots,
        symbol: symbol,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Send Order for cTrader
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size for the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/send_order_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1SendOrderCtraderPost({
    @Query('userId') required int? userId,
    @Query('orderType') required String? orderType,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Fetch Orders for cTrader
  ///@param userId The ID of the account for which to retrieve orders.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response<String>> apiV1GetOrdersCtraderPost({
    required int? userId,
    required enums.ApiV1GetOrdersCtraderPostAccountStatus? accountStatus,
  }) {
    return _apiV1GetOrdersCtraderPost(
        userId: userId, accountStatus: accountStatus?.value?.toString());
  }

  ///Fetch Orders for cTrader
  ///@param userId The ID of the account for which to retrieve orders.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/get_orders_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<String>> _apiV1GetOrdersCtraderPost({
    @Query('userId') required int? userId,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Modify Order for cTrader
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ModifyOrderCtraderPost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required enums.ApiV1ModifyOrderCtraderPostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ModifyOrderCtraderPost(
        ticket: ticket,
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify Order for cTrader
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/modify_order_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ModifyOrderCtraderPost({
    @Query('ticket') required int? ticket,
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Order for cTrader
  ///@param userId The ID of the user closing the order.<br /><br/>
  ///@param ticket The ticket ID of the order to close.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response> apiV1CloseOrderCtraderPost({
    required int? userId,
    required int? ticket,
    required enums.ApiV1CloseOrderCtraderPostAccountStatus? accountStatus,
  }) {
    return _apiV1CloseOrderCtraderPost(
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Order for cTrader
  ///@param userId The ID of the user closing the order.<br /><br/>
  ///@param ticket The ticket ID of the order to close.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/close_order_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseOrderCtraderPost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Partially Close an Order for Ctrader
  ///@param userId The ID of the user closing the order.
  ///@param ticket The ticket ID of the order to partially close. Default value is 1234.
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response> apiV1CtraderPartialCloseOrderPost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required enums.ApiV1CtraderPartialCloseOrderPostAccountStatus?
        accountStatus,
  }) {
    return _apiV1CtraderPartialCloseOrderPost(
        userId: userId,
        ticket: ticket,
        lots: lots,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Partially Close an Order for Ctrader
  ///@param userId The ID of the user closing the order.
  ///@param ticket The ticket ID of the order to partially close. Default value is 1234.
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/ctrader/partialCloseOrder',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CtraderPartialCloseOrderPost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('lots') required num? lots,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Send Pending Order for cTrader
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BuyLimit, SellLimit, BuyStop, SellStop,  BuyStopLimit, SellStopLimit).<br /><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param lots The lot size for the order.<br /><br/>
  ///@param price The price at which the order is to be placed.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1SendPendingOrderCtraderPost({
    required int? userId,
    required String? orderType,
    required String? symbol,
    required num? lots,
    required num? price,
    num? stopLoss,
    num? takeProfit,
    required enums.ApiV1SendPendingOrderCtraderPostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendPendingOrderCtraderPost(
        userId: userId,
        orderType: orderType,
        symbol: symbol,
        lots: lots,
        price: price,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Send Pending Order for cTrader
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BuyLimit, SellLimit, BuyStop, SellStop,  BuyStopLimit, SellStopLimit).<br /><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param lots The lot size for the order.<br /><br/>
  ///@param price The price at which the order is to be placed.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/send_pending_order_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1SendPendingOrderCtraderPost({
    @Query('userId') required int? userId,
    @Query('orderType') required String? orderType,
    @Query('symbol') required String? symbol,
    @Query('lots') required num? lots,
    @Query('price') required num? price,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Modify Pending Order for cTrader
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response> apiV1ModifyPendingOrderCtraderPost({
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required int? ticket,
    required enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus?
        accountStatus,
  }) {
    return _apiV1ModifyPendingOrderCtraderPost(
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify Pending Order for cTrader
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/modify_pending_order_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1ModifyPendingOrderCtraderPost({
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Pending Order for cTrader
  ///@param userId The ID of the user closing the pending order.<br /><br/>
  ///@param ticket The ticket ID of the pending order to close.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response> apiV1ClosePendingOrderCtraderPost({
    required int? userId,
    required int? ticket,
    required enums.ApiV1ClosePendingOrderCtraderPostAccountStatus?
        accountStatus,
  }) {
    return _apiV1ClosePendingOrderCtraderPost(
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Pending Order for cTrader
  ///@param userId The ID of the user closing the pending order.<br /><br/>
  ///@param ticket The ticket ID of the pending order to close.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/close_pending_order_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1ClosePendingOrderCtraderPost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders for cTrader
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrdersForCtraderPost({
    required int? userid,
    required enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus?
        accountStatus,
  }) {
    return _apiV1CloseAllOrdersForCtraderPost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders for cTrader
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrdersForCtrader',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrdersForCtraderPost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders by Symbol for cTrader
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<CancelDto>> apiV1CloseAllOrderBySymbolForCtraderPost({
    required int? userid,
    required String? symbol,
    required enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(CancelDto, () => CancelDto.fromJsonFactory);

    return _apiV1CloseAllOrderBySymbolForCtraderPost(
        userid: userid,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders by Symbol for cTrader
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySymbolForCtrader',
    optionalBody: true,
  )
  Future<chopper.Response<CancelDto>>
      _apiV1CloseAllOrderBySymbolForCtraderPost({
    @Query('userid') required int? userid,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Sell Orders for cTrader
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrderBySellCtraderPost({
    required int? userid,
    required enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus?
        accountStatus,
  }) {
    return _apiV1CloseAllOrderBySellCtraderPost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Sell Orders for cTrader
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySell/Ctrader',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrderBySellCtraderPost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Buy Orders for cTrader
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrderByBuyCtraderPost({
    required int? userid,
    required enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus?
        accountStatus,
  }) {
    return _apiV1CloseAllOrderByBuyCtraderPost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Buy Orders for cTrader
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderByBuy/Ctrader',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrderByBuyCtraderPost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Get Order History for cTrader
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param id The ID of the account for which to retrieve order history.<br /><br/>
  ///@param from The start date for the order history.<br /><br/>
  ///@param to The end date for the order history.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1GetOrderHistoryCtraderPost({
    required enums.ApiV1GetOrderHistoryCtraderPostAccountStatus? accountStatus,
    required int? id,
    required DateTime? from,
    required DateTime? to,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetOrderHistoryCtraderPost(
        accountStatus: accountStatus?.value?.toString(),
        id: id,
        from: from,
        to: to);
  }

  ///Get Order History for cTrader
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param id The ID of the account for which to retrieve order history.<br /><br/>
  ///@param from The start date for the order history.<br /><br/>
  ///@param to The end date for the order history.<br /><br/>
  @Post(
    path: '/api/v1/get_order_history_ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1GetOrderHistoryCtraderPost({
    @Query('accountStatus') required String? accountStatus,
    @Query('id') required int? id,
    @Query('from') required DateTime? from,
    @Query('to') required DateTime? to,
  });

  ///Get Order History for cTrader
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param id The ID of the account for which to retrieve order history.<br /><br/>
  ///@param from The start date for the order history.<br /><br/>
  ///@param to The end date for the order history.<br /><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1GetOrderHistoryCtraderMasterPost({
    required enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus?
        accountStatus,
    required int? id,
    required DateTime? from,
    required DateTime? to,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetOrderHistoryCtraderMasterPost(
        accountStatus: accountStatus?.value?.toString(),
        id: id,
        from: from,
        to: to);
  }

  ///Get Order History for cTrader
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param id The ID of the account for which to retrieve order history.<br /><br/>
  ///@param from The start date for the order history.<br /><br/>
  ///@param to The end date for the order history.<br /><br/>
  @Post(
    path: '/api/v1/get_order_history_ctraderMaster',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1GetOrderHistoryCtraderMasterPost({
    @Query('accountStatus') required String? accountStatus,
    @Query('id') required int? id,
    @Query('from') required DateTime? from,
    @Query('to') required DateTime? to,
  });

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveMasterCtraderPost({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveMasterCtraderPost(id: id, status: status);
  }

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_master/Ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveMasterCtraderPost({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveSlaveCtraderPost({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveSlaveCtraderPost(id: id, status: status);
  }

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_slave/Ctrader',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveSlaveCtraderPost({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  Future<chopper.Response> apiV1SymbolMapCtraderPost({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    return _apiV1SymbolMapCtraderPost(
        userid: userid,
        sourceSymbol: sourceSymbol,
        followSymbol: followSymbol,
        type: type);
  }

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  @Post(
    path: '/api/v1/symbol_map/ctrader',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1SymbolMapCtraderPost({
    @Query('userid') required int? userid,
    @Query('sourceSymbol') required String? sourceSymbol,
    @Query('followSymbol') required String? followSymbol,
    @Query('type') required String? type,
  });

  ///Get Suffix Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSuffixCtraderUserIdGet(
      {required int? userId}) {
    return _apiV1GetSuffixCtraderUserIdGet(userId: userId);
  }

  ///Get Suffix Symbols
  ///@param userId
  @Get(path: '/api/v1/getSuffix/ctrader/{userId}')
  Future<chopper.Response> _apiV1GetSuffixCtraderUserIdGet(
      {@Path('userId') required int? userId});

  ///Get Special Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSpecialCtraderUserIdGet(
      {required int? userId}) {
    return _apiV1GetSpecialCtraderUserIdGet(userId: userId);
  }

  ///Get Special Symbols
  ///@param userId
  @Get(path: '/api/v1/getSpecial/ctrader/{userId}')
  Future<chopper.Response> _apiV1GetSpecialCtraderUserIdGet(
      {@Path('userId') required int? userId});

  ///Get All Symbols
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId
  Future<chopper.Response<StringResponseDto>>
      apiV1GetAllSymbolCtraderUserIdGet({
    required enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus?
        accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetAllSymbolCtraderUserIdGet(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Get All Symbols
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId
  @Get(path: '/api/v1/getAllSymbol/ctrader/{userId}')
  Future<chopper.Response<StringResponseDto>>
      _apiV1GetAllSymbolCtraderUserIdGet({
    @Query('accountStatus') required String? accountStatus,
    @Path('userId') required int? userId,
  });

  ///Get All Symbols
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId
  Future<chopper.Response<StringResponseDto>> apiV1GetAllSymbolMT5UserIdGet({
    required enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus? accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetAllSymbolMT5UserIdGet(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Get All Symbols
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId
  @Get(path: '/api/v1/getAllSymbol/MT5/{userId}')
  Future<chopper.Response<StringResponseDto>> _apiV1GetAllSymbolMT5UserIdGet({
    @Query('accountStatus') required String? accountStatus,
    @Path('userId') required int? userId,
  });

  ///Get All Symbols
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId
  Future<chopper.Response<StringResponseDto>> apiV1GetAllSymbolMT4UserIdGet({
    required enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus? accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetAllSymbolMT4UserIdGet(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Get All Symbols
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId
  @Get(path: '/api/v1/getAllSymbol/MT4/{userId}')
  Future<chopper.Response<StringResponseDto>> _apiV1GetAllSymbolMT4UserIdGet({
    @Query('accountStatus') required String? accountStatus,
    @Path('userId') required int? userId,
  });

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  Future<chopper.Response<Risk>> apiV1CtraderGetRiskGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(Risk, () => Risk.fromJsonFactory);

    return _apiV1CtraderGetRiskGet(userId: userId);
  }

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  @Get(path: '/api/v1/ctrader/getRisk')
  Future<chopper.Response<Risk>> _apiV1CtraderGetRiskGet(
      {@Query('userId') required int? userId});

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  Future<chopper.Response> apiV1CtraderUpdateRiskPost({
    required int? userId,
    required enums.ApiV1CtraderUpdateRiskPostRiskType? riskType,
    required num? multiplier,
  }) {
    return _apiV1CtraderUpdateRiskPost(
        userId: userId,
        riskType: riskType?.value?.toString(),
        multiplier: multiplier);
  }

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  @Post(
    path: '/api/v1/ctrader/updateRisk',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CtraderUpdateRiskPost({
    @Query('userId') required int? userId,
    @Query('riskType') required String? riskType,
    @Query('multiplier') required num? multiplier,
  });

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  Future<chopper.Response<StopsLimits>> apiV1CtraderGetStopsLimitsGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(
        StopsLimits, () => StopsLimits.fromJsonFactory);

    return _apiV1CtraderGetStopsLimitsGet(userId: userId);
  }

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  @Get(path: '/api/v1/ctrader/getStopsLimits')
  Future<chopper.Response<StopsLimits>> _apiV1CtraderGetStopsLimitsGet(
      {@Query('userId') required int? userId});

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalperscalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  Future<chopper.Response> apiV1CtraderUpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode? scalperMode,
    required enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter? orderFilter,
    required int? scalperValue,
  }) {
    return _apiV1CtraderUpdateStopsLimitsPost(
        userId: userId,
        copySLTP: copySLTP,
        scalperMode: scalperMode?.value?.toString(),
        orderFilter: orderFilter?.value?.toString(),
        scalperValue: scalperValue);
  }

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalperscalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  @Post(
    path: '/api/v1/ctrader/updateStopsLimits',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CtraderUpdateStopsLimitsPost({
    @Query('userId') required int? userId,
    @Query('copySLTP') required bool? copySLTP,
    @Query('scalperMode') required String? scalperMode,
    @Query('orderFilter') required String? orderFilter,
    @Query('scalperValue') required int? scalperValue,
  });

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for.<br/><br/>
  Future<chopper.Response<FollowRiskSetting>>
      apiV1CtraderGetOrderControlSettingsGet({required int? userId}) {
    generatedMapping.putIfAbsent(
        FollowRiskSetting, () => FollowRiskSetting.fromJsonFactory);

    return _apiV1CtraderGetOrderControlSettingsGet(userId: userId);
  }

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for.<br/><br/>
  @Get(path: '/api/v1/ctrader/getOrderControlSettings')
  Future<chopper.Response<FollowRiskSetting>>
      _apiV1CtraderGetOrderControlSettingsGet(
          {@Query('userId') required int? userId});

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  Future<chopper.Response> apiV1CtraderUpdateOrderControlSettingPost({
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
    return _apiV1CtraderUpdateOrderControlSettingPost(
        userId: userId,
        profitOverPoint: profitOverPoint,
        lossOverPoint: lossOverPoint,
        profitForEveryOrder: profitForEveryOrder,
        lossForEveryOrder: lossForEveryOrder,
        profitForAllOrder: profitForAllOrder,
        lossForAllOrder: lossForAllOrder,
        equityUnderLow: equityUnderLow,
        equityUnderHigh: equityUnderHigh,
        pendingOrderProfitPoint: pendingOrderProfitPoint,
        pendingOrderLossPoint: pendingOrderLossPoint,
        pendingTimeout: pendingTimeout);
  }

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  @Post(
    path: '/api/v1/ctrader/updateOrderControlSetting',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CtraderUpdateOrderControlSettingPost({
    @Query('userId') required int? userId,
    @Query('profitOverPoint') required int? profitOverPoint,
    @Query('lossOverPoint') required int? lossOverPoint,
    @Query('profitForEveryOrder') required int? profitForEveryOrder,
    @Query('lossForEveryOrder') required int? lossForEveryOrder,
    @Query('profitForAllOrder') required int? profitForAllOrder,
    @Query('lossForAllOrder') required int? lossForAllOrder,
    @Query('equityUnderLow') required int? equityUnderLow,
    @Query('equityUnderHigh') required int? equityUnderHigh,
    @Query('pendingOrderProfitPoint') required int? pendingOrderProfitPoint,
    @Query('pendingOrderLossPoint') required int? pendingOrderLossPoint,
    @Query('pendingTimeout') required int? pendingTimeout,
  });

  ///Register Master Account for DxTrade
  ///@param userId The userId of the master account.
  ///@param userName The username for the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the DxTrade account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1RegisterMasterDxTradePost({
    required int? userId,
    required String? userName,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterMasterDxTradePost(
        userId: userId,
        userName: userName,
        password: password,
        server: server,
        comment: comment);
  }

  ///Register Master Account for DxTrade
  ///@param userId The userId of the master account.
  ///@param userName The username for the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the DxTrade account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/register_master_DxTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1RegisterMasterDxTradePost({
    @Query('userId') required int? userId,
    @Query('userName') required String? userName,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Register Slave Account for DxTrade
  ///@param userId The userId of the Slave account.
  ///@param userName The username for the Slave account.
  ///@param password The password for the Slave account.
  ///@param server The server name for the DxTrade account.
  ///@param comment Optional comment for the registration.
  ///@param masterId The master userId associated with the slave account.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1RegisterSlaveDxTradePost({
    required int? userId,
    required String? userName,
    required String? password,
    required String? server,
    String? comment,
    required int? masterId,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterSlaveDxTradePost(
        userId: userId,
        userName: userName,
        password: password,
        server: server,
        comment: comment,
        masterId: masterId);
  }

  ///Register Slave Account for DxTrade
  ///@param userId The userId of the Slave account.
  ///@param userName The username for the Slave account.
  ///@param password The password for the Slave account.
  ///@param server The server name for the DxTrade account.
  ///@param comment Optional comment for the registration.
  ///@param masterId The master userId associated with the slave account.<br /><br/>
  @Post(
    path: '/api/v1/register_slave_dxTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1RegisterSlaveDxTradePost({
    @Query('userId') required int? userId,
    @Query('userName') required String? userName,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
    @Query('masterId') required int? masterId,
  });

  ///Update Master Account for DxTrade
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the DxTrade account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1UpdateMasterDxtradePost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateMasterDxtradePost(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Update Master Account for DxTrade
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the DxTrade account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/update_Master_dxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateMasterDxtradePost({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Update Slave Account for DxTrade
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the DxTrade account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1UpdateSlaveDxtradePost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateSlaveDxtradePost(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Update Slave Account for DxTrade
  ///@param userId The User ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the DxTrade account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/update_slave_dxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateSlaveDxtradePost({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Send Position for DxTrade
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1SendPositionDxTradePost({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required String? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendPositionDxTradePost(
        userId: userId,
        orderType: orderType,
        lots: lots,
        symbol: symbol,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus);
  }

  ///Send Position for DxTrade
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  @Post(
    path: '/api/v1/send_position_dxTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1SendPositionDxTradePost({
    @Query('userId') required int? userId,
    @Query('orderType') required String? orderType,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Get Open Position for DxTrade
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The ID of the user for which to retrieve orders.<br /><br/>
  Future<chopper.Response<DxTradePositionDtoListResponseDto>>
      apiV1GetOpenPositionDxTradePost({
    required enums.ApiV1GetOpenPositionDxTradePostAccountStatus? accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(DxTradePositionDtoListResponseDto,
        () => DxTradePositionDtoListResponseDto.fromJsonFactory);

    return _apiV1GetOpenPositionDxTradePost(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Get Open Position for DxTrade
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The ID of the user for which to retrieve orders.<br /><br/>
  @Post(
    path: '/api/v1/get_Open_Position_dxTrade',
    optionalBody: true,
  )
  Future<chopper.Response<DxTradePositionDtoListResponseDto>>
      _apiV1GetOpenPositionDxTradePost({
    @Query('accountStatus') required String? accountStatus,
    @Query('userId') required int? userId,
  });

  ///Modify Position for DxTrade
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response<StringResponseDto>> apiV1ModifyPositionDxtradePost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required String? side,
    required num? lots,
    required String? symbol,
    required enums.ApiV1ModifyPositionDxtradePostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ModifyPositionDxtradePost(
        ticket: ticket,
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        side: side,
        lots: lots,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify Position for DxTrade
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/modify_position_dxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ModifyPositionDxtradePost({
    @Query('ticket') required int? ticket,
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('Side') required String? side,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Order for DxTrade
  ///@param lots The volume of lots to close. Default value is 0.01.
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param userId The ID of the user closing the order. Default value is 123456.<br /><br/>
  ///@param ticket The ticket ID of the order to close. Default value is 1234.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ClosePositionDxtradePost({
    required num? lots,
    required String? symbol,
    required int? userId,
    required int? ticket,
    required enums.ApiV1ClosePositionDxtradePostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ClosePositionDxtradePost(
        lots: lots,
        symbol: symbol,
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Order for DxTrade
  ///@param lots The volume of lots to close. Default value is 0.01.
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param userId The ID of the user closing the order. Default value is 123456.<br /><br/>
  ///@param ticket The ticket ID of the order to close. Default value is 1234.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/close_position_dxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ClosePositionDxtradePost({
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Partially Close an Order for DxTrade
  ///@param userId The ID of the user closing the partially order.
  ///@param ticket The ticket ID of the order to partially close. Default value is 1234.
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response> apiV1PartialCloseOrderDxtradePost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required String? symbol,
    required enums.ApiV1PartialCloseOrderDxtradePostAccountStatus?
        accountStatus,
  }) {
    return _apiV1PartialCloseOrderDxtradePost(
        userId: userId,
        ticket: ticket,
        lots: lots,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Partially Close an Order for DxTrade
  ///@param userId The ID of the user closing the partially order.
  ///@param ticket The ticket ID of the order to partially close. Default value is 1234.
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/partialCloseOrderDxtrade',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1PartialCloseOrderDxtradePost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders for Dxtrade
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrdersForDxtradePost({
    required int? userid,
    required enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus?
        accountStatus,
  }) {
    return _apiV1CloseAllOrdersForDxtradePost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders for Dxtrade
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrdersForDxtrade',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrdersForDxtradePost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders by Symbol for Dxtrade
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<CancelDto>> apiV1CloseAllOrderBySymbolForDxtradePost({
    required int? userid,
    required String? symbol,
    required enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(CancelDto, () => CancelDto.fromJsonFactory);

    return _apiV1CloseAllOrderBySymbolForDxtradePost(
        userid: userid,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders by Symbol for Dxtrade
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySymbolForDxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<CancelDto>>
      _apiV1CloseAllOrderBySymbolForDxtradePost({
    @Query('userid') required int? userid,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Sell Orders for Dxtrade
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1CloseAllOrderBySellForDxtradePost({
    required int? userid,
    required enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1CloseAllOrderBySellForDxtradePost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Sell Orders for Dxtrade
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySellForDxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1CloseAllOrderBySellForDxtradePost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Buy Orders for Dxtrade
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1CloseAllOrderByBuyForDxtradePost({
    required int? userid,
    required enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1CloseAllOrderByBuyForDxtradePost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Buy Orders for Dxtrade
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderByBuyForDxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1CloseAllOrderByBuyForDxtradePost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Send pending Order for DxTrade
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1SendPendingOrderDxTradePost({
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
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendPendingOrderDxTradePost(
        userId: userId,
        side: side,
        type: type,
        lots: lots,
        symbol: symbol,
        price: price,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus);
  }

  ///Send pending Order for DxTrade
  ///@param userId The ID of the user placing the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  @Post(
    path: '/api/v1/send_pending_order_dxTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1SendPendingOrderDxTradePost({
    @Query('userId') required int? userId,
    @Query('Side') required String? side,
    @Query('Type') required String? type,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('price') required num? price,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Get Pending Orders for DxTrade
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The ID of the user for which to retrieve orders.<br /><br/>
  Future<chopper.Response<DxTradePositionDtoListResponseDto>>
      apiV1GetPendingOrdersDxTradePost({
    required enums.ApiV1GetPendingOrdersDxTradePostAccountStatus? accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(DxTradePositionDtoListResponseDto,
        () => DxTradePositionDtoListResponseDto.fromJsonFactory);

    return _apiV1GetPendingOrdersDxTradePost(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Get Pending Orders for DxTrade
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The ID of the user for which to retrieve orders.<br /><br/>
  @Post(
    path: '/api/v1/get_pending_orders_dxTrade',
    optionalBody: true,
  )
  Future<chopper.Response<DxTradePositionDtoListResponseDto>>
      _apiV1GetPendingOrdersDxTradePost({
    @Query('accountStatus') required String? accountStatus,
    @Query('userId') required int? userId,
  });

  ///Modify pending order for DxTrade
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response<StringResponseDto>>
      apiV1ModifyPendingOrderDxtradePost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required num? price,
    required num? lots,
    required enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ModifyPendingOrderDxtradePost(
        ticket: ticket,
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        price: price,
        lots: lots,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify pending order for DxTrade
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/modify_pendingOrder_dxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ModifyPendingOrderDxtradePost({
    @Query('ticket') required int? ticket,
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('price') required num? price,
    @Query('lots') required num? lots,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Pending Order for DxTrade
  ///@param userId The ID of the user closing the pending order. Default value is 123456.<br  /><br/>
  ///@param ticket The ticket ID of the pending order to close. Default value is 1234.<br  /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1ClosePendingOrderDxtradePost({
    required int? userId,
    required int? ticket,
    required enums.ApiV1ClosePendingOrderDxtradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ClosePendingOrderDxtradePost(
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Pending Order for DxTrade
  ///@param userId The ID of the user closing the pending order. Default value is 123456.<br  /><br/>
  ///@param ticket The ticket ID of the pending order to close. Default value is 1234.<br  /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/close_pending_order_dxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ClosePendingOrderDxtradePost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Get Order History for DxTrade
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The UserID of the account for which to retrieve order history.<br /><br/>
  ///@param from The start date for the order history. Format: yyyy-MM-ddTHH:mm:ss (e.g.,  2025-04-19T00:00:00).<br /><br/>
  ///@param to The end date for the order history. Format: yyyy-MM-ddTHH:mm:ss (e.g.,  2025-05-19T23:59:59).<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1GetOrderHistoryDxtradePost({
    required enums.ApiV1GetOrderHistoryDxtradePostAccountStatus? accountStatus,
    required int? userId,
    required DateTime? from,
    required DateTime? to,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetOrderHistoryDxtradePost(
        accountStatus: accountStatus?.value?.toString(),
        userId: userId,
        from: from,
        to: to);
  }

  ///Get Order History for DxTrade
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The UserID of the account for which to retrieve order history.<br /><br/>
  ///@param from The start date for the order history. Format: yyyy-MM-ddTHH:mm:ss (e.g.,  2025-04-19T00:00:00).<br /><br/>
  ///@param to The end date for the order history. Format: yyyy-MM-ddTHH:mm:ss (e.g.,  2025-05-19T23:59:59).<br /><br/>
  @Post(
    path: '/api/v1/get_order_history_dxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1GetOrderHistoryDxtradePost({
    @Query('accountStatus') required String? accountStatus,
    @Query('userId') required int? userId,
    @Query('from') required DateTime? from,
    @Query('to') required DateTime? to,
  });

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveMasterDxtradePost({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveMasterDxtradePost(id: id, status: status);
  }

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_master_dxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveMasterDxtradePost({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveSlaveDxtradePost({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveSlaveDxtradePost(id: id, status: status);
  }

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_slave_dxtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveSlaveDxtradePost({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  Future<chopper.Response> apiV1SymbolMapDxtradePost({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    return _apiV1SymbolMapDxtradePost(
        userid: userid,
        sourceSymbol: sourceSymbol,
        followSymbol: followSymbol,
        type: type);
  }

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  @Post(
    path: '/api/v1/symbol_map_dxtrade',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1SymbolMapDxtradePost({
    @Query('userid') required int? userid,
    @Query('sourceSymbol') required String? sourceSymbol,
    @Query('followSymbol') required String? followSymbol,
    @Query('type') required String? type,
  });

  ///Get Suffix Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSuffixDxTradeUserIdGet(
      {required int? userId}) {
    return _apiV1GetSuffixDxTradeUserIdGet(userId: userId);
  }

  ///Get Suffix Symbols
  ///@param userId
  @Get(path: '/api/v1/getSuffixDxTrade/{userId}')
  Future<chopper.Response> _apiV1GetSuffixDxTradeUserIdGet(
      {@Path('userId') required int? userId});

  ///Get Special Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSpecialDxTradeUserIdGet(
      {required int? userId}) {
    return _apiV1GetSpecialDxTradeUserIdGet(userId: userId);
  }

  ///Get Special Symbols
  ///@param userId
  @Get(path: '/api/v1/getSpecialDxTrade/{userId}')
  Future<chopper.Response> _apiV1GetSpecialDxTradeUserIdGet(
      {@Path('userId') required int? userId});

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  Future<chopper.Response<Risk>> apiV1DxTradeGetRiskGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(Risk, () => Risk.fromJsonFactory);

    return _apiV1DxTradeGetRiskGet(userId: userId);
  }

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  @Get(path: '/api/v1/DxTrade/getRisk')
  Future<chopper.Response<Risk>> _apiV1DxTradeGetRiskGet(
      {@Query('userId') required int? userId});

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  Future<chopper.Response> apiV1DxTradeUpdateRiskPost({
    required int? userId,
    required enums.ApiV1DxTradeUpdateRiskPostRiskType? riskType,
    required num? multiplier,
  }) {
    return _apiV1DxTradeUpdateRiskPost(
        userId: userId,
        riskType: riskType?.value?.toString(),
        multiplier: multiplier);
  }

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  @Post(
    path: '/api/v1/DxTrade/updateRisk',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1DxTradeUpdateRiskPost({
    @Query('userId') required int? userId,
    @Query('riskType') required String? riskType,
    @Query('multiplier') required num? multiplier,
  });

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  Future<chopper.Response<StopsLimits>> apiV1DxTradeGetStopsLimitsGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(
        StopsLimits, () => StopsLimits.fromJsonFactory);

    return _apiV1DxTradeGetStopsLimitsGet(userId: userId);
  }

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  @Get(path: '/api/v1/DxTrade/getStopsLimits')
  Future<chopper.Response<StopsLimits>> _apiV1DxTradeGetStopsLimitsGet(
      {@Query('userId') required int? userId});

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  Future<chopper.Response> apiV1DxTradeUpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode? scalperMode,
    required enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter? orderFilter,
    required int? scalperValue,
  }) {
    return _apiV1DxTradeUpdateStopsLimitsPost(
        userId: userId,
        copySLTP: copySLTP,
        scalperMode: scalperMode?.value?.toString(),
        orderFilter: orderFilter?.value?.toString(),
        scalperValue: scalperValue);
  }

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  @Post(
    path: '/api/v1/DxTrade/updateStopsLimits',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1DxTradeUpdateStopsLimitsPost({
    @Query('userId') required int? userId,
    @Query('copySLTP') required bool? copySLTP,
    @Query('scalperMode') required String? scalperMode,
    @Query('orderFilter') required String? orderFilter,
    @Query('scalperValue') required int? scalperValue,
  });

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for. <br/><br/>
  Future<chopper.Response<FollowRiskSetting>>
      apiV1DxTradeGetOrderControlSettingsGet({required int? userId}) {
    generatedMapping.putIfAbsent(
        FollowRiskSetting, () => FollowRiskSetting.fromJsonFactory);

    return _apiV1DxTradeGetOrderControlSettingsGet(userId: userId);
  }

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for. <br/><br/>
  @Get(path: '/api/v1/DxTrade/getOrderControlSettings')
  Future<chopper.Response<FollowRiskSetting>>
      _apiV1DxTradeGetOrderControlSettingsGet(
          {@Query('userId') required int? userId});

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  Future<chopper.Response> apiV1DxTradeUpdateOrderControlSettingPost({
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
    return _apiV1DxTradeUpdateOrderControlSettingPost(
        userId: userId,
        profitOverPoint: profitOverPoint,
        lossOverPoint: lossOverPoint,
        profitForEveryOrder: profitForEveryOrder,
        lossForEveryOrder: lossForEveryOrder,
        profitForAllOrder: profitForAllOrder,
        lossForAllOrder: lossForAllOrder,
        equityUnderLow: equityUnderLow,
        equityUnderHigh: equityUnderHigh,
        pendingOrderProfitPoint: pendingOrderProfitPoint,
        pendingOrderLossPoint: pendingOrderLossPoint,
        pendingTimeout: pendingTimeout);
  }

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  @Post(
    path: '/api/v1/DxTrade/updateOrderControlSetting',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1DxTradeUpdateOrderControlSettingPost({
    @Query('userId') required int? userId,
    @Query('profitOverPoint') required int? profitOverPoint,
    @Query('lossOverPoint') required int? lossOverPoint,
    @Query('profitForEveryOrder') required int? profitForEveryOrder,
    @Query('lossForEveryOrder') required int? lossForEveryOrder,
    @Query('profitForAllOrder') required int? profitForAllOrder,
    @Query('lossForAllOrder') required int? lossForAllOrder,
    @Query('equityUnderLow') required int? equityUnderLow,
    @Query('equityUnderHigh') required int? equityUnderHigh,
    @Query('pendingOrderProfitPoint') required int? pendingOrderProfitPoint,
    @Query('pendingOrderLossPoint') required int? pendingOrderLossPoint,
    @Query('pendingTimeout') required int? pendingTimeout,
  });

  ///Register Master Account for TradeLocker
  ///@param userId The userId of the master account.
  ///@param emailId The email ID for the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the TradeLocker account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>>
      apiV1RegisterMasterTradeLockerPost({
    required int? userId,
    required String? emailId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterMasterTradeLockerPost(
        userId: userId,
        emailId: emailId,
        password: password,
        server: server,
        comment: comment);
  }

  ///Register Master Account for TradeLocker
  ///@param userId The userId of the master account.
  ///@param emailId The email ID for the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the TradeLocker account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/register_master_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1RegisterMasterTradeLockerPost({
    @Query('userId') required int? userId,
    @Query('emailId') required String? emailId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Register Slave Account for TradeLocker
  ///@param userId The userId of the Slave account.
  ///@param emailId The email ID for the Slave account.
  ///@param password The password for the Slave account.
  ///@param server The server name for the TradeLocker account.
  ///@param comment Optional comment for the registration.
  ///@param masterAcountId The master userId associated with the slave account.<br /><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1RegisterSlaveTradeLockerPost({
    required int? userId,
    required String? emailId,
    required String? password,
    required String? server,
    String? comment,
    required int? masterAcountId,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterSlaveTradeLockerPost(
        userId: userId,
        emailId: emailId,
        password: password,
        server: server,
        comment: comment,
        masterAcountId: masterAcountId);
  }

  ///Register Slave Account for TradeLocker
  ///@param userId The userId of the Slave account.
  ///@param emailId The email ID for the Slave account.
  ///@param password The password for the Slave account.
  ///@param server The server name for the TradeLocker account.
  ///@param comment Optional comment for the registration.
  ///@param masterAcountId The master userId associated with the slave account.<br /><br/>
  @Post(
    path: '/api/v1/register_slave_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1RegisterSlaveTradeLockerPost({
    @Query('userId') required int? userId,
    @Query('emailId') required String? emailId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
    @Query('masterAcountId') required int? masterAcountId,
  });

  ///Update Master Account for TradeLocker
  ///@param userId The Account ID of the master account.
  ///@param password The password for the master account.
  ///@param server The  name for the TradeLocker account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1UpdateMasterTradeLockerPost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateMasterTradeLockerPost(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Update Master Account for TradeLocker
  ///@param userId The Account ID of the master account.
  ///@param password The password for the master account.
  ///@param server The  name for the TradeLocker account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/update_master_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1UpdateMasterTradeLockerPost({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Update Slave Account for TradeLocker
  ///@param userId The Account ID of the slave account.
  ///@param password The password for the slave account.
  ///@param server The server name for the TradeLocker account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1UpdateSlaveTradeLockerPost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateSlaveTradeLockerPost(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Update Slave Account for TradeLocker
  ///@param userId The Account ID of the slave account.
  ///@param password The password for the slave account.
  ///@param server The server name for the TradeLocker account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/update_slave_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateSlaveTradeLockerPost({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Send New Position for TradeLocker
  ///@param userId The userId of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1SendPositionTradeLockerPost({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required enums.ApiV1SendPositionTradeLockerPostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendPositionTradeLockerPost(
        userId: userId,
        orderType: orderType,
        lots: lots,
        symbol: symbol,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Send New Position for TradeLocker
  ///@param userId The userId of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/send_position_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1SendPositionTradeLockerPost({
    @Query('userId') required int? userId,
    @Query('orderType') required String? orderType,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Fetch Orders for TradeLocker
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The userId of the user for which to retrieve positions.<br /><br/>
  Future<chopper.Response<MT4OrderDtoListResponseDto>>
      apiV1GetOrdersTradeLockerPost({
    required enums.ApiV1GetOrdersTradeLockerPostAccountStatus? accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(MT4OrderDtoListResponseDto,
        () => MT4OrderDtoListResponseDto.fromJsonFactory);

    return _apiV1GetOrdersTradeLockerPost(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Fetch Orders for TradeLocker
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The userId of the user for which to retrieve positions.<br /><br/>
  @Post(
    path: '/api/v1/get_orders_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<MT4OrderDtoListResponseDto>>
      _apiV1GetOrdersTradeLockerPost({
    @Query('accountStatus') required String? accountStatus,
    @Query('userId') required int? userId,
  });

  ///Get Order History for TradeLocker
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param id The ID of the account for which to retrieve order history.<br /><br/>
  ///@param from The start date for the order history.<br /><br/>
  ///@param to The end date for the order history.<br /><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1GetOrderHistoryTradeLockerPost({
    required enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus?
        accountStatus,
    required int? id,
    required DateTime? from,
    required DateTime? to,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetOrderHistoryTradeLockerPost(
        accountStatus: accountStatus?.value?.toString(),
        id: id,
        from: from,
        to: to);
  }

  ///Get Order History for TradeLocker
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param id The ID of the account for which to retrieve order history.<br /><br/>
  ///@param from The start date for the order history.<br /><br/>
  ///@param to The end date for the order history.<br /><br/>
  @Post(
    path: '/api/v1/get_order_history_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1GetOrderHistoryTradeLockerPost({
    @Query('accountStatus') required String? accountStatus,
    @Query('id') required int? id,
    @Query('from') required DateTime? from,
    @Query('to') required DateTime? to,
  });

  ///Modify Position for TradeLocker
  ///@param ticket The ticket ID (e.g., 12345) of the order to modify.<br /><br/>
  ///@param userId The userId of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response<StringResponseDto>>
      apiV1ModifyPositionTradeLockerPost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required enums.ApiV1ModifyPositionTradeLockerPostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ModifyPositionTradeLockerPost(
        ticket: ticket,
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify Position for TradeLocker
  ///@param ticket The ticket ID (e.g., 12345) of the order to modify.<br /><br/>
  ///@param userId The userId of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/modify_position_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ModifyPositionTradeLockerPost({
    @Query('ticket') required int? ticket,
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Order for TradeLocker
  ///@param userId The userId of the user closing the order. (e.g., 12345).<br /><br/>
  ///@param ticket The ticket ID of the position to close. (e.g., 12345).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1ClosePositionTradeLockerPost({
    required int? userId,
    required int? ticket,
    required enums.ApiV1ClosePositionTradeLockerPostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ClosePositionTradeLockerPost(
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Order for TradeLocker
  ///@param userId The userId of the user closing the order. (e.g., 12345).<br /><br/>
  ///@param ticket The ticket ID of the position to close. (e.g., 12345).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/close_position_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ClosePositionTradeLockerPost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Partially Close an Postion for TradeLocker
  ///@param userId The userId of the user closing the partially order.(e.g., 12345).
  ///@param ticket The ticket ID of the order to partially close. (e.g., 12345)
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response> apiV1PartialCloseTradeLockerPostionPost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus?
        accountStatus,
  }) {
    return _apiV1PartialCloseTradeLockerPostionPost(
        userId: userId,
        ticket: ticket,
        lots: lots,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Partially Close an Postion for TradeLocker
  ///@param userId The userId of the user closing the partially order.(e.g., 12345).
  ///@param ticket The ticket ID of the order to partially close. (e.g., 12345)
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/partial_Close_tradeLocker_postion',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1PartialCloseTradeLockerPostionPost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('lots') required num? lots,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders for TradeLocker
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrdersForTradeLockerPost({
    required int? userid,
    required enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus?
        accountStatus,
  }) {
    return _apiV1CloseAllOrdersForTradeLockerPost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders for TradeLocker
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrdersForTradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrdersForTradeLockerPost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders by Symbol for TradeLocker
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<CancelDto>>
      apiV1CloseAllOrderBySymbolForTradeLockerPost({
    required int? userid,
    required String? symbol,
    required enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(CancelDto, () => CancelDto.fromJsonFactory);

    return _apiV1CloseAllOrderBySymbolForTradeLockerPost(
        userid: userid,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders by Symbol for TradeLocker
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySymbolForTradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<CancelDto>>
      _apiV1CloseAllOrderBySymbolForTradeLockerPost({
    @Query('userid') required int? userid,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Sell Orders for TradeLocker
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1CloseAllOrderBySellForTradeLockerPost({
    required int? userid,
    required enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1CloseAllOrderBySellForTradeLockerPost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Sell Orders for TradeLocker
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySellForTradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1CloseAllOrderBySellForTradeLockerPost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Buy Orders for TradeLocker
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1CloseAllOrderByBuyForTradeLockerPost({
    required int? userid,
    required enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1CloseAllOrderByBuyForTradeLockerPost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Buy Orders for TradeLocker
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderByBuyForTradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1CloseAllOrderByBuyForTradeLockerPost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Send pending Order for TradeLocker
  ///@param userId The userId of the user placing the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1SendPendingOrderTradeLockerPost({
    required int? userId,
    required String? side,
    required String? type,
    required num? lots,
    required String? symbol,
    required num? price,
    num? stopLoss,
    num? takeProfit,
    required enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendPendingOrderTradeLockerPost(
        userId: userId,
        side: side,
        type: type,
        lots: lots,
        symbol: symbol,
        price: price,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Send pending Order for TradeLocker
  ///@param userId The userId of the user placing the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/send_pending_order_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1SendPendingOrderTradeLockerPost({
    @Query('userId') required int? userId,
    @Query('Side') required String? side,
    @Query('Type') required String? type,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('price') required num? price,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Modify pending order for TradeLocker
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response<StringResponseDto>>
      apiV1ModifyPendingOrderTradeLockerPost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required num? price,
    required num? lots,
    required String? type,
    required enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ModifyPendingOrderTradeLockerPost(
        ticket: ticket,
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        price: price,
        lots: lots,
        type: type,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify pending order for TradeLocker
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/modify_pendingOrder_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ModifyPendingOrderTradeLockerPost({
    @Query('ticket') required int? ticket,
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('price') required num? price,
    @Query('lots') required num? lots,
    @Query('Type') required String? type,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Pending Order for TradeLocker
  ///@param userId The ID of the user closing the pending order. Default value is 123456.<br  /><br/>
  ///@param ticket The ticket ID of the pending order to close. Default value is 1234.<br  /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1ClosePendingOrderTradeLockerPost({
    required int? userId,
    required int? ticket,
    required enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ClosePendingOrderTradeLockerPost(
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Pending Order for TradeLocker
  ///@param userId The ID of the user closing the pending order. Default value is 123456.<br  /><br/>
  ///@param ticket The ticket ID of the pending order to close. Default value is 1234.<br  /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/close_pending_order_tradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ClosePendingOrderTradeLockerPost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveMasterTradeLockerPost({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveMasterTradeLockerPost(id: id, status: status);
  }

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_master_TradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ActiveMasterTradeLockerPost({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveSlaveTradeLockerPost({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveSlaveTradeLockerPost(id: id, status: status);
  }

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_slave_TradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveSlaveTradeLockerPost({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  Future<chopper.Response> apiV1SymbolMapTradeLockerPost({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    return _apiV1SymbolMapTradeLockerPost(
        userid: userid,
        sourceSymbol: sourceSymbol,
        followSymbol: followSymbol,
        type: type);
  }

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  @Post(
    path: '/api/v1/symbol_map_TradeLocker',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1SymbolMapTradeLockerPost({
    @Query('userid') required int? userid,
    @Query('sourceSymbol') required String? sourceSymbol,
    @Query('followSymbol') required String? followSymbol,
    @Query('type') required String? type,
  });

  ///Get Suffix Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSuffixTradeLockerUserIdGet(
      {required int? userId}) {
    return _apiV1GetSuffixTradeLockerUserIdGet(userId: userId);
  }

  ///Get Suffix Symbols
  ///@param userId
  @Get(path: '/api/v1/getSuffixTradeLocker/{userId}')
  Future<chopper.Response> _apiV1GetSuffixTradeLockerUserIdGet(
      {@Path('userId') required int? userId});

  ///Get Special Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSpecialTradeLockerUserIdGet(
      {required int? userId}) {
    return _apiV1GetSpecialTradeLockerUserIdGet(userId: userId);
  }

  ///Get Special Symbols
  ///@param userId
  @Get(path: '/api/v1/getSpecialTradeLocker/{userId}')
  Future<chopper.Response> _apiV1GetSpecialTradeLockerUserIdGet(
      {@Path('userId') required int? userId});

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  Future<chopper.Response<Risk>> apiV1TradeLockerGetRiskGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(Risk, () => Risk.fromJsonFactory);

    return _apiV1TradeLockerGetRiskGet(userId: userId);
  }

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  @Get(path: '/api/v1/TradeLocker/getRisk')
  Future<chopper.Response<Risk>> _apiV1TradeLockerGetRiskGet(
      {@Query('userId') required int? userId});

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  Future<chopper.Response> apiV1TradeLockerUpdateRiskPost({
    required int? userId,
    required enums.ApiV1TradeLockerUpdateRiskPostRiskType? riskType,
    required num? multiplier,
  }) {
    return _apiV1TradeLockerUpdateRiskPost(
        userId: userId,
        riskType: riskType?.value?.toString(),
        multiplier: multiplier);
  }

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  @Post(
    path: '/api/v1/TradeLocker/updateRisk',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1TradeLockerUpdateRiskPost({
    @Query('userId') required int? userId,
    @Query('riskType') required String? riskType,
    @Query('multiplier') required num? multiplier,
  });

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  Future<chopper.Response<StopsLimits>> apiV1TradeLockerGetStopsLimitsGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(
        StopsLimits, () => StopsLimits.fromJsonFactory);

    return _apiV1TradeLockerGetStopsLimitsGet(userId: userId);
  }

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  @Get(path: '/api/v1/TradeLocker/getStopsLimits')
  Future<chopper.Response<StopsLimits>> _apiV1TradeLockerGetStopsLimitsGet(
      {@Query('userId') required int? userId});

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  Future<chopper.Response> apiV1TradeLockerUpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode?
        scalperMode,
    required enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter?
        orderFilter,
    required int? scalperValue,
  }) {
    return _apiV1TradeLockerUpdateStopsLimitsPost(
        userId: userId,
        copySLTP: copySLTP,
        scalperMode: scalperMode?.value?.toString(),
        orderFilter: orderFilter?.value?.toString(),
        scalperValue: scalperValue);
  }

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  @Post(
    path: '/api/v1/TradeLocker/updateStopsLimits',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1TradeLockerUpdateStopsLimitsPost({
    @Query('userId') required int? userId,
    @Query('copySLTP') required bool? copySLTP,
    @Query('scalperMode') required String? scalperMode,
    @Query('orderFilter') required String? orderFilter,
    @Query('scalperValue') required int? scalperValue,
  });

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for. <br/><br/>
  Future<chopper.Response<FollowRiskSetting>>
      apiV1TradeLockerGetOrderControlSettingsGet({required int? userId}) {
    generatedMapping.putIfAbsent(
        FollowRiskSetting, () => FollowRiskSetting.fromJsonFactory);

    return _apiV1TradeLockerGetOrderControlSettingsGet(userId: userId);
  }

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for. <br/><br/>
  @Get(path: '/api/v1/TradeLocker/getOrderControlSettings')
  Future<chopper.Response<FollowRiskSetting>>
      _apiV1TradeLockerGetOrderControlSettingsGet(
          {@Query('userId') required int? userId});

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  Future<chopper.Response> apiV1TradeLockerUpdateOrderControlSettingPost({
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
    return _apiV1TradeLockerUpdateOrderControlSettingPost(
        userId: userId,
        profitOverPoint: profitOverPoint,
        lossOverPoint: lossOverPoint,
        profitForEveryOrder: profitForEveryOrder,
        lossForEveryOrder: lossForEveryOrder,
        profitForAllOrder: profitForAllOrder,
        lossForAllOrder: lossForAllOrder,
        equityUnderLow: equityUnderLow,
        equityUnderHigh: equityUnderHigh,
        pendingOrderProfitPoint: pendingOrderProfitPoint,
        pendingOrderLossPoint: pendingOrderLossPoint,
        pendingTimeout: pendingTimeout);
  }

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  @Post(
    path: '/api/v1/TradeLocker/updateOrderControlSetting',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1TradeLockerUpdateOrderControlSettingPost({
    @Query('userId') required int? userId,
    @Query('profitOverPoint') required int? profitOverPoint,
    @Query('lossOverPoint') required int? lossOverPoint,
    @Query('profitForEveryOrder') required int? profitForEveryOrder,
    @Query('lossForEveryOrder') required int? lossForEveryOrder,
    @Query('profitForAllOrder') required int? profitForAllOrder,
    @Query('lossForAllOrder') required int? lossForAllOrder,
    @Query('equityUnderLow') required int? equityUnderLow,
    @Query('equityUnderHigh') required int? equityUnderHigh,
    @Query('pendingOrderProfitPoint') required int? pendingOrderProfitPoint,
    @Query('pendingOrderLossPoint') required int? pendingOrderLossPoint,
    @Query('pendingTimeout') required int? pendingTimeout,
  });

  ///Get All Symbols
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId
  Future<chopper.Response<StringResponseDto>>
      apiV1GetAllSymbolTradeLockerUserIdGet({
    required enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus?
        accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetAllSymbolTradeLockerUserIdGet(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Get All Symbols
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId
  @Get(path: '/api/v1/getAllSymbol/TradeLocker/{userId}')
  Future<chopper.Response<StringResponseDto>>
      _apiV1GetAllSymbolTradeLockerUserIdGet({
    @Query('accountStatus') required String? accountStatus,
    @Path('userId') required int? userId,
  });

  ///Register Master Account for MatchTrade
  ///@param userId The userId of the master account.
  ///@param emailId The email ID for the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MatchTrade account.
  ///@param brokerId Optional broker ID of the master MatchTrade account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>>
      apiV1RegisterMasterMatchTradePost({
    required int? userId,
    required String? emailId,
    required String? password,
    required String? server,
    String? brokerId,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterMasterMatchTradePost(
        userId: userId,
        emailId: emailId,
        password: password,
        server: server,
        brokerId: brokerId,
        comment: comment);
  }

  ///Register Master Account for MatchTrade
  ///@param userId The userId of the master account.
  ///@param emailId The email ID for the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MatchTrade account.
  ///@param brokerId Optional broker ID of the master MatchTrade account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/register_master_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1RegisterMasterMatchTradePost({
    @Query('userId') required int? userId,
    @Query('emailId') required String? emailId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('brokerId') String? brokerId,
    @Query('comment') String? comment,
  });

  ///Register Slave Account for MatchTrade
  ///@param userId The userId of the Slave account.
  ///@param emailId The email ID for the Slave account.
  ///@param password The password for the Slave account.
  ///@param server The server name for the MatchTrade account.
  ///@param brokerId Optional broker ID of the slave MatchTrade account.
  ///@param comment Optional comment for the registration.
  ///@param masterAcountId The master userId associated with the slave account.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1RegisterSlaveMatchTradePost({
    required int? userId,
    required String? emailId,
    required String? password,
    required String? server,
    String? brokerId,
    String? comment,
    required int? masterAcountId,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1RegisterSlaveMatchTradePost(
        userId: userId,
        emailId: emailId,
        password: password,
        server: server,
        brokerId: brokerId,
        comment: comment,
        masterAcountId: masterAcountId);
  }

  ///Register Slave Account for MatchTrade
  ///@param userId The userId of the Slave account.
  ///@param emailId The email ID for the Slave account.
  ///@param password The password for the Slave account.
  ///@param server The server name for the MatchTrade account.
  ///@param brokerId Optional broker ID of the slave MatchTrade account.
  ///@param comment Optional comment for the registration.
  ///@param masterAcountId The master userId associated with the slave account.<br /><br/>
  @Post(
    path: '/api/v1/register_slave_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1RegisterSlaveMatchTradePost({
    @Query('userId') required int? userId,
    @Query('emailId') required String? emailId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('brokerId') String? brokerId,
    @Query('comment') String? comment,
    @Query('masterAcountId') required int? masterAcountId,
  });

  ///Update Master Account for MatchTrade
  ///@param userId The Account ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MatchTrade account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1UpdateMasterMatchTradePost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateMasterMatchTradePost(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Update Master Account for MatchTrade
  ///@param userId The Account ID of the master account.
  ///@param password The password for the master account.
  ///@param server The server name for the MatchTrade account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/update_master_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateMasterMatchTradePost({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Update Slave Account for MatchTrade
  ///@param userId The Account ID of the slave account.
  ///@param password The password for the slave account.
  ///@param server The server name for the MatchTrade account.
  ///@param comment Optional comment for the registration.
  Future<chopper.Response<StringResponseDto>> apiV1UpdateSlaveMatchTradePost({
    required int? userId,
    required String? password,
    required String? server,
    String? comment,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1UpdateSlaveMatchTradePost(
        userId: userId, password: password, server: server, comment: comment);
  }

  ///Update Slave Account for MatchTrade
  ///@param userId The Account ID of the slave account.
  ///@param password The password for the slave account.
  ///@param server The server name for the MatchTrade account.
  ///@param comment Optional comment for the registration.
  @Post(
    path: '/api/v1/update_slave_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1UpdateSlaveMatchTradePost({
    @Query('userId') required int? userId,
    @Query('password') required String? password,
    @Query('server') required String? server,
    @Query('comment') String? comment,
  });

  ///Send New Position for MatchTrade
  ///@param userId The userId of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1SendPositionMatchTradePost({
    required int? userId,
    required String? orderType,
    required num? lots,
    required String? symbol,
    num? stopLoss,
    num? takeProfit,
    required enums.ApiV1SendPositionMatchTradePostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendPositionMatchTradePost(
        userId: userId,
        orderType: orderType,
        lots: lots,
        symbol: symbol,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Send New Position for MatchTrade
  ///@param userId The userId of the user placing the order.<br /><br/>
  ///@param orderType The type of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/send_position_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1SendPositionMatchTradePost({
    @Query('userId') required int? userId,
    @Query('orderType') required String? orderType,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Fetch Orders for MatchTrade
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The userId of the user for which to retrieve positions.<br /><br/>
  Future<chopper.Response<MT4OrderDtoListResponseDto>>
      apiV1GetOrdersMatchTradePost({
    required enums.ApiV1GetOrdersMatchTradePostAccountStatus? accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(MT4OrderDtoListResponseDto,
        () => MT4OrderDtoListResponseDto.fromJsonFactory);

    return _apiV1GetOrdersMatchTradePost(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Fetch Orders for MatchTrade
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId The userId of the user for which to retrieve positions.<br /><br/>
  @Post(
    path: '/api/v1/get_orders_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<MT4OrderDtoListResponseDto>>
      _apiV1GetOrdersMatchTradePost({
    @Query('accountStatus') required String? accountStatus,
    @Query('userId') required int? userId,
  });

  ///Modify Position for MatchTrade
  ///@param ticket The ticket ID (e.g., 12345) of the order to modify.<br /><br/>
  ///@param userId The userId of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response<StringResponseDto>>
      apiV1ModifyPositionMatchTradePost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required String? side,
    required num? lots,
    required String? symbol,
    required enums.ApiV1ModifyPositionMatchTradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ModifyPositionMatchTradePost(
        ticket: ticket,
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        side: side,
        lots: lots,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify Position for MatchTrade
  ///@param ticket The ticket ID (e.g., 12345) of the order to modify.<br /><br/>
  ///@param userId The userId of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/modify_position_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ModifyPositionMatchTradePost({
    @Query('ticket') required int? ticket,
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('Side') required String? side,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Order for MatchTrade
  ///@param userId The userId of the user closing the order. (e.g., 12345).<br /><br/>
  ///@param ticket The ticket ID of the order to close. (e.g., 12345).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ClosePositionMatchTradePost({
    required int? userId,
    required int? ticket,
    required enums.ApiV1ClosePositionMatchTradePostAccountStatus? accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ClosePositionMatchTradePost(
        userId: userId,
        ticket: ticket,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Order for MatchTrade
  ///@param userId The userId of the user closing the order. (e.g., 12345).<br /><br/>
  ///@param ticket The ticket ID of the order to close. (e.g., 12345).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/close_position_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ClosePositionMatchTradePost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Partially Close an Postion for MatchTrade
  ///@param userId The userId of the user closing the partially order.(e.g., 12345).
  ///@param ticket The ticket ID of the order to partially close. (e.g., 12345)
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response> apiV1PartialCloseMatchTradePostionPost({
    required int? userId,
    required int? ticket,
    required num? lots,
    required String? symbol,
    required String? side,
    required enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus?
        accountStatus,
  }) {
    return _apiV1PartialCloseMatchTradePostionPost(
        userId: userId,
        ticket: ticket,
        lots: lots,
        symbol: symbol,
        side: side,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Partially Close an Postion for MatchTrade
  ///@param userId The userId of the user closing the partially order.(e.g., 12345).
  ///@param ticket The ticket ID of the order to partially close. (e.g., 12345)
  ///@param lots The volume of lots to partially close. Default value is 0.01.
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/partial_Close_MatchTrade_Postion',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1PartialCloseMatchTradePostionPost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('Side') required String? side,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders for MatchTrade
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response> apiV1CloseAllOrdersForMatchtradePost({
    required int? userid,
    required enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus?
        accountStatus,
  }) {
    return _apiV1CloseAllOrdersForMatchtradePost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders for MatchTrade
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrdersForMatchtrade',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1CloseAllOrdersForMatchtradePost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Orders by Symbol for MatchTrade
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<CancelDto>>
      apiV1CloseAllOrderBySymbolForMatchtradePost({
    required int? userid,
    required String? symbol,
    required enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(CancelDto, () => CancelDto.fromJsonFactory);

    return _apiV1CloseAllOrderBySymbolForMatchtradePost(
        userid: userid,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Orders by Symbol for MatchTrade
  ///@param userid The user ID associated with the order.<br/><br/>
  ///@param symbol The trading symbol for the order (e.g., EURUSD).<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySymbolForMatchtrade',
    optionalBody: true,
  )
  Future<chopper.Response<CancelDto>>
      _apiV1CloseAllOrderBySymbolForMatchtradePost({
    @Query('userid') required int? userid,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Sell Orders for MatchTrade
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1CloseAllOrderBySellForMatchTradePost({
    required int? userid,
    required enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1CloseAllOrderBySellForMatchTradePost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Sell Orders for MatchTrade
  ///@param userid The user ID associated with the sell order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderBySellForMatchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1CloseAllOrderBySellForMatchTradePost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close All Buy Orders for MatchTrade
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1CloseAllOrderByBuyForMatchTradePost({
    required int? userid,
    required enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1CloseAllOrderByBuyForMatchTradePost(
        userid: userid, accountStatus: accountStatus?.value?.toString());
  }

  ///Close All Buy Orders for MatchTrade
  ///@param userid The user ID associated with the buy order.<br/><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br/><br/>
  @Post(
    path: '/api/v1/CloseAllOrderByBuyForMatchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1CloseAllOrderByBuyForMatchTradePost({
    @Query('userid') required int? userid,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Send pending Order for MatchTrade
  ///@param userId The userId of the user placing the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1SendPendingOrderMatchTradePost({
    required int? userId,
    required String? side,
    required String? type,
    required num? lots,
    required String? symbol,
    required num? price,
    num? stopLoss,
    num? takeProfit,
    required enums.ApiV1SendPendingOrderMatchTradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1SendPendingOrderMatchTradePost(
        userId: userId,
        side: side,
        type: type,
        lots: lots,
        symbol: symbol,
        price: price,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Send pending Order for MatchTrade
  ///@param userId The userId of the user placing the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param stopLoss The Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The Take Profit value for the order.<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster or ExistsAsSlave).<br /><br/>
  @Post(
    path: '/api/v1/send_pending_order_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1SendPendingOrderMatchTradePost({
    @Query('userId') required int? userId,
    @Query('Side') required String? side,
    @Query('Type') required String? type,
    @Query('lots') required num? lots,
    @Query('symbol') required String? symbol,
    @Query('price') required num? price,
    @Query('stopLoss') num? stopLoss,
    @Query('takeProfit') num? takeProfit,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Modify pending order for MatchTrade
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  Future<chopper.Response<StringResponseDto>>
      apiV1ModifyPendingOrderMatchTradePost({
    required int? ticket,
    required int? userId,
    required num? stopLoss,
    required num? takeProfit,
    required num? price,
    required num? lots,
    required String? side,
    required String? type,
    required String? symbol,
    required enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ModifyPendingOrderMatchTradePost(
        ticket: ticket,
        userId: userId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
        price: price,
        lots: lots,
        side: side,
        type: type,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Modify pending order for MatchTrade
  ///@param ticket The ticket ID of the order to modify.<br /><br/>
  ///@param userId The ID of the user modifying the order.<br /><br/>
  ///@param stopLoss The new Stop Loss value for the order.<br /><br/>
  ///@param takeProfit The new Take Profit value for the order.<br /><br/>
  ///@param price The price for the order.<br /><br/>
  ///@param lots The lot size of the order.<br /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.
  @Post(
    path: '/api/v1/modify_pendingOrder_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ModifyPendingOrderMatchTradePost({
    @Query('ticket') required int? ticket,
    @Query('userId') required int? userId,
    @Query('stopLoss') required num? stopLoss,
    @Query('takeProfit') required num? takeProfit,
    @Query('price') required num? price,
    @Query('lots') required num? lots,
    @Query('Side') required String? side,
    @Query('Type') required String? type,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Close Pending Order for MatchTrade
  ///@param userId The ID of the user closing the pending order. Default value is 123456.<br  /><br/>
  ///@param ticket The ticket ID of the pending order to close. Default value is 1234.<br  /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  Future<chopper.Response<StringResponseDto>>
      apiV1ClosePendingOrderMatchTradePost({
    required int? userId,
    required int? ticket,
    required String? side,
    required String? type,
    required String? symbol,
    required enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus?
        accountStatus,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ClosePendingOrderMatchTradePost(
        userId: userId,
        ticket: ticket,
        side: side,
        type: type,
        symbol: symbol,
        accountStatus: accountStatus?.value?.toString());
  }

  ///Close Pending Order for MatchTrade
  ///@param userId The ID of the user closing the pending order. Default value is 123456.<br  /><br/>
  ///@param ticket The ticket ID of the pending order to close. Default value is 1234.<br  /><br/>
  ///@param Side The Side of order (e.g., BUY, SELL).<br /><br/>
  ///@param Type The type of order (e.g., STOP, LIMIT).<br /><br/>
  ///@param symbol The symbol for the order (e.g., EURUSD).<br /><br/>
  ///@param accountStatus The account status (e.g., ExistsAsMaster). Default value is  'ExistsAsMaster'.<br /><br/>
  @Post(
    path: '/api/v1/close_pending_order_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>>
      _apiV1ClosePendingOrderMatchTradePost({
    @Query('userId') required int? userId,
    @Query('ticket') required int? ticket,
    @Query('Side') required String? side,
    @Query('Type') required String? type,
    @Query('symbol') required String? symbol,
    @Query('accountStatus') required String? accountStatus,
  });

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveMasterMatchTradePost({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveMasterMatchTradePost(id: id, status: status);
  }

  ///Activate/Deactivate Master Account
  ///@param id The ID of the master account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the master account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_master_matchTrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveMasterMatchTradePost({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  Future<chopper.Response<StringResponseDto>> apiV1ActiveSlaveMatchtradePost({
    required int? id,
    required bool? status,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1ActiveSlaveMatchtradePost(id: id, status: status);
  }

  ///Activate/Deactivate Slave Account
  ///@param id The ID of the slave account to be activated or deactivated.<br/><br/>
  ///@param status The status to set for the slave account (true for active, false for  inactive).<br/><br/>
  @Post(
    path: '/api/v1/active_slave_matchtrade',
    optionalBody: true,
  )
  Future<chopper.Response<StringResponseDto>> _apiV1ActiveSlaveMatchtradePost({
    @Query('id') required int? id,
    @Query('status') required bool? status,
  });

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  Future<chopper.Response> apiV1SymbolMapMatchtradePost({
    required int? userid,
    required String? sourceSymbol,
    required String? followSymbol,
    required String? type,
  }) {
    return _apiV1SymbolMapMatchtradePost(
        userid: userid,
        sourceSymbol: sourceSymbol,
        followSymbol: followSymbol,
        type: type);
  }

  ///Add Symbol Mapping
  ///@param userid The user ID creating the symbol mapping.<br/><br/>
  ///@param sourceSymbol The source symbol name.<br/><br/>
  ///@param followSymbol The follow symbol name.<br/><br/>
  ///@param type The mapping type ('Suffix' or 'Special').<br/><br/>
  @Post(
    path: '/api/v1/symbol_map_matchtrade',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1SymbolMapMatchtradePost({
    @Query('userid') required int? userid,
    @Query('sourceSymbol') required String? sourceSymbol,
    @Query('followSymbol') required String? followSymbol,
    @Query('type') required String? type,
  });

  ///Get Suffix Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSuffixMatchTradeUserIdGet(
      {required int? userId}) {
    return _apiV1GetSuffixMatchTradeUserIdGet(userId: userId);
  }

  ///Get Suffix Symbols
  ///@param userId
  @Get(path: '/api/v1/getSuffixMatchTrade/{userId}')
  Future<chopper.Response> _apiV1GetSuffixMatchTradeUserIdGet(
      {@Path('userId') required int? userId});

  ///Get Special Symbols
  ///@param userId
  Future<chopper.Response> apiV1GetSpecialMatchTradeUserIdGet(
      {required int? userId}) {
    return _apiV1GetSpecialMatchTradeUserIdGet(userId: userId);
  }

  ///Get Special Symbols
  ///@param userId
  @Get(path: '/api/v1/getSpecialMatchTrade/{userId}')
  Future<chopper.Response> _apiV1GetSpecialMatchTradeUserIdGet(
      {@Path('userId') required int? userId});

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  Future<chopper.Response<Risk>> apiV1MatchTradeGetRiskGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(Risk, () => Risk.fromJsonFactory);

    return _apiV1MatchTradeGetRiskGet(userId: userId);
  }

  ///Get Risk Setting For Follow account.
  ///@param userId The ID of the user to fetch risk details for userId: {userId} .<br/><br/>
  @Get(path: '/api/v1/MatchTrade/getRisk')
  Future<chopper.Response<Risk>> _apiV1MatchTradeGetRiskGet(
      {@Query('userId') required int? userId});

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  Future<chopper.Response> apiV1MatchTradeUpdateRiskPost({
    required int? userId,
    required enums.ApiV1MatchTradeUpdateRiskPostRiskType? riskType,
    required num? multiplier,
  }) {
    return _apiV1MatchTradeUpdateRiskPost(
        userId: userId,
        riskType: riskType?.value?.toString(),
        multiplier: multiplier);
  }

  ///Update Risk Setting For Follow account.
  ///@param userId The ID of the risk to update.<br/><br/>
  ///@param riskType The new risk type for the user. (Dropdown: 0 = Risk multiplier by equity, 1  = Lot multiplier, 2 = Fixed lot, 3 = Auto risk)<br/><br/>
  ///@param multiplier The new multiplier value for the user.<br/><br/>
  @Post(
    path: '/api/v1/MatchTrade/updateRisk',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1MatchTradeUpdateRiskPost({
    @Query('userId') required int? userId,
    @Query('riskType') required String? riskType,
    @Query('multiplier') required num? multiplier,
  });

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  Future<chopper.Response<StopsLimits>> apiV1MatchTradeGetStopsLimitsGet(
      {required int? userId}) {
    generatedMapping.putIfAbsent(
        StopsLimits, () => StopsLimits.fromJsonFactory);

    return _apiV1MatchTradeGetStopsLimitsGet(userId: userId);
  }

  ///Get Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the account to fetch stops and limits details for.<br/><br/>
  @Get(path: '/api/v1/MatchTrade/getStopsLimits')
  Future<chopper.Response<StopsLimits>> _apiV1MatchTradeGetStopsLimitsGet(
      {@Query('userId') required int? userId});

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  Future<chopper.Response> apiV1MatchTradeUpdateStopsLimitsPost({
    required int? userId,
    required bool? copySLTP,
    required enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode? scalperMode,
    required enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter? orderFilter,
    required int? scalperValue,
  }) {
    return _apiV1MatchTradeUpdateStopsLimitsPost(
        userId: userId,
        copySLTP: copySLTP,
        scalperMode: scalperMode?.value?.toString(),
        orderFilter: orderFilter?.value?.toString(),
        scalperValue: scalperValue);
  }

  ///Update Stop Loss/Take profit Setting For Follow account.
  ///@param userId The ID of the user to update stops and limits details. <br/><br/>
  ///@param copySLTP The updated Stop Loss/Take Profit copy status.<br/><br/>
  ///@param scalperMode The updated scalper mode value. (Dropdown: 0 = Off, 1 = Permanent  Scalp-Mode, 2 = Rollover Scalp-Mode)<br/><br/>
  ///@param orderFilter The updated order filter type. (Dropdown: 0 = Copy buy & sell orders, 1 =  Copy buy order only, 2 = Copy sell order only, 3 = Copy all orders)<br/><br/>
  ///@param scalperValue The updated scalper rollover value.<br/><br/>
  @Post(
    path: '/api/v1/MatchTrade/updateStopsLimits',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1MatchTradeUpdateStopsLimitsPost({
    @Query('userId') required int? userId,
    @Query('copySLTP') required bool? copySLTP,
    @Query('scalperMode') required String? scalperMode,
    @Query('orderFilter') required String? orderFilter,
    @Query('scalperValue') required int? scalperValue,
  });

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for. <br/><br/>
  Future<chopper.Response<FollowRiskSetting>>
      apiV1MatchTradeGetOrderControlSettingsGet({required int? userId}) {
    generatedMapping.putIfAbsent(
        FollowRiskSetting, () => FollowRiskSetting.fromJsonFactory);

    return _apiV1MatchTradeGetOrderControlSettingsGet(userId: userId);
  }

  ///Get Order Control Setting For Follow account.
  ///@param userId The ID to fetch follow risk settings for. <br/><br/>
  @Get(path: '/api/v1/MatchTrade/getOrderControlSettings')
  Future<chopper.Response<FollowRiskSetting>>
      _apiV1MatchTradeGetOrderControlSettingsGet(
          {@Query('userId') required int? userId});

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  Future<chopper.Response> apiV1MatchTradeUpdateOrderControlSettingPost({
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
    return _apiV1MatchTradeUpdateOrderControlSettingPost(
        userId: userId,
        profitOverPoint: profitOverPoint,
        lossOverPoint: lossOverPoint,
        profitForEveryOrder: profitForEveryOrder,
        lossForEveryOrder: lossForEveryOrder,
        profitForAllOrder: profitForAllOrder,
        lossForAllOrder: lossForAllOrder,
        equityUnderLow: equityUnderLow,
        equityUnderHigh: equityUnderHigh,
        pendingOrderProfitPoint: pendingOrderProfitPoint,
        pendingOrderLossPoint: pendingOrderLossPoint,
        pendingTimeout: pendingTimeout);
  }

  ///Update Order Control Setting For Follow account.
  ///@param userId The ID of the follow risk setting to update.<br/><br/>
  ///@param profitOverPoint The updated close profit point high value.<br/><br/>
  ///@param lossOverPoint The updated close loss point high value.<br/><br/>
  ///@param profitForEveryOrder The updated close profit high value.<br/><br/>
  ///@param lossForEveryOrder The updated close loss high value.<br/><br/>
  ///@param profitForAllOrder The updated close all profit high value.<br/><br/>
  ///@param lossForAllOrder The updated close all loss high value.<br/><br/>
  ///@param equityUnderLow The updated close all equity low value.<br/><br/>
  ///@param equityUnderHigh The updated close all equity high value.<br/><br/>
  ///@param pendingOrderProfitPoint The updated source pending profit point close follow value.<br/><br/>
  ///@param pendingOrderLossPoint The updated source pending loss point close follow value.<br/><br/>
  ///@param pendingTimeout The updated source pending timeout close follow value (in  minutes).<br/><br/>
  @Post(
    path: '/api/v1/MatchTrade/updateOrderControlSetting',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1MatchTradeUpdateOrderControlSettingPost({
    @Query('userId') required int? userId,
    @Query('profitOverPoint') required int? profitOverPoint,
    @Query('lossOverPoint') required int? lossOverPoint,
    @Query('profitForEveryOrder') required int? profitForEveryOrder,
    @Query('lossForEveryOrder') required int? lossForEveryOrder,
    @Query('profitForAllOrder') required int? profitForAllOrder,
    @Query('lossForAllOrder') required int? lossForAllOrder,
    @Query('equityUnderLow') required int? equityUnderLow,
    @Query('equityUnderHigh') required int? equityUnderHigh,
    @Query('pendingOrderProfitPoint') required int? pendingOrderProfitPoint,
    @Query('pendingOrderLossPoint') required int? pendingOrderLossPoint,
    @Query('pendingTimeout') required int? pendingTimeout,
  });

  ///Get All Symbols
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId
  Future<chopper.Response<StringResponseDto>>
      apiV1GetAllSymbolMatchTradeUserIdGet({
    required enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus?
        accountStatus,
    required int? userId,
  }) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetAllSymbolMatchTradeUserIdGet(
        accountStatus: accountStatus?.value?.toString(), userId: userId);
  }

  ///Get All Symbols
  ///@param accountStatus The account status (e.g., ExistsAsMaster).<br /><br/>
  ///@param userId
  @Get(path: '/api/v1/getAllSymbol/MatchTrade/{userId}')
  Future<chopper.Response<StringResponseDto>>
      _apiV1GetAllSymbolMatchTradeUserIdGet({
    @Query('accountStatus') required String? accountStatus,
    @Path('userId') required int? userId,
  });

  ///Get All Details OF APIKEY
  ///@param userid The USerID  Key <br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1GetUserInfoGet(
      {required int? userid}) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetUserInfoGet(userid: userid);
  }

  ///Get All Details OF APIKEY
  ///@param userid The USerID  Key <br /><br/>
  @Get(path: '/api/v1/getUserInfo')
  Future<chopper.Response<StringResponseDto>> _apiV1GetUserInfoGet(
      {@Query('userid') required int? userid});

  ///Get Id For an account.
  ///@param userId The ID to fetch details for.
  Future<chopper.Response> apiV1GetIdGet({required int? userId}) {
    return _apiV1GetIdGet(userId: userId);
  }

  ///Get Id For an account.
  ///@param userId The ID to fetch details for.
  @Get(path: '/api/v1/get_id')
  Future<chopper.Response> _apiV1GetIdGet(
      {@Query('userId') required int? userId});

  ///Get All Details OF APIKEY
  ///@param key The API  Key <br /><br/>
  Future<chopper.Response<StringResponseDto>> apiV1GetAPIInfoGet(
      {required String? key}) {
    generatedMapping.putIfAbsent(
        StringResponseDto, () => StringResponseDto.fromJsonFactory);

    return _apiV1GetAPIInfoGet(key: key);
  }

  ///Get All Details OF APIKEY
  ///@param key The API  Key <br /><br/>
  @Get(path: '/api/v1/getAPIInfo')
  Future<chopper.Response<StringResponseDto>> _apiV1GetAPIInfoGet(
      {@Query('key') required String? key});

  ///Get Id For a account.
  ///@param userId The ID to fetch Detailsfor. <br/><br/>
  Future<chopper.Response<List<int>>> apiV1GetbyidGet({required int? userId}) {
    return _apiV1GetbyidGet(userId: userId);
  }

  ///Get Id For a account.
  ///@param userId The ID to fetch Detailsfor. <br/><br/>
  @Get(path: '/api/v1/getbyid')
  Future<chopper.Response<List<int>>> _apiV1GetbyidGet(
      {@Query('userId') required int? userId});

  ///Get Status For a account.
  ///@param userId The ID to fetch Status. <br/><br/>
  Future<chopper.Response<List<int>>> apiV1GetStatusGet(
      {required int? userId}) {
    return _apiV1GetStatusGet(userId: userId);
  }

  ///Get Status For a account.
  ///@param userId The ID to fetch Status. <br/><br/>
  @Get(path: '/api/v1/getStatus')
  Future<chopper.Response<List<int>>> _apiV1GetStatusGet(
      {@Query('userId') required int? userId});

  ///Delete follow account by ID.
  ///@param userId The ID of the account to delete.
  Future<chopper.Response<BooleanResponseDto>> apiV1FollowUserIdDelete(
      {required int? userId}) {
    generatedMapping.putIfAbsent(
        BooleanResponseDto, () => BooleanResponseDto.fromJsonFactory);

    return _apiV1FollowUserIdDelete(userId: userId);
  }

  ///Delete follow account by ID.
  ///@param userId The ID of the account to delete.
  @Delete(path: '/api/v1/follow/{userId}')
  Future<chopper.Response<BooleanResponseDto>> _apiV1FollowUserIdDelete(
      {@Path('userId') required int? userId});

  ///Delete source account by ID.
  ///@param userId The ID of the account to delete.
  Future<chopper.Response<BooleanResponseDto>> apiV1SourceUserIdDelete(
      {required int? userId}) {
    generatedMapping.putIfAbsent(
        BooleanResponseDto, () => BooleanResponseDto.fromJsonFactory);

    return _apiV1SourceUserIdDelete(userId: userId);
  }

  ///Delete source account by ID.
  ///@param userId The ID of the account to delete.
  @Delete(path: '/api/v1/source/{userId}')
  Future<chopper.Response<BooleanResponseDto>> _apiV1SourceUserIdDelete(
      {@Path('userId') required int? userId});

  ///Get Status For account IDs
  ///@param userId Account IDs to fetch Status.
  Future<chopper.Response<List<UserStatusDto>>> apiV1GetStatusbyIDGet(
      {required List<int>? userId}) {
    generatedMapping.putIfAbsent(
        UserStatusDto, () => UserStatusDto.fromJsonFactory);

    return _apiV1GetStatusbyIDGet(userId: userId);
  }

  ///Get Status For account IDs
  ///@param userId Account IDs to fetch Status.
  @Get(path: '/api/v1/getStatusbyID')
  Future<chopper.Response<List<UserStatusDto>>> _apiV1GetStatusbyIDGet(
      {@Query('userId') required List<int>? userId});
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
      chopper.Response response) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
          body: DateTime.parse((response.body as String).replaceAll('"', ''))
              as ResultType);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);
