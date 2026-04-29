// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooleanResponseDto _$BooleanResponseDtoFromJson(Map<String, dynamic> json) =>
    BooleanResponseDto(
      status: (json['status'] as num?)?.toInt(),
      data: json['data'],
      message: json['message'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      errorCode: json['errorCode'] as String?,
      baDRequest: json['baD_Request'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$BooleanResponseDtoToJson(BooleanResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
      'timestamp': instance.timestamp?.toIso8601String(),
      'errorCode': instance.errorCode,
      'baD_Request': instance.baDRequest,
      'success': instance.success,
    };

CancelDto _$CancelDtoFromJson(Map<String, dynamic> json) => CancelDto(
      ticket: (json['ticket'] as num?)?.toInt(),
      lots: (json['lots'] as num?)?.toDouble(),
      userid: (json['userid'] as num?)?.toInt(),
      symbol: json['symbol'] as String?,
      platformType: (json['platformType'] as num?)?.toInt(),
      accountStatus: (json['accountStatus'] as num?)?.toInt(),
      isPartially: json['isPartially'] as bool?,
      tradeSide: json['tradeSide'] as String?,
      tradeType: json['tradeType'] as String?,
    );

Map<String, dynamic> _$CancelDtoToJson(CancelDto instance) => <String, dynamic>{
      'ticket': instance.ticket,
      'lots': instance.lots,
      'userid': instance.userid,
      'symbol': instance.symbol,
      'platformType': instance.platformType,
      'accountStatus': instance.accountStatus,
      'isPartially': instance.isPartially,
      'tradeSide': instance.tradeSide,
      'tradeType': instance.tradeType,
    };

DxTradePositionDtoListResponseDto _$DxTradePositionDtoListResponseDtoFromJson(
        Map<String, dynamic> json) =>
    DxTradePositionDtoListResponseDto(
      status: (json['status'] as num?)?.toInt(),
      data: json['data'],
      message: json['message'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      errorCode: json['errorCode'] as String?,
      baDRequest: json['baD_Request'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$DxTradePositionDtoListResponseDtoToJson(
        DxTradePositionDtoListResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
      'timestamp': instance.timestamp?.toIso8601String(),
      'errorCode': instance.errorCode,
      'baD_Request': instance.baDRequest,
      'success': instance.success,
    };

FollowRiskSetting _$FollowRiskSettingFromJson(Map<String, dynamic> json) =>
    FollowRiskSetting(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      platformName: json['platformName'] as String?,
      updateStopLossTakeProfitStatus:
          (json['updateStopLossTakeProfitStatus'] as num?)?.toInt(),
      closeprofithigh: (json['closeprofithigh'] as num?)?.toDouble(),
      closeLossPointHigh: (json['closeLossPointHigh'] as num?)?.toDouble(),
      closelosshigh: (json['closelosshigh'] as num?)?.toDouble(),
      closeallprofithigh: (json['closeallprofithigh'] as num?)?.toDouble(),
      closealllosshigh: (json['closealllosshigh'] as num?)?.toDouble(),
      closeallequitylow: (json['closeallequitylow'] as num?)?.toDouble(),
      closeallequityhigh: (json['closeallequityhigh'] as num?)?.toDouble(),
      closeProfitPointHigh: (json['closeProfitPointHigh'] as num?)?.toDouble(),
      sourcePendingProfitPointCloseFollow:
          (json['sourcePendingProfitPointCloseFollow'] as num?)?.toDouble(),
      sourcePendingLossPointCloseFollow:
          (json['sourcePendingLossPointCloseFollow'] as num?)?.toDouble(),
      closePendingTimeOut: (json['closePendingTimeOut'] as num?)?.toDouble(),
      sourcePendingProfitPointCloseFollowFrom:
          (json['sourcePendingProfitPointCloseFollowFrom'] as num?)?.toDouble(),
      sourcePendingProfitPointCloseFollowTo:
          (json['sourcePendingProfitPointCloseFollowTo'] as num?)?.toDouble(),
      sourcePendingLossPointCloseFollowFrom:
          (json['sourcePendingLossPointCloseFollowFrom'] as num?)?.toDouble(),
      sourcePendingLossPointCloseFollowTo:
          (json['sourcePendingLossPointCloseFollowTo'] as num?)?.toDouble(),
      sourcePendingTimeoutCloseFollowFrom:
          (json['sourcePendingTimeoutCloseFollowFrom'] as num?)?.toDouble(),
      sourcePendingTimeoutCloseFollowTo:
          (json['sourcePendingTimeoutCloseFollowTo'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FollowRiskSettingToJson(FollowRiskSetting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'platformName': instance.platformName,
      'updateStopLossTakeProfitStatus': instance.updateStopLossTakeProfitStatus,
      'closeprofithigh': instance.closeprofithigh,
      'closeLossPointHigh': instance.closeLossPointHigh,
      'closelosshigh': instance.closelosshigh,
      'closeallprofithigh': instance.closeallprofithigh,
      'closealllosshigh': instance.closealllosshigh,
      'closeallequitylow': instance.closeallequitylow,
      'closeallequityhigh': instance.closeallequityhigh,
      'closeProfitPointHigh': instance.closeProfitPointHigh,
      'sourcePendingProfitPointCloseFollow':
          instance.sourcePendingProfitPointCloseFollow,
      'sourcePendingLossPointCloseFollow':
          instance.sourcePendingLossPointCloseFollow,
      'closePendingTimeOut': instance.closePendingTimeOut,
      'sourcePendingProfitPointCloseFollowFrom':
          instance.sourcePendingProfitPointCloseFollowFrom,
      'sourcePendingProfitPointCloseFollowTo':
          instance.sourcePendingProfitPointCloseFollowTo,
      'sourcePendingLossPointCloseFollowFrom':
          instance.sourcePendingLossPointCloseFollowFrom,
      'sourcePendingLossPointCloseFollowTo':
          instance.sourcePendingLossPointCloseFollowTo,
      'sourcePendingTimeoutCloseFollowFrom':
          instance.sourcePendingTimeoutCloseFollowFrom,
      'sourcePendingTimeoutCloseFollowTo':
          instance.sourcePendingTimeoutCloseFollowTo,
    };

MT4OrderDtoListResponseDto _$MT4OrderDtoListResponseDtoFromJson(
        Map<String, dynamic> json) =>
    MT4OrderDtoListResponseDto(
      status: (json['status'] as num?)?.toInt(),
      data: json['data'],
      message: json['message'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      errorCode: json['errorCode'] as String?,
      baDRequest: json['baD_Request'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$MT4OrderDtoListResponseDtoToJson(
        MT4OrderDtoListResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
      'timestamp': instance.timestamp?.toIso8601String(),
      'errorCode': instance.errorCode,
      'baD_Request': instance.baDRequest,
      'success': instance.success,
    };

Risk _$RiskFromJson(Map<String, dynamic> json) => Risk(
      riskType: (json['risk_type'] as num?)?.toInt(),
      multiplier: (json['multiplier'] as num?)?.toDouble(),
      id: (json['id'] as num?)?.toInt(),
      direction: (json['direction'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RiskToJson(Risk instance) => <String, dynamic>{
      'risk_type': instance.riskType,
      'multiplier': instance.multiplier,
      'id': instance.id,
      'direction': instance.direction,
    };

StopsLimits _$StopsLimitsFromJson(Map<String, dynamic> json) => StopsLimits(
      id: (json['id'] as num?)?.toInt(),
      copySLTP: json['copySLTP'] as bool?,
      orderLimit: json['orderLimit'] as bool?,
      limit: (json['limit'] as num?)?.toInt(),
      remaining: (json['remaining'] as num?)?.toInt(),
      copyOrderType: (json['copyOrderType'] as num?)?.toInt(),
      scalperMode: (json['scalperMode'] as num?)?.toInt(),
      scalperValue: (json['scalperValue'] as num?)?.toDouble(),
      splitOrder: json['splitOrder'] as bool?,
      splitValue: (json['splitValue'] as num?)?.toDouble(),
      orderFilter: (json['orderFilter'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StopsLimitsToJson(StopsLimits instance) =>
    <String, dynamic>{
      'id': instance.id,
      'copySLTP': instance.copySLTP,
      'orderLimit': instance.orderLimit,
      'limit': instance.limit,
      'remaining': instance.remaining,
      'copyOrderType': instance.copyOrderType,
      'scalperMode': instance.scalperMode,
      'scalperValue': instance.scalperValue,
      'splitOrder': instance.splitOrder,
      'splitValue': instance.splitValue,
      'orderFilter': instance.orderFilter,
    };

StringResponseDto _$StringResponseDtoFromJson(Map<String, dynamic> json) =>
    StringResponseDto(
      status: (json['status'] as num?)?.toInt(),
      data: json['data'],
      message: json['message'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      errorCode: json['errorCode'] as String?,
      baDRequest: json['baD_Request'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$StringResponseDtoToJson(StringResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
      'timestamp': instance.timestamp?.toIso8601String(),
      'errorCode': instance.errorCode,
      'baD_Request': instance.baDRequest,
      'success': instance.success,
    };

UserStatusDto _$UserStatusDtoFromJson(Map<String, dynamic> json) =>
    UserStatusDto(
      userId: (json['userId'] as num?)?.toInt(),
      managerStatus: (json['managerStatus'] as num?)?.toInt(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UserStatusDtoToJson(UserStatusDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'managerStatus': instance.managerStatus,
      'status': instance.status,
    };
