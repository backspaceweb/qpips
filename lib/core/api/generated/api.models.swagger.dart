// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'api.enums.swagger.dart' as enums;

part 'api.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class BooleanResponseDto {
  const BooleanResponseDto({
    this.status,
    this.data,
    this.message,
    this.timestamp,
    this.errorCode,
    this.baDRequest,
    this.success,
  });

  factory BooleanResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BooleanResponseDtoFromJson(json);

  static const toJsonFactory = _$BooleanResponseDtoToJson;
  Map<String, dynamic> toJson() => _$BooleanResponseDtoToJson(this);

  @JsonKey(name: 'status')
  final int? status;
  @JsonKey(name: 'data')
  final dynamic data;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'timestamp')
  final DateTime? timestamp;
  @JsonKey(name: 'errorCode')
  final String? errorCode;
  @JsonKey(name: 'baD_Request')
  final String? baDRequest;
  @JsonKey(name: 'success')
  final bool? success;
  static const fromJsonFactory = _$BooleanResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BooleanResponseDto &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.timestamp, timestamp) ||
                const DeepCollectionEquality()
                    .equals(other.timestamp, timestamp)) &&
            (identical(other.errorCode, errorCode) ||
                const DeepCollectionEquality()
                    .equals(other.errorCode, errorCode)) &&
            (identical(other.baDRequest, baDRequest) ||
                const DeepCollectionEquality()
                    .equals(other.baDRequest, baDRequest)) &&
            (identical(other.success, success) ||
                const DeepCollectionEquality().equals(other.success, success)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(timestamp) ^
      const DeepCollectionEquality().hash(errorCode) ^
      const DeepCollectionEquality().hash(baDRequest) ^
      const DeepCollectionEquality().hash(success) ^
      runtimeType.hashCode;
}

extension $BooleanResponseDtoExtension on BooleanResponseDto {
  BooleanResponseDto copyWith(
      {int? status,
      dynamic data,
      String? message,
      DateTime? timestamp,
      String? errorCode,
      String? baDRequest,
      bool? success}) {
    return BooleanResponseDto(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message,
        timestamp: timestamp ?? this.timestamp,
        errorCode: errorCode ?? this.errorCode,
        baDRequest: baDRequest ?? this.baDRequest,
        success: success ?? this.success);
  }

  BooleanResponseDto copyWithWrapped(
      {Wrapped<int?>? status,
      Wrapped<dynamic>? data,
      Wrapped<String?>? message,
      Wrapped<DateTime?>? timestamp,
      Wrapped<String?>? errorCode,
      Wrapped<String?>? baDRequest,
      Wrapped<bool?>? success}) {
    return BooleanResponseDto(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data),
        message: (message != null ? message.value : this.message),
        timestamp: (timestamp != null ? timestamp.value : this.timestamp),
        errorCode: (errorCode != null ? errorCode.value : this.errorCode),
        baDRequest: (baDRequest != null ? baDRequest.value : this.baDRequest),
        success: (success != null ? success.value : this.success));
  }
}

@JsonSerializable(explicitToJson: true)
class CancelDto {
  const CancelDto({
    this.ticket,
    this.lots,
    this.userid,
    this.symbol,
    this.platformType,
    this.accountStatus,
    this.isPartially,
    this.tradeSide,
    this.tradeType,
  });

  factory CancelDto.fromJson(Map<String, dynamic> json) =>
      _$CancelDtoFromJson(json);

  static const toJsonFactory = _$CancelDtoToJson;
  Map<String, dynamic> toJson() => _$CancelDtoToJson(this);

  @JsonKey(name: 'ticket')
  final int? ticket;
  @JsonKey(name: 'lots')
  final double? lots;
  @JsonKey(name: 'userid')
  final int? userid;
  @JsonKey(name: 'symbol')
  final String? symbol;
  @JsonKey(name: 'platformType')
  final int? platformType;
  @JsonKey(name: 'accountStatus')
  final int? accountStatus;
  @JsonKey(name: 'isPartially')
  final bool? isPartially;
  @JsonKey(name: 'tradeSide')
  final String? tradeSide;
  @JsonKey(name: 'tradeType')
  final String? tradeType;
  static const fromJsonFactory = _$CancelDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CancelDto &&
            (identical(other.ticket, ticket) ||
                const DeepCollectionEquality().equals(other.ticket, ticket)) &&
            (identical(other.lots, lots) ||
                const DeepCollectionEquality().equals(other.lots, lots)) &&
            (identical(other.userid, userid) ||
                const DeepCollectionEquality().equals(other.userid, userid)) &&
            (identical(other.symbol, symbol) ||
                const DeepCollectionEquality().equals(other.symbol, symbol)) &&
            (identical(other.platformType, platformType) ||
                const DeepCollectionEquality()
                    .equals(other.platformType, platformType)) &&
            (identical(other.accountStatus, accountStatus) ||
                const DeepCollectionEquality()
                    .equals(other.accountStatus, accountStatus)) &&
            (identical(other.isPartially, isPartially) ||
                const DeepCollectionEquality()
                    .equals(other.isPartially, isPartially)) &&
            (identical(other.tradeSide, tradeSide) ||
                const DeepCollectionEquality()
                    .equals(other.tradeSide, tradeSide)) &&
            (identical(other.tradeType, tradeType) ||
                const DeepCollectionEquality()
                    .equals(other.tradeType, tradeType)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(ticket) ^
      const DeepCollectionEquality().hash(lots) ^
      const DeepCollectionEquality().hash(userid) ^
      const DeepCollectionEquality().hash(symbol) ^
      const DeepCollectionEquality().hash(platformType) ^
      const DeepCollectionEquality().hash(accountStatus) ^
      const DeepCollectionEquality().hash(isPartially) ^
      const DeepCollectionEquality().hash(tradeSide) ^
      const DeepCollectionEquality().hash(tradeType) ^
      runtimeType.hashCode;
}

extension $CancelDtoExtension on CancelDto {
  CancelDto copyWith(
      {int? ticket,
      double? lots,
      int? userid,
      String? symbol,
      int? platformType,
      int? accountStatus,
      bool? isPartially,
      String? tradeSide,
      String? tradeType}) {
    return CancelDto(
        ticket: ticket ?? this.ticket,
        lots: lots ?? this.lots,
        userid: userid ?? this.userid,
        symbol: symbol ?? this.symbol,
        platformType: platformType ?? this.platformType,
        accountStatus: accountStatus ?? this.accountStatus,
        isPartially: isPartially ?? this.isPartially,
        tradeSide: tradeSide ?? this.tradeSide,
        tradeType: tradeType ?? this.tradeType);
  }

  CancelDto copyWithWrapped(
      {Wrapped<int?>? ticket,
      Wrapped<double?>? lots,
      Wrapped<int?>? userid,
      Wrapped<String?>? symbol,
      Wrapped<int?>? platformType,
      Wrapped<int?>? accountStatus,
      Wrapped<bool?>? isPartially,
      Wrapped<String?>? tradeSide,
      Wrapped<String?>? tradeType}) {
    return CancelDto(
        ticket: (ticket != null ? ticket.value : this.ticket),
        lots: (lots != null ? lots.value : this.lots),
        userid: (userid != null ? userid.value : this.userid),
        symbol: (symbol != null ? symbol.value : this.symbol),
        platformType:
            (platformType != null ? platformType.value : this.platformType),
        accountStatus:
            (accountStatus != null ? accountStatus.value : this.accountStatus),
        isPartially:
            (isPartially != null ? isPartially.value : this.isPartially),
        tradeSide: (tradeSide != null ? tradeSide.value : this.tradeSide),
        tradeType: (tradeType != null ? tradeType.value : this.tradeType));
  }
}

@JsonSerializable(explicitToJson: true)
class DxTradePositionDtoListResponseDto {
  const DxTradePositionDtoListResponseDto({
    this.status,
    this.data,
    this.message,
    this.timestamp,
    this.errorCode,
    this.baDRequest,
    this.success,
  });

  factory DxTradePositionDtoListResponseDto.fromJson(
          Map<String, dynamic> json) =>
      _$DxTradePositionDtoListResponseDtoFromJson(json);

  static const toJsonFactory = _$DxTradePositionDtoListResponseDtoToJson;
  Map<String, dynamic> toJson() =>
      _$DxTradePositionDtoListResponseDtoToJson(this);

  @JsonKey(name: 'status')
  final int? status;
  @JsonKey(name: 'data')
  final dynamic data;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'timestamp')
  final DateTime? timestamp;
  @JsonKey(name: 'errorCode')
  final String? errorCode;
  @JsonKey(name: 'baD_Request')
  final String? baDRequest;
  @JsonKey(name: 'success')
  final bool? success;
  static const fromJsonFactory = _$DxTradePositionDtoListResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is DxTradePositionDtoListResponseDto &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.timestamp, timestamp) ||
                const DeepCollectionEquality()
                    .equals(other.timestamp, timestamp)) &&
            (identical(other.errorCode, errorCode) ||
                const DeepCollectionEquality()
                    .equals(other.errorCode, errorCode)) &&
            (identical(other.baDRequest, baDRequest) ||
                const DeepCollectionEquality()
                    .equals(other.baDRequest, baDRequest)) &&
            (identical(other.success, success) ||
                const DeepCollectionEquality().equals(other.success, success)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(timestamp) ^
      const DeepCollectionEquality().hash(errorCode) ^
      const DeepCollectionEquality().hash(baDRequest) ^
      const DeepCollectionEquality().hash(success) ^
      runtimeType.hashCode;
}

extension $DxTradePositionDtoListResponseDtoExtension
    on DxTradePositionDtoListResponseDto {
  DxTradePositionDtoListResponseDto copyWith(
      {int? status,
      dynamic data,
      String? message,
      DateTime? timestamp,
      String? errorCode,
      String? baDRequest,
      bool? success}) {
    return DxTradePositionDtoListResponseDto(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message,
        timestamp: timestamp ?? this.timestamp,
        errorCode: errorCode ?? this.errorCode,
        baDRequest: baDRequest ?? this.baDRequest,
        success: success ?? this.success);
  }

  DxTradePositionDtoListResponseDto copyWithWrapped(
      {Wrapped<int?>? status,
      Wrapped<dynamic>? data,
      Wrapped<String?>? message,
      Wrapped<DateTime?>? timestamp,
      Wrapped<String?>? errorCode,
      Wrapped<String?>? baDRequest,
      Wrapped<bool?>? success}) {
    return DxTradePositionDtoListResponseDto(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data),
        message: (message != null ? message.value : this.message),
        timestamp: (timestamp != null ? timestamp.value : this.timestamp),
        errorCode: (errorCode != null ? errorCode.value : this.errorCode),
        baDRequest: (baDRequest != null ? baDRequest.value : this.baDRequest),
        success: (success != null ? success.value : this.success));
  }
}

@JsonSerializable(explicitToJson: true)
class FollowRiskSetting {
  const FollowRiskSetting({
    this.id,
    this.userId,
    this.platformName,
    this.updateStopLossTakeProfitStatus,
    this.closeprofithigh,
    this.closeLossPointHigh,
    this.closelosshigh,
    this.closeallprofithigh,
    this.closealllosshigh,
    this.closeallequitylow,
    this.closeallequityhigh,
    this.closeProfitPointHigh,
    this.sourcePendingProfitPointCloseFollow,
    this.sourcePendingLossPointCloseFollow,
    this.closePendingTimeOut,
    this.sourcePendingProfitPointCloseFollowFrom,
    this.sourcePendingProfitPointCloseFollowTo,
    this.sourcePendingLossPointCloseFollowFrom,
    this.sourcePendingLossPointCloseFollowTo,
    this.sourcePendingTimeoutCloseFollowFrom,
    this.sourcePendingTimeoutCloseFollowTo,
  });

  factory FollowRiskSetting.fromJson(Map<String, dynamic> json) =>
      _$FollowRiskSettingFromJson(json);

  static const toJsonFactory = _$FollowRiskSettingToJson;
  Map<String, dynamic> toJson() => _$FollowRiskSettingToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'platformName')
  final String? platformName;
  @JsonKey(name: 'updateStopLossTakeProfitStatus')
  final int? updateStopLossTakeProfitStatus;
  @JsonKey(name: 'closeprofithigh')
  final double? closeprofithigh;
  @JsonKey(name: 'closeLossPointHigh')
  final double? closeLossPointHigh;
  @JsonKey(name: 'closelosshigh')
  final double? closelosshigh;
  @JsonKey(name: 'closeallprofithigh')
  final double? closeallprofithigh;
  @JsonKey(name: 'closealllosshigh')
  final double? closealllosshigh;
  @JsonKey(name: 'closeallequitylow')
  final double? closeallequitylow;
  @JsonKey(name: 'closeallequityhigh')
  final double? closeallequityhigh;
  @JsonKey(name: 'closeProfitPointHigh')
  final double? closeProfitPointHigh;
  @JsonKey(name: 'sourcePendingProfitPointCloseFollow')
  final double? sourcePendingProfitPointCloseFollow;
  @JsonKey(name: 'sourcePendingLossPointCloseFollow')
  final double? sourcePendingLossPointCloseFollow;
  @JsonKey(name: 'closePendingTimeOut')
  final double? closePendingTimeOut;
  @JsonKey(name: 'sourcePendingProfitPointCloseFollowFrom')
  final double? sourcePendingProfitPointCloseFollowFrom;
  @JsonKey(name: 'sourcePendingProfitPointCloseFollowTo')
  final double? sourcePendingProfitPointCloseFollowTo;
  @JsonKey(name: 'sourcePendingLossPointCloseFollowFrom')
  final double? sourcePendingLossPointCloseFollowFrom;
  @JsonKey(name: 'sourcePendingLossPointCloseFollowTo')
  final double? sourcePendingLossPointCloseFollowTo;
  @JsonKey(name: 'sourcePendingTimeoutCloseFollowFrom')
  final double? sourcePendingTimeoutCloseFollowFrom;
  @JsonKey(name: 'sourcePendingTimeoutCloseFollowTo')
  final double? sourcePendingTimeoutCloseFollowTo;
  static const fromJsonFactory = _$FollowRiskSettingFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FollowRiskSetting &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.platformName, platformName) ||
                const DeepCollectionEquality()
                    .equals(other.platformName, platformName)) &&
            (identical(other.updateStopLossTakeProfitStatus, updateStopLossTakeProfitStatus) ||
                const DeepCollectionEquality().equals(
                    other.updateStopLossTakeProfitStatus,
                    updateStopLossTakeProfitStatus)) &&
            (identical(other.closeprofithigh, closeprofithigh) ||
                const DeepCollectionEquality()
                    .equals(other.closeprofithigh, closeprofithigh)) &&
            (identical(other.closeLossPointHigh, closeLossPointHigh) ||
                const DeepCollectionEquality()
                    .equals(other.closeLossPointHigh, closeLossPointHigh)) &&
            (identical(other.closelosshigh, closelosshigh) ||
                const DeepCollectionEquality()
                    .equals(other.closelosshigh, closelosshigh)) &&
            (identical(other.closeallprofithigh, closeallprofithigh) ||
                const DeepCollectionEquality()
                    .equals(other.closeallprofithigh, closeallprofithigh)) &&
            (identical(other.closealllosshigh, closealllosshigh) ||
                const DeepCollectionEquality()
                    .equals(other.closealllosshigh, closealllosshigh)) &&
            (identical(other.closeallequitylow, closeallequitylow) ||
                const DeepCollectionEquality()
                    .equals(other.closeallequitylow, closeallequitylow)) &&
            (identical(other.closeallequityhigh, closeallequityhigh) ||
                const DeepCollectionEquality()
                    .equals(other.closeallequityhigh, closeallequityhigh)) &&
            (identical(other.closeProfitPointHigh, closeProfitPointHigh) ||
                const DeepCollectionEquality().equals(
                    other.closeProfitPointHigh, closeProfitPointHigh)) &&
            (identical(other.sourcePendingProfitPointCloseFollow, sourcePendingProfitPointCloseFollow) ||
                const DeepCollectionEquality().equals(
                    other.sourcePendingProfitPointCloseFollow,
                    sourcePendingProfitPointCloseFollow)) &&
            (identical(other.sourcePendingLossPointCloseFollow, sourcePendingLossPointCloseFollow) ||
                const DeepCollectionEquality().equals(
                    other.sourcePendingLossPointCloseFollow,
                    sourcePendingLossPointCloseFollow)) &&
            (identical(other.closePendingTimeOut, closePendingTimeOut) ||
                const DeepCollectionEquality()
                    .equals(other.closePendingTimeOut, closePendingTimeOut)) &&
            (identical(other.sourcePendingProfitPointCloseFollowFrom, sourcePendingProfitPointCloseFollowFrom) ||
                const DeepCollectionEquality().equals(other.sourcePendingProfitPointCloseFollowFrom, sourcePendingProfitPointCloseFollowFrom)) &&
            (identical(other.sourcePendingProfitPointCloseFollowTo, sourcePendingProfitPointCloseFollowTo) || const DeepCollectionEquality().equals(other.sourcePendingProfitPointCloseFollowTo, sourcePendingProfitPointCloseFollowTo)) &&
            (identical(other.sourcePendingLossPointCloseFollowFrom, sourcePendingLossPointCloseFollowFrom) || const DeepCollectionEquality().equals(other.sourcePendingLossPointCloseFollowFrom, sourcePendingLossPointCloseFollowFrom)) &&
            (identical(other.sourcePendingLossPointCloseFollowTo, sourcePendingLossPointCloseFollowTo) || const DeepCollectionEquality().equals(other.sourcePendingLossPointCloseFollowTo, sourcePendingLossPointCloseFollowTo)) &&
            (identical(other.sourcePendingTimeoutCloseFollowFrom, sourcePendingTimeoutCloseFollowFrom) || const DeepCollectionEquality().equals(other.sourcePendingTimeoutCloseFollowFrom, sourcePendingTimeoutCloseFollowFrom)) &&
            (identical(other.sourcePendingTimeoutCloseFollowTo, sourcePendingTimeoutCloseFollowTo) || const DeepCollectionEquality().equals(other.sourcePendingTimeoutCloseFollowTo, sourcePendingTimeoutCloseFollowTo)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(platformName) ^
      const DeepCollectionEquality().hash(updateStopLossTakeProfitStatus) ^
      const DeepCollectionEquality().hash(closeprofithigh) ^
      const DeepCollectionEquality().hash(closeLossPointHigh) ^
      const DeepCollectionEquality().hash(closelosshigh) ^
      const DeepCollectionEquality().hash(closeallprofithigh) ^
      const DeepCollectionEquality().hash(closealllosshigh) ^
      const DeepCollectionEquality().hash(closeallequitylow) ^
      const DeepCollectionEquality().hash(closeallequityhigh) ^
      const DeepCollectionEquality().hash(closeProfitPointHigh) ^
      const DeepCollectionEquality().hash(sourcePendingProfitPointCloseFollow) ^
      const DeepCollectionEquality().hash(sourcePendingLossPointCloseFollow) ^
      const DeepCollectionEquality().hash(closePendingTimeOut) ^
      const DeepCollectionEquality()
          .hash(sourcePendingProfitPointCloseFollowFrom) ^
      const DeepCollectionEquality()
          .hash(sourcePendingProfitPointCloseFollowTo) ^
      const DeepCollectionEquality()
          .hash(sourcePendingLossPointCloseFollowFrom) ^
      const DeepCollectionEquality().hash(sourcePendingLossPointCloseFollowTo) ^
      const DeepCollectionEquality().hash(sourcePendingTimeoutCloseFollowFrom) ^
      const DeepCollectionEquality().hash(sourcePendingTimeoutCloseFollowTo) ^
      runtimeType.hashCode;
}

extension $FollowRiskSettingExtension on FollowRiskSetting {
  FollowRiskSetting copyWith(
      {int? id,
      int? userId,
      String? platformName,
      int? updateStopLossTakeProfitStatus,
      double? closeprofithigh,
      double? closeLossPointHigh,
      double? closelosshigh,
      double? closeallprofithigh,
      double? closealllosshigh,
      double? closeallequitylow,
      double? closeallequityhigh,
      double? closeProfitPointHigh,
      double? sourcePendingProfitPointCloseFollow,
      double? sourcePendingLossPointCloseFollow,
      double? closePendingTimeOut,
      double? sourcePendingProfitPointCloseFollowFrom,
      double? sourcePendingProfitPointCloseFollowTo,
      double? sourcePendingLossPointCloseFollowFrom,
      double? sourcePendingLossPointCloseFollowTo,
      double? sourcePendingTimeoutCloseFollowFrom,
      double? sourcePendingTimeoutCloseFollowTo}) {
    return FollowRiskSetting(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        platformName: platformName ?? this.platformName,
        updateStopLossTakeProfitStatus: updateStopLossTakeProfitStatus ??
            this.updateStopLossTakeProfitStatus,
        closeprofithigh: closeprofithigh ?? this.closeprofithigh,
        closeLossPointHigh: closeLossPointHigh ?? this.closeLossPointHigh,
        closelosshigh: closelosshigh ?? this.closelosshigh,
        closeallprofithigh: closeallprofithigh ?? this.closeallprofithigh,
        closealllosshigh: closealllosshigh ?? this.closealllosshigh,
        closeallequitylow: closeallequitylow ?? this.closeallequitylow,
        closeallequityhigh: closeallequityhigh ?? this.closeallequityhigh,
        closeProfitPointHigh: closeProfitPointHigh ?? this.closeProfitPointHigh,
        sourcePendingProfitPointCloseFollow:
            sourcePendingProfitPointCloseFollow ??
                this.sourcePendingProfitPointCloseFollow,
        sourcePendingLossPointCloseFollow: sourcePendingLossPointCloseFollow ??
            this.sourcePendingLossPointCloseFollow,
        closePendingTimeOut: closePendingTimeOut ?? this.closePendingTimeOut,
        sourcePendingProfitPointCloseFollowFrom:
            sourcePendingProfitPointCloseFollowFrom ??
                this.sourcePendingProfitPointCloseFollowFrom,
        sourcePendingProfitPointCloseFollowTo:
            sourcePendingProfitPointCloseFollowTo ??
                this.sourcePendingProfitPointCloseFollowTo,
        sourcePendingLossPointCloseFollowFrom:
            sourcePendingLossPointCloseFollowFrom ??
                this.sourcePendingLossPointCloseFollowFrom,
        sourcePendingLossPointCloseFollowTo:
            sourcePendingLossPointCloseFollowTo ??
                this.sourcePendingLossPointCloseFollowTo,
        sourcePendingTimeoutCloseFollowFrom:
            sourcePendingTimeoutCloseFollowFrom ??
                this.sourcePendingTimeoutCloseFollowFrom,
        sourcePendingTimeoutCloseFollowTo: sourcePendingTimeoutCloseFollowTo ??
            this.sourcePendingTimeoutCloseFollowTo);
  }

  FollowRiskSetting copyWithWrapped(
      {Wrapped<int?>? id,
      Wrapped<int?>? userId,
      Wrapped<String?>? platformName,
      Wrapped<int?>? updateStopLossTakeProfitStatus,
      Wrapped<double?>? closeprofithigh,
      Wrapped<double?>? closeLossPointHigh,
      Wrapped<double?>? closelosshigh,
      Wrapped<double?>? closeallprofithigh,
      Wrapped<double?>? closealllosshigh,
      Wrapped<double?>? closeallequitylow,
      Wrapped<double?>? closeallequityhigh,
      Wrapped<double?>? closeProfitPointHigh,
      Wrapped<double?>? sourcePendingProfitPointCloseFollow,
      Wrapped<double?>? sourcePendingLossPointCloseFollow,
      Wrapped<double?>? closePendingTimeOut,
      Wrapped<double?>? sourcePendingProfitPointCloseFollowFrom,
      Wrapped<double?>? sourcePendingProfitPointCloseFollowTo,
      Wrapped<double?>? sourcePendingLossPointCloseFollowFrom,
      Wrapped<double?>? sourcePendingLossPointCloseFollowTo,
      Wrapped<double?>? sourcePendingTimeoutCloseFollowFrom,
      Wrapped<double?>? sourcePendingTimeoutCloseFollowTo}) {
    return FollowRiskSetting(
        id: (id != null ? id.value : this.id),
        userId: (userId != null ? userId.value : this.userId),
        platformName:
            (platformName != null ? platformName.value : this.platformName),
        updateStopLossTakeProfitStatus: (updateStopLossTakeProfitStatus != null
            ? updateStopLossTakeProfitStatus.value
            : this.updateStopLossTakeProfitStatus),
        closeprofithigh: (closeprofithigh != null
            ? closeprofithigh.value
            : this.closeprofithigh),
        closeLossPointHigh: (closeLossPointHigh != null
            ? closeLossPointHigh.value
            : this.closeLossPointHigh),
        closelosshigh:
            (closelosshigh != null ? closelosshigh.value : this.closelosshigh),
        closeallprofithigh: (closeallprofithigh != null
            ? closeallprofithigh.value
            : this.closeallprofithigh),
        closealllosshigh: (closealllosshigh != null
            ? closealllosshigh.value
            : this.closealllosshigh),
        closeallequitylow: (closeallequitylow != null
            ? closeallequitylow.value
            : this.closeallequitylow),
        closeallequityhigh: (closeallequityhigh != null
            ? closeallequityhigh.value
            : this.closeallequityhigh),
        closeProfitPointHigh: (closeProfitPointHigh != null
            ? closeProfitPointHigh.value
            : this.closeProfitPointHigh),
        sourcePendingProfitPointCloseFollow:
            (sourcePendingProfitPointCloseFollow != null
                ? sourcePendingProfitPointCloseFollow.value
                : this.sourcePendingProfitPointCloseFollow),
        sourcePendingLossPointCloseFollow:
            (sourcePendingLossPointCloseFollow != null
                ? sourcePendingLossPointCloseFollow.value
                : this.sourcePendingLossPointCloseFollow),
        closePendingTimeOut: (closePendingTimeOut != null
            ? closePendingTimeOut.value
            : this.closePendingTimeOut),
        sourcePendingProfitPointCloseFollowFrom:
            (sourcePendingProfitPointCloseFollowFrom != null
                ? sourcePendingProfitPointCloseFollowFrom.value
                : this.sourcePendingProfitPointCloseFollowFrom),
        sourcePendingProfitPointCloseFollowTo:
            (sourcePendingProfitPointCloseFollowTo != null
                ? sourcePendingProfitPointCloseFollowTo.value
                : this.sourcePendingProfitPointCloseFollowTo),
        sourcePendingLossPointCloseFollowFrom:
            (sourcePendingLossPointCloseFollowFrom != null
                ? sourcePendingLossPointCloseFollowFrom.value
                : this.sourcePendingLossPointCloseFollowFrom),
        sourcePendingLossPointCloseFollowTo:
            (sourcePendingLossPointCloseFollowTo != null
                ? sourcePendingLossPointCloseFollowTo.value
                : this.sourcePendingLossPointCloseFollowTo),
        sourcePendingTimeoutCloseFollowFrom:
            (sourcePendingTimeoutCloseFollowFrom != null
                ? sourcePendingTimeoutCloseFollowFrom.value
                : this.sourcePendingTimeoutCloseFollowFrom),
        sourcePendingTimeoutCloseFollowTo:
            (sourcePendingTimeoutCloseFollowTo != null
                ? sourcePendingTimeoutCloseFollowTo.value
                : this.sourcePendingTimeoutCloseFollowTo));
  }
}

@JsonSerializable(explicitToJson: true)
class MT4OrderDtoListResponseDto {
  const MT4OrderDtoListResponseDto({
    this.status,
    this.data,
    this.message,
    this.timestamp,
    this.errorCode,
    this.baDRequest,
    this.success,
  });

  factory MT4OrderDtoListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MT4OrderDtoListResponseDtoFromJson(json);

  static const toJsonFactory = _$MT4OrderDtoListResponseDtoToJson;
  Map<String, dynamic> toJson() => _$MT4OrderDtoListResponseDtoToJson(this);

  @JsonKey(name: 'status')
  final int? status;
  @JsonKey(name: 'data')
  final dynamic data;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'timestamp')
  final DateTime? timestamp;
  @JsonKey(name: 'errorCode')
  final String? errorCode;
  @JsonKey(name: 'baD_Request')
  final String? baDRequest;
  @JsonKey(name: 'success')
  final bool? success;
  static const fromJsonFactory = _$MT4OrderDtoListResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MT4OrderDtoListResponseDto &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.timestamp, timestamp) ||
                const DeepCollectionEquality()
                    .equals(other.timestamp, timestamp)) &&
            (identical(other.errorCode, errorCode) ||
                const DeepCollectionEquality()
                    .equals(other.errorCode, errorCode)) &&
            (identical(other.baDRequest, baDRequest) ||
                const DeepCollectionEquality()
                    .equals(other.baDRequest, baDRequest)) &&
            (identical(other.success, success) ||
                const DeepCollectionEquality().equals(other.success, success)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(timestamp) ^
      const DeepCollectionEquality().hash(errorCode) ^
      const DeepCollectionEquality().hash(baDRequest) ^
      const DeepCollectionEquality().hash(success) ^
      runtimeType.hashCode;
}

extension $MT4OrderDtoListResponseDtoExtension on MT4OrderDtoListResponseDto {
  MT4OrderDtoListResponseDto copyWith(
      {int? status,
      dynamic data,
      String? message,
      DateTime? timestamp,
      String? errorCode,
      String? baDRequest,
      bool? success}) {
    return MT4OrderDtoListResponseDto(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message,
        timestamp: timestamp ?? this.timestamp,
        errorCode: errorCode ?? this.errorCode,
        baDRequest: baDRequest ?? this.baDRequest,
        success: success ?? this.success);
  }

  MT4OrderDtoListResponseDto copyWithWrapped(
      {Wrapped<int?>? status,
      Wrapped<dynamic>? data,
      Wrapped<String?>? message,
      Wrapped<DateTime?>? timestamp,
      Wrapped<String?>? errorCode,
      Wrapped<String?>? baDRequest,
      Wrapped<bool?>? success}) {
    return MT4OrderDtoListResponseDto(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data),
        message: (message != null ? message.value : this.message),
        timestamp: (timestamp != null ? timestamp.value : this.timestamp),
        errorCode: (errorCode != null ? errorCode.value : this.errorCode),
        baDRequest: (baDRequest != null ? baDRequest.value : this.baDRequest),
        success: (success != null ? success.value : this.success));
  }
}

@JsonSerializable(explicitToJson: true)
class Risk {
  const Risk({
    this.riskType,
    this.multiplier,
    this.id,
    this.direction,
  });

  factory Risk.fromJson(Map<String, dynamic> json) => _$RiskFromJson(json);

  static const toJsonFactory = _$RiskToJson;
  Map<String, dynamic> toJson() => _$RiskToJson(this);

  @JsonKey(name: 'risk_type')
  final int? riskType;
  @JsonKey(name: 'multiplier')
  final double? multiplier;
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'direction')
  final int? direction;
  static const fromJsonFactory = _$RiskFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Risk &&
            (identical(other.riskType, riskType) ||
                const DeepCollectionEquality()
                    .equals(other.riskType, riskType)) &&
            (identical(other.multiplier, multiplier) ||
                const DeepCollectionEquality()
                    .equals(other.multiplier, multiplier)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.direction, direction) ||
                const DeepCollectionEquality()
                    .equals(other.direction, direction)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(riskType) ^
      const DeepCollectionEquality().hash(multiplier) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(direction) ^
      runtimeType.hashCode;
}

extension $RiskExtension on Risk {
  Risk copyWith({int? riskType, double? multiplier, int? id, int? direction}) {
    return Risk(
        riskType: riskType ?? this.riskType,
        multiplier: multiplier ?? this.multiplier,
        id: id ?? this.id,
        direction: direction ?? this.direction);
  }

  Risk copyWithWrapped(
      {Wrapped<int?>? riskType,
      Wrapped<double?>? multiplier,
      Wrapped<int?>? id,
      Wrapped<int?>? direction}) {
    return Risk(
        riskType: (riskType != null ? riskType.value : this.riskType),
        multiplier: (multiplier != null ? multiplier.value : this.multiplier),
        id: (id != null ? id.value : this.id),
        direction: (direction != null ? direction.value : this.direction));
  }
}

@JsonSerializable(explicitToJson: true)
class StopsLimits {
  const StopsLimits({
    this.id,
    this.copySLTP,
    this.orderLimit,
    this.limit,
    this.remaining,
    this.copyOrderType,
    this.scalperMode,
    this.scalperValue,
    this.splitOrder,
    this.splitValue,
    this.orderFilter,
  });

  factory StopsLimits.fromJson(Map<String, dynamic> json) =>
      _$StopsLimitsFromJson(json);

  static const toJsonFactory = _$StopsLimitsToJson;
  Map<String, dynamic> toJson() => _$StopsLimitsToJson(this);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'copySLTP')
  final bool? copySLTP;
  @JsonKey(name: 'orderLimit')
  final bool? orderLimit;
  @JsonKey(name: 'limit')
  final int? limit;
  @JsonKey(name: 'remaining')
  final int? remaining;
  @JsonKey(name: 'copyOrderType')
  final int? copyOrderType;
  @JsonKey(name: 'scalperMode')
  final int? scalperMode;
  @JsonKey(name: 'scalperValue')
  final double? scalperValue;
  @JsonKey(name: 'splitOrder')
  final bool? splitOrder;
  @JsonKey(name: 'splitValue')
  final double? splitValue;
  @JsonKey(name: 'orderFilter')
  final int? orderFilter;
  static const fromJsonFactory = _$StopsLimitsFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StopsLimits &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.copySLTP, copySLTP) ||
                const DeepCollectionEquality()
                    .equals(other.copySLTP, copySLTP)) &&
            (identical(other.orderLimit, orderLimit) ||
                const DeepCollectionEquality()
                    .equals(other.orderLimit, orderLimit)) &&
            (identical(other.limit, limit) ||
                const DeepCollectionEquality().equals(other.limit, limit)) &&
            (identical(other.remaining, remaining) ||
                const DeepCollectionEquality()
                    .equals(other.remaining, remaining)) &&
            (identical(other.copyOrderType, copyOrderType) ||
                const DeepCollectionEquality()
                    .equals(other.copyOrderType, copyOrderType)) &&
            (identical(other.scalperMode, scalperMode) ||
                const DeepCollectionEquality()
                    .equals(other.scalperMode, scalperMode)) &&
            (identical(other.scalperValue, scalperValue) ||
                const DeepCollectionEquality()
                    .equals(other.scalperValue, scalperValue)) &&
            (identical(other.splitOrder, splitOrder) ||
                const DeepCollectionEquality()
                    .equals(other.splitOrder, splitOrder)) &&
            (identical(other.splitValue, splitValue) ||
                const DeepCollectionEquality()
                    .equals(other.splitValue, splitValue)) &&
            (identical(other.orderFilter, orderFilter) ||
                const DeepCollectionEquality()
                    .equals(other.orderFilter, orderFilter)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(copySLTP) ^
      const DeepCollectionEquality().hash(orderLimit) ^
      const DeepCollectionEquality().hash(limit) ^
      const DeepCollectionEquality().hash(remaining) ^
      const DeepCollectionEquality().hash(copyOrderType) ^
      const DeepCollectionEquality().hash(scalperMode) ^
      const DeepCollectionEquality().hash(scalperValue) ^
      const DeepCollectionEquality().hash(splitOrder) ^
      const DeepCollectionEquality().hash(splitValue) ^
      const DeepCollectionEquality().hash(orderFilter) ^
      runtimeType.hashCode;
}

extension $StopsLimitsExtension on StopsLimits {
  StopsLimits copyWith(
      {int? id,
      bool? copySLTP,
      bool? orderLimit,
      int? limit,
      int? remaining,
      int? copyOrderType,
      int? scalperMode,
      double? scalperValue,
      bool? splitOrder,
      double? splitValue,
      int? orderFilter}) {
    return StopsLimits(
        id: id ?? this.id,
        copySLTP: copySLTP ?? this.copySLTP,
        orderLimit: orderLimit ?? this.orderLimit,
        limit: limit ?? this.limit,
        remaining: remaining ?? this.remaining,
        copyOrderType: copyOrderType ?? this.copyOrderType,
        scalperMode: scalperMode ?? this.scalperMode,
        scalperValue: scalperValue ?? this.scalperValue,
        splitOrder: splitOrder ?? this.splitOrder,
        splitValue: splitValue ?? this.splitValue,
        orderFilter: orderFilter ?? this.orderFilter);
  }

  StopsLimits copyWithWrapped(
      {Wrapped<int?>? id,
      Wrapped<bool?>? copySLTP,
      Wrapped<bool?>? orderLimit,
      Wrapped<int?>? limit,
      Wrapped<int?>? remaining,
      Wrapped<int?>? copyOrderType,
      Wrapped<int?>? scalperMode,
      Wrapped<double?>? scalperValue,
      Wrapped<bool?>? splitOrder,
      Wrapped<double?>? splitValue,
      Wrapped<int?>? orderFilter}) {
    return StopsLimits(
        id: (id != null ? id.value : this.id),
        copySLTP: (copySLTP != null ? copySLTP.value : this.copySLTP),
        orderLimit: (orderLimit != null ? orderLimit.value : this.orderLimit),
        limit: (limit != null ? limit.value : this.limit),
        remaining: (remaining != null ? remaining.value : this.remaining),
        copyOrderType:
            (copyOrderType != null ? copyOrderType.value : this.copyOrderType),
        scalperMode:
            (scalperMode != null ? scalperMode.value : this.scalperMode),
        scalperValue:
            (scalperValue != null ? scalperValue.value : this.scalperValue),
        splitOrder: (splitOrder != null ? splitOrder.value : this.splitOrder),
        splitValue: (splitValue != null ? splitValue.value : this.splitValue),
        orderFilter:
            (orderFilter != null ? orderFilter.value : this.orderFilter));
  }
}

@JsonSerializable(explicitToJson: true)
class StringResponseDto {
  const StringResponseDto({
    this.status,
    this.data,
    this.message,
    this.timestamp,
    this.errorCode,
    this.baDRequest,
    this.success,
  });

  factory StringResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StringResponseDtoFromJson(json);

  static const toJsonFactory = _$StringResponseDtoToJson;
  Map<String, dynamic> toJson() => _$StringResponseDtoToJson(this);

  @JsonKey(name: 'status')
  final int? status;
  @JsonKey(name: 'data')
  final dynamic data;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'timestamp')
  final DateTime? timestamp;
  @JsonKey(name: 'errorCode')
  final String? errorCode;
  @JsonKey(name: 'baD_Request')
  final String? baDRequest;
  @JsonKey(name: 'success')
  final bool? success;
  static const fromJsonFactory = _$StringResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StringResponseDto &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.timestamp, timestamp) ||
                const DeepCollectionEquality()
                    .equals(other.timestamp, timestamp)) &&
            (identical(other.errorCode, errorCode) ||
                const DeepCollectionEquality()
                    .equals(other.errorCode, errorCode)) &&
            (identical(other.baDRequest, baDRequest) ||
                const DeepCollectionEquality()
                    .equals(other.baDRequest, baDRequest)) &&
            (identical(other.success, success) ||
                const DeepCollectionEquality().equals(other.success, success)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(data) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(timestamp) ^
      const DeepCollectionEquality().hash(errorCode) ^
      const DeepCollectionEquality().hash(baDRequest) ^
      const DeepCollectionEquality().hash(success) ^
      runtimeType.hashCode;
}

extension $StringResponseDtoExtension on StringResponseDto {
  StringResponseDto copyWith(
      {int? status,
      dynamic data,
      String? message,
      DateTime? timestamp,
      String? errorCode,
      String? baDRequest,
      bool? success}) {
    return StringResponseDto(
        status: status ?? this.status,
        data: data ?? this.data,
        message: message ?? this.message,
        timestamp: timestamp ?? this.timestamp,
        errorCode: errorCode ?? this.errorCode,
        baDRequest: baDRequest ?? this.baDRequest,
        success: success ?? this.success);
  }

  StringResponseDto copyWithWrapped(
      {Wrapped<int?>? status,
      Wrapped<dynamic>? data,
      Wrapped<String?>? message,
      Wrapped<DateTime?>? timestamp,
      Wrapped<String?>? errorCode,
      Wrapped<String?>? baDRequest,
      Wrapped<bool?>? success}) {
    return StringResponseDto(
        status: (status != null ? status.value : this.status),
        data: (data != null ? data.value : this.data),
        message: (message != null ? message.value : this.message),
        timestamp: (timestamp != null ? timestamp.value : this.timestamp),
        errorCode: (errorCode != null ? errorCode.value : this.errorCode),
        baDRequest: (baDRequest != null ? baDRequest.value : this.baDRequest),
        success: (success != null ? success.value : this.success));
  }
}

@JsonSerializable(explicitToJson: true)
class UserStatusDto {
  const UserStatusDto({
    this.userId,
    this.managerStatus,
    this.status,
  });

  factory UserStatusDto.fromJson(Map<String, dynamic> json) =>
      _$UserStatusDtoFromJson(json);

  static const toJsonFactory = _$UserStatusDtoToJson;
  Map<String, dynamic> toJson() => _$UserStatusDtoToJson(this);

  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'managerStatus')
  final int? managerStatus;
  @JsonKey(name: 'status')
  final String? status;
  static const fromJsonFactory = _$UserStatusDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserStatusDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.managerStatus, managerStatus) ||
                const DeepCollectionEquality()
                    .equals(other.managerStatus, managerStatus)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(managerStatus) ^
      const DeepCollectionEquality().hash(status) ^
      runtimeType.hashCode;
}

extension $UserStatusDtoExtension on UserStatusDto {
  UserStatusDto copyWith({int? userId, int? managerStatus, String? status}) {
    return UserStatusDto(
        userId: userId ?? this.userId,
        managerStatus: managerStatus ?? this.managerStatus,
        status: status ?? this.status);
  }

  UserStatusDto copyWithWrapped(
      {Wrapped<int?>? userId,
      Wrapped<int?>? managerStatus,
      Wrapped<String?>? status}) {
    return UserStatusDto(
        userId: (userId != null ? userId.value : this.userId),
        managerStatus:
            (managerStatus != null ? managerStatus.value : this.managerStatus),
        status: (status != null ? status.value : this.status));
  }
}

int? cancelDtoPlatformTypeNullableToJson(
    enums.CancelDtoPlatformType? cancelDtoPlatformType) {
  return cancelDtoPlatformType?.value;
}

int? cancelDtoPlatformTypeToJson(
    enums.CancelDtoPlatformType cancelDtoPlatformType) {
  return cancelDtoPlatformType.value;
}

enums.CancelDtoPlatformType cancelDtoPlatformTypeFromJson(
  Object? cancelDtoPlatformType, [
  enums.CancelDtoPlatformType? defaultValue,
]) {
  return enums.CancelDtoPlatformType.values
          .firstWhereOrNull((e) => e.value == cancelDtoPlatformType) ??
      defaultValue ??
      enums.CancelDtoPlatformType.swaggerGeneratedUnknown;
}

enums.CancelDtoPlatformType? cancelDtoPlatformTypeNullableFromJson(
  Object? cancelDtoPlatformType, [
  enums.CancelDtoPlatformType? defaultValue,
]) {
  if (cancelDtoPlatformType == null) {
    return null;
  }
  return enums.CancelDtoPlatformType.values
          .firstWhereOrNull((e) => e.value == cancelDtoPlatformType) ??
      defaultValue;
}

String cancelDtoPlatformTypeExplodedListToJson(
    List<enums.CancelDtoPlatformType>? cancelDtoPlatformType) {
  return cancelDtoPlatformType?.map((e) => e.value!).join(',') ?? '';
}

List<int> cancelDtoPlatformTypeListToJson(
    List<enums.CancelDtoPlatformType>? cancelDtoPlatformType) {
  if (cancelDtoPlatformType == null) {
    return [];
  }

  return cancelDtoPlatformType.map((e) => e.value!).toList();
}

List<enums.CancelDtoPlatformType> cancelDtoPlatformTypeListFromJson(
  List? cancelDtoPlatformType, [
  List<enums.CancelDtoPlatformType>? defaultValue,
]) {
  if (cancelDtoPlatformType == null) {
    return defaultValue ?? [];
  }

  return cancelDtoPlatformType
      .map((e) => cancelDtoPlatformTypeFromJson(e.toString()))
      .toList();
}

List<enums.CancelDtoPlatformType>? cancelDtoPlatformTypeNullableListFromJson(
  List? cancelDtoPlatformType, [
  List<enums.CancelDtoPlatformType>? defaultValue,
]) {
  if (cancelDtoPlatformType == null) {
    return defaultValue;
  }

  return cancelDtoPlatformType
      .map((e) => cancelDtoPlatformTypeFromJson(e.toString()))
      .toList();
}

int? cancelDtoAccountStatusNullableToJson(
    enums.CancelDtoAccountStatus? cancelDtoAccountStatus) {
  return cancelDtoAccountStatus?.value;
}

int? cancelDtoAccountStatusToJson(
    enums.CancelDtoAccountStatus cancelDtoAccountStatus) {
  return cancelDtoAccountStatus.value;
}

enums.CancelDtoAccountStatus cancelDtoAccountStatusFromJson(
  Object? cancelDtoAccountStatus, [
  enums.CancelDtoAccountStatus? defaultValue,
]) {
  return enums.CancelDtoAccountStatus.values
          .firstWhereOrNull((e) => e.value == cancelDtoAccountStatus) ??
      defaultValue ??
      enums.CancelDtoAccountStatus.swaggerGeneratedUnknown;
}

enums.CancelDtoAccountStatus? cancelDtoAccountStatusNullableFromJson(
  Object? cancelDtoAccountStatus, [
  enums.CancelDtoAccountStatus? defaultValue,
]) {
  if (cancelDtoAccountStatus == null) {
    return null;
  }
  return enums.CancelDtoAccountStatus.values
          .firstWhereOrNull((e) => e.value == cancelDtoAccountStatus) ??
      defaultValue;
}

String cancelDtoAccountStatusExplodedListToJson(
    List<enums.CancelDtoAccountStatus>? cancelDtoAccountStatus) {
  return cancelDtoAccountStatus?.map((e) => e.value!).join(',') ?? '';
}

List<int> cancelDtoAccountStatusListToJson(
    List<enums.CancelDtoAccountStatus>? cancelDtoAccountStatus) {
  if (cancelDtoAccountStatus == null) {
    return [];
  }

  return cancelDtoAccountStatus.map((e) => e.value!).toList();
}

List<enums.CancelDtoAccountStatus> cancelDtoAccountStatusListFromJson(
  List? cancelDtoAccountStatus, [
  List<enums.CancelDtoAccountStatus>? defaultValue,
]) {
  if (cancelDtoAccountStatus == null) {
    return defaultValue ?? [];
  }

  return cancelDtoAccountStatus
      .map((e) => cancelDtoAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.CancelDtoAccountStatus>? cancelDtoAccountStatusNullableListFromJson(
  List? cancelDtoAccountStatus, [
  List<enums.CancelDtoAccountStatus>? defaultValue,
]) {
  if (cancelDtoAccountStatus == null) {
    return defaultValue;
  }

  return cancelDtoAccountStatus
      .map((e) => cancelDtoAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrdersMt4PostAccountStatusNullableToJson(
    enums.ApiV1GetOrdersMt4PostAccountStatus?
        apiV1GetOrdersMt4PostAccountStatus) {
  return apiV1GetOrdersMt4PostAccountStatus?.value;
}

int? apiV1GetOrdersMt4PostAccountStatusToJson(
    enums.ApiV1GetOrdersMt4PostAccountStatus
        apiV1GetOrdersMt4PostAccountStatus) {
  return apiV1GetOrdersMt4PostAccountStatus.value;
}

enums.ApiV1GetOrdersMt4PostAccountStatus
    apiV1GetOrdersMt4PostAccountStatusFromJson(
  Object? apiV1GetOrdersMt4PostAccountStatus, [
  enums.ApiV1GetOrdersMt4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrdersMt4PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1GetOrdersMt4PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetOrdersMt4PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetOrdersMt4PostAccountStatus?
    apiV1GetOrdersMt4PostAccountStatusNullableFromJson(
  Object? apiV1GetOrdersMt4PostAccountStatus, [
  enums.ApiV1GetOrdersMt4PostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrdersMt4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrdersMt4PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1GetOrdersMt4PostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrdersMt4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrdersMt4PostAccountStatus>?
        apiV1GetOrdersMt4PostAccountStatus) {
  return apiV1GetOrdersMt4PostAccountStatus?.map((e) => e.value!).join(',') ??
      '';
}

List<int> apiV1GetOrdersMt4PostAccountStatusListToJson(
    List<enums.ApiV1GetOrdersMt4PostAccountStatus>?
        apiV1GetOrdersMt4PostAccountStatus) {
  if (apiV1GetOrdersMt4PostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrdersMt4PostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1GetOrdersMt4PostAccountStatus>
    apiV1GetOrdersMt4PostAccountStatusListFromJson(
  List? apiV1GetOrdersMt4PostAccountStatus, [
  List<enums.ApiV1GetOrdersMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrdersMt4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrdersMt4PostAccountStatus
      .map((e) => apiV1GetOrdersMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetOrdersMt4PostAccountStatus>?
    apiV1GetOrdersMt4PostAccountStatusNullableListFromJson(
  List? apiV1GetOrdersMt4PostAccountStatus, [
  List<enums.ApiV1GetOrdersMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrdersMt4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrdersMt4PostAccountStatus
      .map((e) => apiV1GetOrdersMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ModifyOrderMt4PostAccountStatusNullableToJson(
    enums.ApiV1ModifyOrderMt4PostAccountStatus?
        apiV1ModifyOrderMt4PostAccountStatus) {
  return apiV1ModifyOrderMt4PostAccountStatus?.value;
}

int? apiV1ModifyOrderMt4PostAccountStatusToJson(
    enums.ApiV1ModifyOrderMt4PostAccountStatus
        apiV1ModifyOrderMt4PostAccountStatus) {
  return apiV1ModifyOrderMt4PostAccountStatus.value;
}

enums.ApiV1ModifyOrderMt4PostAccountStatus
    apiV1ModifyOrderMt4PostAccountStatusFromJson(
  Object? apiV1ModifyOrderMt4PostAccountStatus, [
  enums.ApiV1ModifyOrderMt4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyOrderMt4PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1ModifyOrderMt4PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyOrderMt4PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1ModifyOrderMt4PostAccountStatus?
    apiV1ModifyOrderMt4PostAccountStatusNullableFromJson(
  Object? apiV1ModifyOrderMt4PostAccountStatus, [
  enums.ApiV1ModifyOrderMt4PostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyOrderMt4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyOrderMt4PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1ModifyOrderMt4PostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyOrderMt4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyOrderMt4PostAccountStatus>?
        apiV1ModifyOrderMt4PostAccountStatus) {
  return apiV1ModifyOrderMt4PostAccountStatus?.map((e) => e.value!).join(',') ??
      '';
}

List<int> apiV1ModifyOrderMt4PostAccountStatusListToJson(
    List<enums.ApiV1ModifyOrderMt4PostAccountStatus>?
        apiV1ModifyOrderMt4PostAccountStatus) {
  if (apiV1ModifyOrderMt4PostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyOrderMt4PostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1ModifyOrderMt4PostAccountStatus>
    apiV1ModifyOrderMt4PostAccountStatusListFromJson(
  List? apiV1ModifyOrderMt4PostAccountStatus, [
  List<enums.ApiV1ModifyOrderMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyOrderMt4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyOrderMt4PostAccountStatus
      .map((e) => apiV1ModifyOrderMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ModifyOrderMt4PostAccountStatus>?
    apiV1ModifyOrderMt4PostAccountStatusNullableListFromJson(
  List? apiV1ModifyOrderMt4PostAccountStatus, [
  List<enums.ApiV1ModifyOrderMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyOrderMt4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyOrderMt4PostAccountStatus
      .map((e) => apiV1ModifyOrderMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseOrderMt4PostAccountStatusNullableToJson(
    enums.ApiV1CloseOrderMt4PostAccountStatus?
        apiV1CloseOrderMt4PostAccountStatus) {
  return apiV1CloseOrderMt4PostAccountStatus?.value;
}

int? apiV1CloseOrderMt4PostAccountStatusToJson(
    enums.ApiV1CloseOrderMt4PostAccountStatus
        apiV1CloseOrderMt4PostAccountStatus) {
  return apiV1CloseOrderMt4PostAccountStatus.value;
}

enums.ApiV1CloseOrderMt4PostAccountStatus
    apiV1CloseOrderMt4PostAccountStatusFromJson(
  Object? apiV1CloseOrderMt4PostAccountStatus, [
  enums.ApiV1CloseOrderMt4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseOrderMt4PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1CloseOrderMt4PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseOrderMt4PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1CloseOrderMt4PostAccountStatus?
    apiV1CloseOrderMt4PostAccountStatusNullableFromJson(
  Object? apiV1CloseOrderMt4PostAccountStatus, [
  enums.ApiV1CloseOrderMt4PostAccountStatus? defaultValue,
]) {
  if (apiV1CloseOrderMt4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseOrderMt4PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1CloseOrderMt4PostAccountStatus) ??
      defaultValue;
}

String apiV1CloseOrderMt4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseOrderMt4PostAccountStatus>?
        apiV1CloseOrderMt4PostAccountStatus) {
  return apiV1CloseOrderMt4PostAccountStatus?.map((e) => e.value!).join(',') ??
      '';
}

List<int> apiV1CloseOrderMt4PostAccountStatusListToJson(
    List<enums.ApiV1CloseOrderMt4PostAccountStatus>?
        apiV1CloseOrderMt4PostAccountStatus) {
  if (apiV1CloseOrderMt4PostAccountStatus == null) {
    return [];
  }

  return apiV1CloseOrderMt4PostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1CloseOrderMt4PostAccountStatus>
    apiV1CloseOrderMt4PostAccountStatusListFromJson(
  List? apiV1CloseOrderMt4PostAccountStatus, [
  List<enums.ApiV1CloseOrderMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseOrderMt4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseOrderMt4PostAccountStatus
      .map((e) => apiV1CloseOrderMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseOrderMt4PostAccountStatus>?
    apiV1CloseOrderMt4PostAccountStatusNullableListFromJson(
  List? apiV1CloseOrderMt4PostAccountStatus, [
  List<enums.ApiV1CloseOrderMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseOrderMt4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseOrderMt4PostAccountStatus
      .map((e) => apiV1CloseOrderMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1Mt4PartialCloseOrderPostAccountStatusNullableToJson(
    enums.ApiV1Mt4PartialCloseOrderPostAccountStatus?
        apiV1Mt4PartialCloseOrderPostAccountStatus) {
  return apiV1Mt4PartialCloseOrderPostAccountStatus?.value;
}

int? apiV1Mt4PartialCloseOrderPostAccountStatusToJson(
    enums.ApiV1Mt4PartialCloseOrderPostAccountStatus
        apiV1Mt4PartialCloseOrderPostAccountStatus) {
  return apiV1Mt4PartialCloseOrderPostAccountStatus.value;
}

enums.ApiV1Mt4PartialCloseOrderPostAccountStatus
    apiV1Mt4PartialCloseOrderPostAccountStatusFromJson(
  Object? apiV1Mt4PartialCloseOrderPostAccountStatus, [
  enums.ApiV1Mt4PartialCloseOrderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1Mt4PartialCloseOrderPostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1Mt4PartialCloseOrderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1Mt4PartialCloseOrderPostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1Mt4PartialCloseOrderPostAccountStatus?
    apiV1Mt4PartialCloseOrderPostAccountStatusNullableFromJson(
  Object? apiV1Mt4PartialCloseOrderPostAccountStatus, [
  enums.ApiV1Mt4PartialCloseOrderPostAccountStatus? defaultValue,
]) {
  if (apiV1Mt4PartialCloseOrderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1Mt4PartialCloseOrderPostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1Mt4PartialCloseOrderPostAccountStatus) ??
      defaultValue;
}

String apiV1Mt4PartialCloseOrderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1Mt4PartialCloseOrderPostAccountStatus>?
        apiV1Mt4PartialCloseOrderPostAccountStatus) {
  return apiV1Mt4PartialCloseOrderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1Mt4PartialCloseOrderPostAccountStatusListToJson(
    List<enums.ApiV1Mt4PartialCloseOrderPostAccountStatus>?
        apiV1Mt4PartialCloseOrderPostAccountStatus) {
  if (apiV1Mt4PartialCloseOrderPostAccountStatus == null) {
    return [];
  }

  return apiV1Mt4PartialCloseOrderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1Mt4PartialCloseOrderPostAccountStatus>
    apiV1Mt4PartialCloseOrderPostAccountStatusListFromJson(
  List? apiV1Mt4PartialCloseOrderPostAccountStatus, [
  List<enums.ApiV1Mt4PartialCloseOrderPostAccountStatus>? defaultValue,
]) {
  if (apiV1Mt4PartialCloseOrderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1Mt4PartialCloseOrderPostAccountStatus
      .map((e) =>
          apiV1Mt4PartialCloseOrderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1Mt4PartialCloseOrderPostAccountStatus>?
    apiV1Mt4PartialCloseOrderPostAccountStatusNullableListFromJson(
  List? apiV1Mt4PartialCloseOrderPostAccountStatus, [
  List<enums.ApiV1Mt4PartialCloseOrderPostAccountStatus>? defaultValue,
]) {
  if (apiV1Mt4PartialCloseOrderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1Mt4PartialCloseOrderPostAccountStatus
      .map((e) =>
          apiV1Mt4PartialCloseOrderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1SendPendingOrderMt4PostAccountStatusNullableToJson(
    enums.ApiV1SendPendingOrderMt4PostAccountStatus?
        apiV1SendPendingOrderMt4PostAccountStatus) {
  return apiV1SendPendingOrderMt4PostAccountStatus?.value;
}

int? apiV1SendPendingOrderMt4PostAccountStatusToJson(
    enums.ApiV1SendPendingOrderMt4PostAccountStatus
        apiV1SendPendingOrderMt4PostAccountStatus) {
  return apiV1SendPendingOrderMt4PostAccountStatus.value;
}

enums.ApiV1SendPendingOrderMt4PostAccountStatus
    apiV1SendPendingOrderMt4PostAccountStatusFromJson(
  Object? apiV1SendPendingOrderMt4PostAccountStatus, [
  enums.ApiV1SendPendingOrderMt4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1SendPendingOrderMt4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1SendPendingOrderMt4PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1SendPendingOrderMt4PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1SendPendingOrderMt4PostAccountStatus?
    apiV1SendPendingOrderMt4PostAccountStatusNullableFromJson(
  Object? apiV1SendPendingOrderMt4PostAccountStatus, [
  enums.ApiV1SendPendingOrderMt4PostAccountStatus? defaultValue,
]) {
  if (apiV1SendPendingOrderMt4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1SendPendingOrderMt4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1SendPendingOrderMt4PostAccountStatus) ??
      defaultValue;
}

String apiV1SendPendingOrderMt4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1SendPendingOrderMt4PostAccountStatus>?
        apiV1SendPendingOrderMt4PostAccountStatus) {
  return apiV1SendPendingOrderMt4PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1SendPendingOrderMt4PostAccountStatusListToJson(
    List<enums.ApiV1SendPendingOrderMt4PostAccountStatus>?
        apiV1SendPendingOrderMt4PostAccountStatus) {
  if (apiV1SendPendingOrderMt4PostAccountStatus == null) {
    return [];
  }

  return apiV1SendPendingOrderMt4PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1SendPendingOrderMt4PostAccountStatus>
    apiV1SendPendingOrderMt4PostAccountStatusListFromJson(
  List? apiV1SendPendingOrderMt4PostAccountStatus, [
  List<enums.ApiV1SendPendingOrderMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPendingOrderMt4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1SendPendingOrderMt4PostAccountStatus
      .map((e) =>
          apiV1SendPendingOrderMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1SendPendingOrderMt4PostAccountStatus>?
    apiV1SendPendingOrderMt4PostAccountStatusNullableListFromJson(
  List? apiV1SendPendingOrderMt4PostAccountStatus, [
  List<enums.ApiV1SendPendingOrderMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPendingOrderMt4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1SendPendingOrderMt4PostAccountStatus
      .map((e) =>
          apiV1SendPendingOrderMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ModifyPendingOrderMt4PostAccountStatusNullableToJson(
    enums.ApiV1ModifyPendingOrderMt4PostAccountStatus?
        apiV1ModifyPendingOrderMt4PostAccountStatus) {
  return apiV1ModifyPendingOrderMt4PostAccountStatus?.value;
}

int? apiV1ModifyPendingOrderMt4PostAccountStatusToJson(
    enums.ApiV1ModifyPendingOrderMt4PostAccountStatus
        apiV1ModifyPendingOrderMt4PostAccountStatus) {
  return apiV1ModifyPendingOrderMt4PostAccountStatus.value;
}

enums.ApiV1ModifyPendingOrderMt4PostAccountStatus
    apiV1ModifyPendingOrderMt4PostAccountStatusFromJson(
  Object? apiV1ModifyPendingOrderMt4PostAccountStatus, [
  enums.ApiV1ModifyPendingOrderMt4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyPendingOrderMt4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1ModifyPendingOrderMt4PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyPendingOrderMt4PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1ModifyPendingOrderMt4PostAccountStatus?
    apiV1ModifyPendingOrderMt4PostAccountStatusNullableFromJson(
  Object? apiV1ModifyPendingOrderMt4PostAccountStatus, [
  enums.ApiV1ModifyPendingOrderMt4PostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyPendingOrderMt4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyPendingOrderMt4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1ModifyPendingOrderMt4PostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyPendingOrderMt4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyPendingOrderMt4PostAccountStatus>?
        apiV1ModifyPendingOrderMt4PostAccountStatus) {
  return apiV1ModifyPendingOrderMt4PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ModifyPendingOrderMt4PostAccountStatusListToJson(
    List<enums.ApiV1ModifyPendingOrderMt4PostAccountStatus>?
        apiV1ModifyPendingOrderMt4PostAccountStatus) {
  if (apiV1ModifyPendingOrderMt4PostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyPendingOrderMt4PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ModifyPendingOrderMt4PostAccountStatus>
    apiV1ModifyPendingOrderMt4PostAccountStatusListFromJson(
  List? apiV1ModifyPendingOrderMt4PostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderMt4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyPendingOrderMt4PostAccountStatus
      .map((e) =>
          apiV1ModifyPendingOrderMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ModifyPendingOrderMt4PostAccountStatus>?
    apiV1ModifyPendingOrderMt4PostAccountStatusNullableListFromJson(
  List? apiV1ModifyPendingOrderMt4PostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderMt4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyPendingOrderMt4PostAccountStatus
      .map((e) =>
          apiV1ModifyPendingOrderMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ClosePendingOrderMt4PostAccountStatusNullableToJson(
    enums.ApiV1ClosePendingOrderMt4PostAccountStatus?
        apiV1ClosePendingOrderMt4PostAccountStatus) {
  return apiV1ClosePendingOrderMt4PostAccountStatus?.value;
}

int? apiV1ClosePendingOrderMt4PostAccountStatusToJson(
    enums.ApiV1ClosePendingOrderMt4PostAccountStatus
        apiV1ClosePendingOrderMt4PostAccountStatus) {
  return apiV1ClosePendingOrderMt4PostAccountStatus.value;
}

enums.ApiV1ClosePendingOrderMt4PostAccountStatus
    apiV1ClosePendingOrderMt4PostAccountStatusFromJson(
  Object? apiV1ClosePendingOrderMt4PostAccountStatus, [
  enums.ApiV1ClosePendingOrderMt4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ClosePendingOrderMt4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1ClosePendingOrderMt4PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ClosePendingOrderMt4PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1ClosePendingOrderMt4PostAccountStatus?
    apiV1ClosePendingOrderMt4PostAccountStatusNullableFromJson(
  Object? apiV1ClosePendingOrderMt4PostAccountStatus, [
  enums.ApiV1ClosePendingOrderMt4PostAccountStatus? defaultValue,
]) {
  if (apiV1ClosePendingOrderMt4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ClosePendingOrderMt4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1ClosePendingOrderMt4PostAccountStatus) ??
      defaultValue;
}

String apiV1ClosePendingOrderMt4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1ClosePendingOrderMt4PostAccountStatus>?
        apiV1ClosePendingOrderMt4PostAccountStatus) {
  return apiV1ClosePendingOrderMt4PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ClosePendingOrderMt4PostAccountStatusListToJson(
    List<enums.ApiV1ClosePendingOrderMt4PostAccountStatus>?
        apiV1ClosePendingOrderMt4PostAccountStatus) {
  if (apiV1ClosePendingOrderMt4PostAccountStatus == null) {
    return [];
  }

  return apiV1ClosePendingOrderMt4PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ClosePendingOrderMt4PostAccountStatus>
    apiV1ClosePendingOrderMt4PostAccountStatusListFromJson(
  List? apiV1ClosePendingOrderMt4PostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderMt4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ClosePendingOrderMt4PostAccountStatus
      .map((e) =>
          apiV1ClosePendingOrderMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ClosePendingOrderMt4PostAccountStatus>?
    apiV1ClosePendingOrderMt4PostAccountStatusNullableListFromJson(
  List? apiV1ClosePendingOrderMt4PostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderMt4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ClosePendingOrderMt4PostAccountStatus
      .map((e) =>
          apiV1ClosePendingOrderMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseAllOrdersForMT4PostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrdersForMT4PostAccountStatus?
        apiV1CloseAllOrdersForMT4PostAccountStatus) {
  return apiV1CloseAllOrdersForMT4PostAccountStatus?.value;
}

int? apiV1CloseAllOrdersForMT4PostAccountStatusToJson(
    enums.ApiV1CloseAllOrdersForMT4PostAccountStatus
        apiV1CloseAllOrdersForMT4PostAccountStatus) {
  return apiV1CloseAllOrdersForMT4PostAccountStatus.value;
}

enums.ApiV1CloseAllOrdersForMT4PostAccountStatus
    apiV1CloseAllOrdersForMT4PostAccountStatusFromJson(
  Object? apiV1CloseAllOrdersForMT4PostAccountStatus, [
  enums.ApiV1CloseAllOrdersForMT4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrdersForMT4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrdersForMT4PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrdersForMT4PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrdersForMT4PostAccountStatus?
    apiV1CloseAllOrdersForMT4PostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrdersForMT4PostAccountStatus, [
  enums.ApiV1CloseAllOrdersForMT4PostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrdersForMT4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrdersForMT4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrdersForMT4PostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrdersForMT4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrdersForMT4PostAccountStatus>?
        apiV1CloseAllOrdersForMT4PostAccountStatus) {
  return apiV1CloseAllOrdersForMT4PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrdersForMT4PostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrdersForMT4PostAccountStatus>?
        apiV1CloseAllOrdersForMT4PostAccountStatus) {
  if (apiV1CloseAllOrdersForMT4PostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrdersForMT4PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrdersForMT4PostAccountStatus>
    apiV1CloseAllOrdersForMT4PostAccountStatusListFromJson(
  List? apiV1CloseAllOrdersForMT4PostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForMT4PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForMT4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrdersForMT4PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrdersForMT4PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrdersForMT4PostAccountStatus>?
    apiV1CloseAllOrdersForMT4PostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrdersForMT4PostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForMT4PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForMT4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrdersForMT4PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrdersForMT4PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySymbolForMT4PostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus?
        apiV1CloseAllOrderBySymbolForMT4PostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForMT4PostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySymbolForMT4PostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus
        apiV1CloseAllOrderBySymbolForMT4PostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForMT4PostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus
    apiV1CloseAllOrderBySymbolForMT4PostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySymbolForMT4PostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderBySymbolForMT4PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus?
    apiV1CloseAllOrderBySymbolForMT4PostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySymbolForMT4PostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForMT4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderBySymbolForMT4PostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderBySymbolForMT4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus>?
        apiV1CloseAllOrderBySymbolForMT4PostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForMT4PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySymbolForMT4PostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus>?
        apiV1CloseAllOrderBySymbolForMT4PostAccountStatus) {
  if (apiV1CloseAllOrderBySymbolForMT4PostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySymbolForMT4PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus>
    apiV1CloseAllOrderBySymbolForMT4PostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySymbolForMT4PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForMT4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySymbolForMT4PostAccountStatus
      .map((e) => apiV1CloseAllOrderBySymbolForMT4PostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus>?
    apiV1CloseAllOrderBySymbolForMT4PostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySymbolForMT4PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForMT4PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForMT4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySymbolForMT4PostAccountStatus
      .map((e) => apiV1CloseAllOrderBySymbolForMT4PostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySellMT4PostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus?
        apiV1CloseAllOrderBySellMT4PostAccountStatus) {
  return apiV1CloseAllOrderBySellMT4PostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySellMT4PostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus
        apiV1CloseAllOrderBySellMT4PostAccountStatus) {
  return apiV1CloseAllOrderBySellMT4PostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus
    apiV1CloseAllOrderBySellMT4PostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySellMT4PostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrderBySellMT4PostAccountStatus) ??
      defaultValue ??
      enums
          .ApiV1CloseAllOrderBySellMT4PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus?
    apiV1CloseAllOrderBySellMT4PostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySellMT4PostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellMT4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrderBySellMT4PostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderBySellMT4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus>?
        apiV1CloseAllOrderBySellMT4PostAccountStatus) {
  return apiV1CloseAllOrderBySellMT4PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySellMT4PostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus>?
        apiV1CloseAllOrderBySellMT4PostAccountStatus) {
  if (apiV1CloseAllOrderBySellMT4PostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySellMT4PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus>
    apiV1CloseAllOrderBySellMT4PostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySellMT4PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellMT4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySellMT4PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySellMT4PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus>?
    apiV1CloseAllOrderBySellMT4PostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySellMT4PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellMT4PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellMT4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySellMT4PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySellMT4PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseAllOrderByBuyMT4PostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus?
        apiV1CloseAllOrderByBuyMT4PostAccountStatus) {
  return apiV1CloseAllOrderByBuyMT4PostAccountStatus?.value;
}

int? apiV1CloseAllOrderByBuyMT4PostAccountStatusToJson(
    enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus
        apiV1CloseAllOrderByBuyMT4PostAccountStatus) {
  return apiV1CloseAllOrderByBuyMT4PostAccountStatus.value;
}

enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus
    apiV1CloseAllOrderByBuyMT4PostAccountStatusFromJson(
  Object? apiV1CloseAllOrderByBuyMT4PostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrderByBuyMT4PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus?
    apiV1CloseAllOrderByBuyMT4PostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderByBuyMT4PostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyMT4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrderByBuyMT4PostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderByBuyMT4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus>?
        apiV1CloseAllOrderByBuyMT4PostAccountStatus) {
  return apiV1CloseAllOrderByBuyMT4PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderByBuyMT4PostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus>?
        apiV1CloseAllOrderByBuyMT4PostAccountStatus) {
  if (apiV1CloseAllOrderByBuyMT4PostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderByBuyMT4PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus>
    apiV1CloseAllOrderByBuyMT4PostAccountStatusListFromJson(
  List? apiV1CloseAllOrderByBuyMT4PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyMT4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderByBuyMT4PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderByBuyMT4PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus>?
    apiV1CloseAllOrderByBuyMT4PostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderByBuyMT4PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyMT4PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyMT4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderByBuyMT4PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderByBuyMT4PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrderHistoryMt4PostAccountStatusNullableToJson(
    enums.ApiV1GetOrderHistoryMt4PostAccountStatus?
        apiV1GetOrderHistoryMt4PostAccountStatus) {
  return apiV1GetOrderHistoryMt4PostAccountStatus?.value;
}

int? apiV1GetOrderHistoryMt4PostAccountStatusToJson(
    enums.ApiV1GetOrderHistoryMt4PostAccountStatus
        apiV1GetOrderHistoryMt4PostAccountStatus) {
  return apiV1GetOrderHistoryMt4PostAccountStatus.value;
}

enums.ApiV1GetOrderHistoryMt4PostAccountStatus
    apiV1GetOrderHistoryMt4PostAccountStatusFromJson(
  Object? apiV1GetOrderHistoryMt4PostAccountStatus, [
  enums.ApiV1GetOrderHistoryMt4PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrderHistoryMt4PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1GetOrderHistoryMt4PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetOrderHistoryMt4PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetOrderHistoryMt4PostAccountStatus?
    apiV1GetOrderHistoryMt4PostAccountStatusNullableFromJson(
  Object? apiV1GetOrderHistoryMt4PostAccountStatus, [
  enums.ApiV1GetOrderHistoryMt4PostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrderHistoryMt4PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrderHistoryMt4PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1GetOrderHistoryMt4PostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrderHistoryMt4PostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrderHistoryMt4PostAccountStatus>?
        apiV1GetOrderHistoryMt4PostAccountStatus) {
  return apiV1GetOrderHistoryMt4PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetOrderHistoryMt4PostAccountStatusListToJson(
    List<enums.ApiV1GetOrderHistoryMt4PostAccountStatus>?
        apiV1GetOrderHistoryMt4PostAccountStatus) {
  if (apiV1GetOrderHistoryMt4PostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrderHistoryMt4PostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1GetOrderHistoryMt4PostAccountStatus>
    apiV1GetOrderHistoryMt4PostAccountStatusListFromJson(
  List? apiV1GetOrderHistoryMt4PostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryMt4PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrderHistoryMt4PostAccountStatus
      .map(
          (e) => apiV1GetOrderHistoryMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetOrderHistoryMt4PostAccountStatus>?
    apiV1GetOrderHistoryMt4PostAccountStatusNullableListFromJson(
  List? apiV1GetOrderHistoryMt4PostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryMt4PostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryMt4PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrderHistoryMt4PostAccountStatus
      .map(
          (e) => apiV1GetOrderHistoryMt4PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1Mt4UpdateRiskPostRiskTypeNullableToJson(
    enums.ApiV1Mt4UpdateRiskPostRiskType? apiV1Mt4UpdateRiskPostRiskType) {
  return apiV1Mt4UpdateRiskPostRiskType?.value;
}

int? apiV1Mt4UpdateRiskPostRiskTypeToJson(
    enums.ApiV1Mt4UpdateRiskPostRiskType apiV1Mt4UpdateRiskPostRiskType) {
  return apiV1Mt4UpdateRiskPostRiskType.value;
}

enums.ApiV1Mt4UpdateRiskPostRiskType apiV1Mt4UpdateRiskPostRiskTypeFromJson(
  Object? apiV1Mt4UpdateRiskPostRiskType, [
  enums.ApiV1Mt4UpdateRiskPostRiskType? defaultValue,
]) {
  return enums.ApiV1Mt4UpdateRiskPostRiskType.values
          .firstWhereOrNull((e) => e.value == apiV1Mt4UpdateRiskPostRiskType) ??
      defaultValue ??
      enums.ApiV1Mt4UpdateRiskPostRiskType.swaggerGeneratedUnknown;
}

enums.ApiV1Mt4UpdateRiskPostRiskType?
    apiV1Mt4UpdateRiskPostRiskTypeNullableFromJson(
  Object? apiV1Mt4UpdateRiskPostRiskType, [
  enums.ApiV1Mt4UpdateRiskPostRiskType? defaultValue,
]) {
  if (apiV1Mt4UpdateRiskPostRiskType == null) {
    return null;
  }
  return enums.ApiV1Mt4UpdateRiskPostRiskType.values
          .firstWhereOrNull((e) => e.value == apiV1Mt4UpdateRiskPostRiskType) ??
      defaultValue;
}

String apiV1Mt4UpdateRiskPostRiskTypeExplodedListToJson(
    List<enums.ApiV1Mt4UpdateRiskPostRiskType>?
        apiV1Mt4UpdateRiskPostRiskType) {
  return apiV1Mt4UpdateRiskPostRiskType?.map((e) => e.value!).join(',') ?? '';
}

List<int> apiV1Mt4UpdateRiskPostRiskTypeListToJson(
    List<enums.ApiV1Mt4UpdateRiskPostRiskType>?
        apiV1Mt4UpdateRiskPostRiskType) {
  if (apiV1Mt4UpdateRiskPostRiskType == null) {
    return [];
  }

  return apiV1Mt4UpdateRiskPostRiskType.map((e) => e.value!).toList();
}

List<enums.ApiV1Mt4UpdateRiskPostRiskType>
    apiV1Mt4UpdateRiskPostRiskTypeListFromJson(
  List? apiV1Mt4UpdateRiskPostRiskType, [
  List<enums.ApiV1Mt4UpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1Mt4UpdateRiskPostRiskType == null) {
    return defaultValue ?? [];
  }

  return apiV1Mt4UpdateRiskPostRiskType
      .map((e) => apiV1Mt4UpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1Mt4UpdateRiskPostRiskType>?
    apiV1Mt4UpdateRiskPostRiskTypeNullableListFromJson(
  List? apiV1Mt4UpdateRiskPostRiskType, [
  List<enums.ApiV1Mt4UpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1Mt4UpdateRiskPostRiskType == null) {
    return defaultValue;
  }

  return apiV1Mt4UpdateRiskPostRiskType
      .map((e) => apiV1Mt4UpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

int? apiV1Mt4UpdateStopsLimitsPostScalperModeNullableToJson(
    enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode?
        apiV1Mt4UpdateStopsLimitsPostScalperMode) {
  return apiV1Mt4UpdateStopsLimitsPostScalperMode?.value;
}

int? apiV1Mt4UpdateStopsLimitsPostScalperModeToJson(
    enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode
        apiV1Mt4UpdateStopsLimitsPostScalperMode) {
  return apiV1Mt4UpdateStopsLimitsPostScalperMode.value;
}

enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode
    apiV1Mt4UpdateStopsLimitsPostScalperModeFromJson(
  Object? apiV1Mt4UpdateStopsLimitsPostScalperMode, [
  enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  return enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode.values.firstWhereOrNull(
          (e) => e.value == apiV1Mt4UpdateStopsLimitsPostScalperMode) ??
      defaultValue ??
      enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode.swaggerGeneratedUnknown;
}

enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode?
    apiV1Mt4UpdateStopsLimitsPostScalperModeNullableFromJson(
  Object? apiV1Mt4UpdateStopsLimitsPostScalperMode, [
  enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  if (apiV1Mt4UpdateStopsLimitsPostScalperMode == null) {
    return null;
  }
  return enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode.values.firstWhereOrNull(
          (e) => e.value == apiV1Mt4UpdateStopsLimitsPostScalperMode) ??
      defaultValue;
}

String apiV1Mt4UpdateStopsLimitsPostScalperModeExplodedListToJson(
    List<enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode>?
        apiV1Mt4UpdateStopsLimitsPostScalperMode) {
  return apiV1Mt4UpdateStopsLimitsPostScalperMode
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1Mt4UpdateStopsLimitsPostScalperModeListToJson(
    List<enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode>?
        apiV1Mt4UpdateStopsLimitsPostScalperMode) {
  if (apiV1Mt4UpdateStopsLimitsPostScalperMode == null) {
    return [];
  }

  return apiV1Mt4UpdateStopsLimitsPostScalperMode.map((e) => e.value!).toList();
}

List<enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode>
    apiV1Mt4UpdateStopsLimitsPostScalperModeListFromJson(
  List? apiV1Mt4UpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1Mt4UpdateStopsLimitsPostScalperMode == null) {
    return defaultValue ?? [];
  }

  return apiV1Mt4UpdateStopsLimitsPostScalperMode
      .map(
          (e) => apiV1Mt4UpdateStopsLimitsPostScalperModeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode>?
    apiV1Mt4UpdateStopsLimitsPostScalperModeNullableListFromJson(
  List? apiV1Mt4UpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1Mt4UpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1Mt4UpdateStopsLimitsPostScalperMode == null) {
    return defaultValue;
  }

  return apiV1Mt4UpdateStopsLimitsPostScalperMode
      .map(
          (e) => apiV1Mt4UpdateStopsLimitsPostScalperModeFromJson(e.toString()))
      .toList();
}

int? apiV1Mt4UpdateStopsLimitsPostOrderFilterNullableToJson(
    enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter?
        apiV1Mt4UpdateStopsLimitsPostOrderFilter) {
  return apiV1Mt4UpdateStopsLimitsPostOrderFilter?.value;
}

int? apiV1Mt4UpdateStopsLimitsPostOrderFilterToJson(
    enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter
        apiV1Mt4UpdateStopsLimitsPostOrderFilter) {
  return apiV1Mt4UpdateStopsLimitsPostOrderFilter.value;
}

enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter
    apiV1Mt4UpdateStopsLimitsPostOrderFilterFromJson(
  Object? apiV1Mt4UpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  return enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter.values.firstWhereOrNull(
          (e) => e.value == apiV1Mt4UpdateStopsLimitsPostOrderFilter) ??
      defaultValue ??
      enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter.swaggerGeneratedUnknown;
}

enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter?
    apiV1Mt4UpdateStopsLimitsPostOrderFilterNullableFromJson(
  Object? apiV1Mt4UpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  if (apiV1Mt4UpdateStopsLimitsPostOrderFilter == null) {
    return null;
  }
  return enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter.values.firstWhereOrNull(
          (e) => e.value == apiV1Mt4UpdateStopsLimitsPostOrderFilter) ??
      defaultValue;
}

String apiV1Mt4UpdateStopsLimitsPostOrderFilterExplodedListToJson(
    List<enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter>?
        apiV1Mt4UpdateStopsLimitsPostOrderFilter) {
  return apiV1Mt4UpdateStopsLimitsPostOrderFilter
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1Mt4UpdateStopsLimitsPostOrderFilterListToJson(
    List<enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter>?
        apiV1Mt4UpdateStopsLimitsPostOrderFilter) {
  if (apiV1Mt4UpdateStopsLimitsPostOrderFilter == null) {
    return [];
  }

  return apiV1Mt4UpdateStopsLimitsPostOrderFilter.map((e) => e.value!).toList();
}

List<enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter>
    apiV1Mt4UpdateStopsLimitsPostOrderFilterListFromJson(
  List? apiV1Mt4UpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1Mt4UpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue ?? [];
  }

  return apiV1Mt4UpdateStopsLimitsPostOrderFilter
      .map(
          (e) => apiV1Mt4UpdateStopsLimitsPostOrderFilterFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter>?
    apiV1Mt4UpdateStopsLimitsPostOrderFilterNullableListFromJson(
  List? apiV1Mt4UpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1Mt4UpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1Mt4UpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue;
  }

  return apiV1Mt4UpdateStopsLimitsPostOrderFilter
      .map(
          (e) => apiV1Mt4UpdateStopsLimitsPostOrderFilterFromJson(e.toString()))
      .toList();
}

int? apiV1SendOrderMt5PostAccountStatusNullableToJson(
    enums.ApiV1SendOrderMt5PostAccountStatus?
        apiV1SendOrderMt5PostAccountStatus) {
  return apiV1SendOrderMt5PostAccountStatus?.value;
}

int? apiV1SendOrderMt5PostAccountStatusToJson(
    enums.ApiV1SendOrderMt5PostAccountStatus
        apiV1SendOrderMt5PostAccountStatus) {
  return apiV1SendOrderMt5PostAccountStatus.value;
}

enums.ApiV1SendOrderMt5PostAccountStatus
    apiV1SendOrderMt5PostAccountStatusFromJson(
  Object? apiV1SendOrderMt5PostAccountStatus, [
  enums.ApiV1SendOrderMt5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1SendOrderMt5PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1SendOrderMt5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1SendOrderMt5PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1SendOrderMt5PostAccountStatus?
    apiV1SendOrderMt5PostAccountStatusNullableFromJson(
  Object? apiV1SendOrderMt5PostAccountStatus, [
  enums.ApiV1SendOrderMt5PostAccountStatus? defaultValue,
]) {
  if (apiV1SendOrderMt5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1SendOrderMt5PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1SendOrderMt5PostAccountStatus) ??
      defaultValue;
}

String apiV1SendOrderMt5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1SendOrderMt5PostAccountStatus>?
        apiV1SendOrderMt5PostAccountStatus) {
  return apiV1SendOrderMt5PostAccountStatus?.map((e) => e.value!).join(',') ??
      '';
}

List<int> apiV1SendOrderMt5PostAccountStatusListToJson(
    List<enums.ApiV1SendOrderMt5PostAccountStatus>?
        apiV1SendOrderMt5PostAccountStatus) {
  if (apiV1SendOrderMt5PostAccountStatus == null) {
    return [];
  }

  return apiV1SendOrderMt5PostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1SendOrderMt5PostAccountStatus>
    apiV1SendOrderMt5PostAccountStatusListFromJson(
  List? apiV1SendOrderMt5PostAccountStatus, [
  List<enums.ApiV1SendOrderMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1SendOrderMt5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1SendOrderMt5PostAccountStatus
      .map((e) => apiV1SendOrderMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1SendOrderMt5PostAccountStatus>?
    apiV1SendOrderMt5PostAccountStatusNullableListFromJson(
  List? apiV1SendOrderMt5PostAccountStatus, [
  List<enums.ApiV1SendOrderMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1SendOrderMt5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1SendOrderMt5PostAccountStatus
      .map((e) => apiV1SendOrderMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrdersMt5PostAccountStatusNullableToJson(
    enums.ApiV1GetOrdersMt5PostAccountStatus?
        apiV1GetOrdersMt5PostAccountStatus) {
  return apiV1GetOrdersMt5PostAccountStatus?.value;
}

int? apiV1GetOrdersMt5PostAccountStatusToJson(
    enums.ApiV1GetOrdersMt5PostAccountStatus
        apiV1GetOrdersMt5PostAccountStatus) {
  return apiV1GetOrdersMt5PostAccountStatus.value;
}

enums.ApiV1GetOrdersMt5PostAccountStatus
    apiV1GetOrdersMt5PostAccountStatusFromJson(
  Object? apiV1GetOrdersMt5PostAccountStatus, [
  enums.ApiV1GetOrdersMt5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrdersMt5PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1GetOrdersMt5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetOrdersMt5PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetOrdersMt5PostAccountStatus?
    apiV1GetOrdersMt5PostAccountStatusNullableFromJson(
  Object? apiV1GetOrdersMt5PostAccountStatus, [
  enums.ApiV1GetOrdersMt5PostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrdersMt5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrdersMt5PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1GetOrdersMt5PostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrdersMt5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrdersMt5PostAccountStatus>?
        apiV1GetOrdersMt5PostAccountStatus) {
  return apiV1GetOrdersMt5PostAccountStatus?.map((e) => e.value!).join(',') ??
      '';
}

List<int> apiV1GetOrdersMt5PostAccountStatusListToJson(
    List<enums.ApiV1GetOrdersMt5PostAccountStatus>?
        apiV1GetOrdersMt5PostAccountStatus) {
  if (apiV1GetOrdersMt5PostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrdersMt5PostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1GetOrdersMt5PostAccountStatus>
    apiV1GetOrdersMt5PostAccountStatusListFromJson(
  List? apiV1GetOrdersMt5PostAccountStatus, [
  List<enums.ApiV1GetOrdersMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrdersMt5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrdersMt5PostAccountStatus
      .map((e) => apiV1GetOrdersMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetOrdersMt5PostAccountStatus>?
    apiV1GetOrdersMt5PostAccountStatusNullableListFromJson(
  List? apiV1GetOrdersMt5PostAccountStatus, [
  List<enums.ApiV1GetOrdersMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrdersMt5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrdersMt5PostAccountStatus
      .map((e) => apiV1GetOrdersMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ModifyOrderMt5PostAccountStatusNullableToJson(
    enums.ApiV1ModifyOrderMt5PostAccountStatus?
        apiV1ModifyOrderMt5PostAccountStatus) {
  return apiV1ModifyOrderMt5PostAccountStatus?.value;
}

int? apiV1ModifyOrderMt5PostAccountStatusToJson(
    enums.ApiV1ModifyOrderMt5PostAccountStatus
        apiV1ModifyOrderMt5PostAccountStatus) {
  return apiV1ModifyOrderMt5PostAccountStatus.value;
}

enums.ApiV1ModifyOrderMt5PostAccountStatus
    apiV1ModifyOrderMt5PostAccountStatusFromJson(
  Object? apiV1ModifyOrderMt5PostAccountStatus, [
  enums.ApiV1ModifyOrderMt5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyOrderMt5PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1ModifyOrderMt5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyOrderMt5PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1ModifyOrderMt5PostAccountStatus?
    apiV1ModifyOrderMt5PostAccountStatusNullableFromJson(
  Object? apiV1ModifyOrderMt5PostAccountStatus, [
  enums.ApiV1ModifyOrderMt5PostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyOrderMt5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyOrderMt5PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1ModifyOrderMt5PostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyOrderMt5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyOrderMt5PostAccountStatus>?
        apiV1ModifyOrderMt5PostAccountStatus) {
  return apiV1ModifyOrderMt5PostAccountStatus?.map((e) => e.value!).join(',') ??
      '';
}

List<int> apiV1ModifyOrderMt5PostAccountStatusListToJson(
    List<enums.ApiV1ModifyOrderMt5PostAccountStatus>?
        apiV1ModifyOrderMt5PostAccountStatus) {
  if (apiV1ModifyOrderMt5PostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyOrderMt5PostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1ModifyOrderMt5PostAccountStatus>
    apiV1ModifyOrderMt5PostAccountStatusListFromJson(
  List? apiV1ModifyOrderMt5PostAccountStatus, [
  List<enums.ApiV1ModifyOrderMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyOrderMt5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyOrderMt5PostAccountStatus
      .map((e) => apiV1ModifyOrderMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ModifyOrderMt5PostAccountStatus>?
    apiV1ModifyOrderMt5PostAccountStatusNullableListFromJson(
  List? apiV1ModifyOrderMt5PostAccountStatus, [
  List<enums.ApiV1ModifyOrderMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyOrderMt5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyOrderMt5PostAccountStatus
      .map((e) => apiV1ModifyOrderMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseOrderForMT5PostAccountStatusNullableToJson(
    enums.ApiV1CloseOrderForMT5PostAccountStatus?
        apiV1CloseOrderForMT5PostAccountStatus) {
  return apiV1CloseOrderForMT5PostAccountStatus?.value;
}

int? apiV1CloseOrderForMT5PostAccountStatusToJson(
    enums.ApiV1CloseOrderForMT5PostAccountStatus
        apiV1CloseOrderForMT5PostAccountStatus) {
  return apiV1CloseOrderForMT5PostAccountStatus.value;
}

enums.ApiV1CloseOrderForMT5PostAccountStatus
    apiV1CloseOrderForMT5PostAccountStatusFromJson(
  Object? apiV1CloseOrderForMT5PostAccountStatus, [
  enums.ApiV1CloseOrderForMT5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseOrderForMT5PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1CloseOrderForMT5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseOrderForMT5PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1CloseOrderForMT5PostAccountStatus?
    apiV1CloseOrderForMT5PostAccountStatusNullableFromJson(
  Object? apiV1CloseOrderForMT5PostAccountStatus, [
  enums.ApiV1CloseOrderForMT5PostAccountStatus? defaultValue,
]) {
  if (apiV1CloseOrderForMT5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseOrderForMT5PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1CloseOrderForMT5PostAccountStatus) ??
      defaultValue;
}

String apiV1CloseOrderForMT5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseOrderForMT5PostAccountStatus>?
        apiV1CloseOrderForMT5PostAccountStatus) {
  return apiV1CloseOrderForMT5PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseOrderForMT5PostAccountStatusListToJson(
    List<enums.ApiV1CloseOrderForMT5PostAccountStatus>?
        apiV1CloseOrderForMT5PostAccountStatus) {
  if (apiV1CloseOrderForMT5PostAccountStatus == null) {
    return [];
  }

  return apiV1CloseOrderForMT5PostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1CloseOrderForMT5PostAccountStatus>
    apiV1CloseOrderForMT5PostAccountStatusListFromJson(
  List? apiV1CloseOrderForMT5PostAccountStatus, [
  List<enums.ApiV1CloseOrderForMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseOrderForMT5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseOrderForMT5PostAccountStatus
      .map((e) => apiV1CloseOrderForMT5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseOrderForMT5PostAccountStatus>?
    apiV1CloseOrderForMT5PostAccountStatusNullableListFromJson(
  List? apiV1CloseOrderForMT5PostAccountStatus, [
  List<enums.ApiV1CloseOrderForMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseOrderForMT5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseOrderForMT5PostAccountStatus
      .map((e) => apiV1CloseOrderForMT5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1Mt5PartialCloseOrderPostAccountStatusNullableToJson(
    enums.ApiV1Mt5PartialCloseOrderPostAccountStatus?
        apiV1Mt5PartialCloseOrderPostAccountStatus) {
  return apiV1Mt5PartialCloseOrderPostAccountStatus?.value;
}

int? apiV1Mt5PartialCloseOrderPostAccountStatusToJson(
    enums.ApiV1Mt5PartialCloseOrderPostAccountStatus
        apiV1Mt5PartialCloseOrderPostAccountStatus) {
  return apiV1Mt5PartialCloseOrderPostAccountStatus.value;
}

enums.ApiV1Mt5PartialCloseOrderPostAccountStatus
    apiV1Mt5PartialCloseOrderPostAccountStatusFromJson(
  Object? apiV1Mt5PartialCloseOrderPostAccountStatus, [
  enums.ApiV1Mt5PartialCloseOrderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1Mt5PartialCloseOrderPostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1Mt5PartialCloseOrderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1Mt5PartialCloseOrderPostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1Mt5PartialCloseOrderPostAccountStatus?
    apiV1Mt5PartialCloseOrderPostAccountStatusNullableFromJson(
  Object? apiV1Mt5PartialCloseOrderPostAccountStatus, [
  enums.ApiV1Mt5PartialCloseOrderPostAccountStatus? defaultValue,
]) {
  if (apiV1Mt5PartialCloseOrderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1Mt5PartialCloseOrderPostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1Mt5PartialCloseOrderPostAccountStatus) ??
      defaultValue;
}

String apiV1Mt5PartialCloseOrderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1Mt5PartialCloseOrderPostAccountStatus>?
        apiV1Mt5PartialCloseOrderPostAccountStatus) {
  return apiV1Mt5PartialCloseOrderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1Mt5PartialCloseOrderPostAccountStatusListToJson(
    List<enums.ApiV1Mt5PartialCloseOrderPostAccountStatus>?
        apiV1Mt5PartialCloseOrderPostAccountStatus) {
  if (apiV1Mt5PartialCloseOrderPostAccountStatus == null) {
    return [];
  }

  return apiV1Mt5PartialCloseOrderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1Mt5PartialCloseOrderPostAccountStatus>
    apiV1Mt5PartialCloseOrderPostAccountStatusListFromJson(
  List? apiV1Mt5PartialCloseOrderPostAccountStatus, [
  List<enums.ApiV1Mt5PartialCloseOrderPostAccountStatus>? defaultValue,
]) {
  if (apiV1Mt5PartialCloseOrderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1Mt5PartialCloseOrderPostAccountStatus
      .map((e) =>
          apiV1Mt5PartialCloseOrderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1Mt5PartialCloseOrderPostAccountStatus>?
    apiV1Mt5PartialCloseOrderPostAccountStatusNullableListFromJson(
  List? apiV1Mt5PartialCloseOrderPostAccountStatus, [
  List<enums.ApiV1Mt5PartialCloseOrderPostAccountStatus>? defaultValue,
]) {
  if (apiV1Mt5PartialCloseOrderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1Mt5PartialCloseOrderPostAccountStatus
      .map((e) =>
          apiV1Mt5PartialCloseOrderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1SendPendingOrderMt5PostAccountStatusNullableToJson(
    enums.ApiV1SendPendingOrderMt5PostAccountStatus?
        apiV1SendPendingOrderMt5PostAccountStatus) {
  return apiV1SendPendingOrderMt5PostAccountStatus?.value;
}

int? apiV1SendPendingOrderMt5PostAccountStatusToJson(
    enums.ApiV1SendPendingOrderMt5PostAccountStatus
        apiV1SendPendingOrderMt5PostAccountStatus) {
  return apiV1SendPendingOrderMt5PostAccountStatus.value;
}

enums.ApiV1SendPendingOrderMt5PostAccountStatus
    apiV1SendPendingOrderMt5PostAccountStatusFromJson(
  Object? apiV1SendPendingOrderMt5PostAccountStatus, [
  enums.ApiV1SendPendingOrderMt5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1SendPendingOrderMt5PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1SendPendingOrderMt5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1SendPendingOrderMt5PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1SendPendingOrderMt5PostAccountStatus?
    apiV1SendPendingOrderMt5PostAccountStatusNullableFromJson(
  Object? apiV1SendPendingOrderMt5PostAccountStatus, [
  enums.ApiV1SendPendingOrderMt5PostAccountStatus? defaultValue,
]) {
  if (apiV1SendPendingOrderMt5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1SendPendingOrderMt5PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1SendPendingOrderMt5PostAccountStatus) ??
      defaultValue;
}

String apiV1SendPendingOrderMt5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1SendPendingOrderMt5PostAccountStatus>?
        apiV1SendPendingOrderMt5PostAccountStatus) {
  return apiV1SendPendingOrderMt5PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1SendPendingOrderMt5PostAccountStatusListToJson(
    List<enums.ApiV1SendPendingOrderMt5PostAccountStatus>?
        apiV1SendPendingOrderMt5PostAccountStatus) {
  if (apiV1SendPendingOrderMt5PostAccountStatus == null) {
    return [];
  }

  return apiV1SendPendingOrderMt5PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1SendPendingOrderMt5PostAccountStatus>
    apiV1SendPendingOrderMt5PostAccountStatusListFromJson(
  List? apiV1SendPendingOrderMt5PostAccountStatus, [
  List<enums.ApiV1SendPendingOrderMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPendingOrderMt5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1SendPendingOrderMt5PostAccountStatus
      .map((e) =>
          apiV1SendPendingOrderMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1SendPendingOrderMt5PostAccountStatus>?
    apiV1SendPendingOrderMt5PostAccountStatusNullableListFromJson(
  List? apiV1SendPendingOrderMt5PostAccountStatus, [
  List<enums.ApiV1SendPendingOrderMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPendingOrderMt5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1SendPendingOrderMt5PostAccountStatus
      .map((e) =>
          apiV1SendPendingOrderMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ModifyPendingOrderForMT5PostAccountStatusNullableToJson(
    enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus?
        apiV1ModifyPendingOrderForMT5PostAccountStatus) {
  return apiV1ModifyPendingOrderForMT5PostAccountStatus?.value;
}

int? apiV1ModifyPendingOrderForMT5PostAccountStatusToJson(
    enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus
        apiV1ModifyPendingOrderForMT5PostAccountStatus) {
  return apiV1ModifyPendingOrderForMT5PostAccountStatus.value;
}

enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus
    apiV1ModifyPendingOrderForMT5PostAccountStatusFromJson(
  Object? apiV1ModifyPendingOrderForMT5PostAccountStatus, [
  enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPendingOrderForMT5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus?
    apiV1ModifyPendingOrderForMT5PostAccountStatusNullableFromJson(
  Object? apiV1ModifyPendingOrderForMT5PostAccountStatus, [
  enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyPendingOrderForMT5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPendingOrderForMT5PostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyPendingOrderForMT5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus>?
        apiV1ModifyPendingOrderForMT5PostAccountStatus) {
  return apiV1ModifyPendingOrderForMT5PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ModifyPendingOrderForMT5PostAccountStatusListToJson(
    List<enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus>?
        apiV1ModifyPendingOrderForMT5PostAccountStatus) {
  if (apiV1ModifyPendingOrderForMT5PostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyPendingOrderForMT5PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus>
    apiV1ModifyPendingOrderForMT5PostAccountStatusListFromJson(
  List? apiV1ModifyPendingOrderForMT5PostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderForMT5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyPendingOrderForMT5PostAccountStatus
      .map((e) =>
          apiV1ModifyPendingOrderForMT5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus>?
    apiV1ModifyPendingOrderForMT5PostAccountStatusNullableListFromJson(
  List? apiV1ModifyPendingOrderForMT5PostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderForMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderForMT5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyPendingOrderForMT5PostAccountStatus
      .map((e) =>
          apiV1ModifyPendingOrderForMT5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ClosePendingOrderMt5PostAccountStatusNullableToJson(
    enums.ApiV1ClosePendingOrderMt5PostAccountStatus?
        apiV1ClosePendingOrderMt5PostAccountStatus) {
  return apiV1ClosePendingOrderMt5PostAccountStatus?.value;
}

int? apiV1ClosePendingOrderMt5PostAccountStatusToJson(
    enums.ApiV1ClosePendingOrderMt5PostAccountStatus
        apiV1ClosePendingOrderMt5PostAccountStatus) {
  return apiV1ClosePendingOrderMt5PostAccountStatus.value;
}

enums.ApiV1ClosePendingOrderMt5PostAccountStatus
    apiV1ClosePendingOrderMt5PostAccountStatusFromJson(
  Object? apiV1ClosePendingOrderMt5PostAccountStatus, [
  enums.ApiV1ClosePendingOrderMt5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ClosePendingOrderMt5PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1ClosePendingOrderMt5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ClosePendingOrderMt5PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1ClosePendingOrderMt5PostAccountStatus?
    apiV1ClosePendingOrderMt5PostAccountStatusNullableFromJson(
  Object? apiV1ClosePendingOrderMt5PostAccountStatus, [
  enums.ApiV1ClosePendingOrderMt5PostAccountStatus? defaultValue,
]) {
  if (apiV1ClosePendingOrderMt5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ClosePendingOrderMt5PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1ClosePendingOrderMt5PostAccountStatus) ??
      defaultValue;
}

String apiV1ClosePendingOrderMt5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1ClosePendingOrderMt5PostAccountStatus>?
        apiV1ClosePendingOrderMt5PostAccountStatus) {
  return apiV1ClosePendingOrderMt5PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ClosePendingOrderMt5PostAccountStatusListToJson(
    List<enums.ApiV1ClosePendingOrderMt5PostAccountStatus>?
        apiV1ClosePendingOrderMt5PostAccountStatus) {
  if (apiV1ClosePendingOrderMt5PostAccountStatus == null) {
    return [];
  }

  return apiV1ClosePendingOrderMt5PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ClosePendingOrderMt5PostAccountStatus>
    apiV1ClosePendingOrderMt5PostAccountStatusListFromJson(
  List? apiV1ClosePendingOrderMt5PostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderMt5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ClosePendingOrderMt5PostAccountStatus
      .map((e) =>
          apiV1ClosePendingOrderMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ClosePendingOrderMt5PostAccountStatus>?
    apiV1ClosePendingOrderMt5PostAccountStatusNullableListFromJson(
  List? apiV1ClosePendingOrderMt5PostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderMt5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ClosePendingOrderMt5PostAccountStatus
      .map((e) =>
          apiV1ClosePendingOrderMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseAllOrdersForMT5PostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrdersForMT5PostAccountStatus?
        apiV1CloseAllOrdersForMT5PostAccountStatus) {
  return apiV1CloseAllOrdersForMT5PostAccountStatus?.value;
}

int? apiV1CloseAllOrdersForMT5PostAccountStatusToJson(
    enums.ApiV1CloseAllOrdersForMT5PostAccountStatus
        apiV1CloseAllOrdersForMT5PostAccountStatus) {
  return apiV1CloseAllOrdersForMT5PostAccountStatus.value;
}

enums.ApiV1CloseAllOrdersForMT5PostAccountStatus
    apiV1CloseAllOrdersForMT5PostAccountStatusFromJson(
  Object? apiV1CloseAllOrdersForMT5PostAccountStatus, [
  enums.ApiV1CloseAllOrdersForMT5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrdersForMT5PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrdersForMT5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrdersForMT5PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrdersForMT5PostAccountStatus?
    apiV1CloseAllOrdersForMT5PostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrdersForMT5PostAccountStatus, [
  enums.ApiV1CloseAllOrdersForMT5PostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrdersForMT5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrdersForMT5PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrdersForMT5PostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrdersForMT5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrdersForMT5PostAccountStatus>?
        apiV1CloseAllOrdersForMT5PostAccountStatus) {
  return apiV1CloseAllOrdersForMT5PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrdersForMT5PostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrdersForMT5PostAccountStatus>?
        apiV1CloseAllOrdersForMT5PostAccountStatus) {
  if (apiV1CloseAllOrdersForMT5PostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrdersForMT5PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrdersForMT5PostAccountStatus>
    apiV1CloseAllOrdersForMT5PostAccountStatusListFromJson(
  List? apiV1CloseAllOrdersForMT5PostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForMT5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrdersForMT5PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrdersForMT5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrdersForMT5PostAccountStatus>?
    apiV1CloseAllOrdersForMT5PostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrdersForMT5PostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForMT5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrdersForMT5PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrdersForMT5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySymbolForMT5PostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus?
        apiV1CloseAllOrderBySymbolForMT5PostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForMT5PostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySymbolForMT5PostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus
        apiV1CloseAllOrderBySymbolForMT5PostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForMT5PostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus
    apiV1CloseAllOrderBySymbolForMT5PostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySymbolForMT5PostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderBySymbolForMT5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus?
    apiV1CloseAllOrderBySymbolForMT5PostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySymbolForMT5PostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForMT5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderBySymbolForMT5PostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderBySymbolForMT5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus>?
        apiV1CloseAllOrderBySymbolForMT5PostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForMT5PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySymbolForMT5PostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus>?
        apiV1CloseAllOrderBySymbolForMT5PostAccountStatus) {
  if (apiV1CloseAllOrderBySymbolForMT5PostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySymbolForMT5PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus>
    apiV1CloseAllOrderBySymbolForMT5PostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySymbolForMT5PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForMT5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySymbolForMT5PostAccountStatus
      .map((e) => apiV1CloseAllOrderBySymbolForMT5PostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus>?
    apiV1CloseAllOrderBySymbolForMT5PostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySymbolForMT5PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForMT5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySymbolForMT5PostAccountStatus
      .map((e) => apiV1CloseAllOrderBySymbolForMT5PostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySellMT5PostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus?
        apiV1CloseAllOrderBySellMT5PostAccountStatus) {
  return apiV1CloseAllOrderBySellMT5PostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySellMT5PostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus
        apiV1CloseAllOrderBySellMT5PostAccountStatus) {
  return apiV1CloseAllOrderBySellMT5PostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus
    apiV1CloseAllOrderBySellMT5PostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySellMT5PostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrderBySellMT5PostAccountStatus) ??
      defaultValue ??
      enums
          .ApiV1CloseAllOrderBySellMT5PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus?
    apiV1CloseAllOrderBySellMT5PostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySellMT5PostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellMT5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrderBySellMT5PostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderBySellMT5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus>?
        apiV1CloseAllOrderBySellMT5PostAccountStatus) {
  return apiV1CloseAllOrderBySellMT5PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySellMT5PostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus>?
        apiV1CloseAllOrderBySellMT5PostAccountStatus) {
  if (apiV1CloseAllOrderBySellMT5PostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySellMT5PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus>
    apiV1CloseAllOrderBySellMT5PostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySellMT5PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellMT5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySellMT5PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySellMT5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus>?
    apiV1CloseAllOrderBySellMT5PostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySellMT5PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellMT5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySellMT5PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySellMT5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseAllOrderByBuyMT5PostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus?
        apiV1CloseAllOrderByBuyMT5PostAccountStatus) {
  return apiV1CloseAllOrderByBuyMT5PostAccountStatus?.value;
}

int? apiV1CloseAllOrderByBuyMT5PostAccountStatusToJson(
    enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus
        apiV1CloseAllOrderByBuyMT5PostAccountStatus) {
  return apiV1CloseAllOrderByBuyMT5PostAccountStatus.value;
}

enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus
    apiV1CloseAllOrderByBuyMT5PostAccountStatusFromJson(
  Object? apiV1CloseAllOrderByBuyMT5PostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrderByBuyMT5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus?
    apiV1CloseAllOrderByBuyMT5PostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderByBuyMT5PostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyMT5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CloseAllOrderByBuyMT5PostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderByBuyMT5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus>?
        apiV1CloseAllOrderByBuyMT5PostAccountStatus) {
  return apiV1CloseAllOrderByBuyMT5PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderByBuyMT5PostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus>?
        apiV1CloseAllOrderByBuyMT5PostAccountStatus) {
  if (apiV1CloseAllOrderByBuyMT5PostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderByBuyMT5PostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus>
    apiV1CloseAllOrderByBuyMT5PostAccountStatusListFromJson(
  List? apiV1CloseAllOrderByBuyMT5PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyMT5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderByBuyMT5PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderByBuyMT5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus>?
    apiV1CloseAllOrderByBuyMT5PostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderByBuyMT5PostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyMT5PostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyMT5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderByBuyMT5PostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderByBuyMT5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrderHistoryMt5PostAccountStatusNullableToJson(
    enums.ApiV1GetOrderHistoryMt5PostAccountStatus?
        apiV1GetOrderHistoryMt5PostAccountStatus) {
  return apiV1GetOrderHistoryMt5PostAccountStatus?.value;
}

int? apiV1GetOrderHistoryMt5PostAccountStatusToJson(
    enums.ApiV1GetOrderHistoryMt5PostAccountStatus
        apiV1GetOrderHistoryMt5PostAccountStatus) {
  return apiV1GetOrderHistoryMt5PostAccountStatus.value;
}

enums.ApiV1GetOrderHistoryMt5PostAccountStatus
    apiV1GetOrderHistoryMt5PostAccountStatusFromJson(
  Object? apiV1GetOrderHistoryMt5PostAccountStatus, [
  enums.ApiV1GetOrderHistoryMt5PostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrderHistoryMt5PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1GetOrderHistoryMt5PostAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetOrderHistoryMt5PostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetOrderHistoryMt5PostAccountStatus?
    apiV1GetOrderHistoryMt5PostAccountStatusNullableFromJson(
  Object? apiV1GetOrderHistoryMt5PostAccountStatus, [
  enums.ApiV1GetOrderHistoryMt5PostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrderHistoryMt5PostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrderHistoryMt5PostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1GetOrderHistoryMt5PostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrderHistoryMt5PostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrderHistoryMt5PostAccountStatus>?
        apiV1GetOrderHistoryMt5PostAccountStatus) {
  return apiV1GetOrderHistoryMt5PostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetOrderHistoryMt5PostAccountStatusListToJson(
    List<enums.ApiV1GetOrderHistoryMt5PostAccountStatus>?
        apiV1GetOrderHistoryMt5PostAccountStatus) {
  if (apiV1GetOrderHistoryMt5PostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrderHistoryMt5PostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1GetOrderHistoryMt5PostAccountStatus>
    apiV1GetOrderHistoryMt5PostAccountStatusListFromJson(
  List? apiV1GetOrderHistoryMt5PostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryMt5PostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrderHistoryMt5PostAccountStatus
      .map(
          (e) => apiV1GetOrderHistoryMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetOrderHistoryMt5PostAccountStatus>?
    apiV1GetOrderHistoryMt5PostAccountStatusNullableListFromJson(
  List? apiV1GetOrderHistoryMt5PostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryMt5PostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryMt5PostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrderHistoryMt5PostAccountStatus
      .map(
          (e) => apiV1GetOrderHistoryMt5PostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1Mt5UpdateRiskPostRiskTypeNullableToJson(
    enums.ApiV1Mt5UpdateRiskPostRiskType? apiV1Mt5UpdateRiskPostRiskType) {
  return apiV1Mt5UpdateRiskPostRiskType?.value;
}

int? apiV1Mt5UpdateRiskPostRiskTypeToJson(
    enums.ApiV1Mt5UpdateRiskPostRiskType apiV1Mt5UpdateRiskPostRiskType) {
  return apiV1Mt5UpdateRiskPostRiskType.value;
}

enums.ApiV1Mt5UpdateRiskPostRiskType apiV1Mt5UpdateRiskPostRiskTypeFromJson(
  Object? apiV1Mt5UpdateRiskPostRiskType, [
  enums.ApiV1Mt5UpdateRiskPostRiskType? defaultValue,
]) {
  return enums.ApiV1Mt5UpdateRiskPostRiskType.values
          .firstWhereOrNull((e) => e.value == apiV1Mt5UpdateRiskPostRiskType) ??
      defaultValue ??
      enums.ApiV1Mt5UpdateRiskPostRiskType.swaggerGeneratedUnknown;
}

enums.ApiV1Mt5UpdateRiskPostRiskType?
    apiV1Mt5UpdateRiskPostRiskTypeNullableFromJson(
  Object? apiV1Mt5UpdateRiskPostRiskType, [
  enums.ApiV1Mt5UpdateRiskPostRiskType? defaultValue,
]) {
  if (apiV1Mt5UpdateRiskPostRiskType == null) {
    return null;
  }
  return enums.ApiV1Mt5UpdateRiskPostRiskType.values
          .firstWhereOrNull((e) => e.value == apiV1Mt5UpdateRiskPostRiskType) ??
      defaultValue;
}

String apiV1Mt5UpdateRiskPostRiskTypeExplodedListToJson(
    List<enums.ApiV1Mt5UpdateRiskPostRiskType>?
        apiV1Mt5UpdateRiskPostRiskType) {
  return apiV1Mt5UpdateRiskPostRiskType?.map((e) => e.value!).join(',') ?? '';
}

List<int> apiV1Mt5UpdateRiskPostRiskTypeListToJson(
    List<enums.ApiV1Mt5UpdateRiskPostRiskType>?
        apiV1Mt5UpdateRiskPostRiskType) {
  if (apiV1Mt5UpdateRiskPostRiskType == null) {
    return [];
  }

  return apiV1Mt5UpdateRiskPostRiskType.map((e) => e.value!).toList();
}

List<enums.ApiV1Mt5UpdateRiskPostRiskType>
    apiV1Mt5UpdateRiskPostRiskTypeListFromJson(
  List? apiV1Mt5UpdateRiskPostRiskType, [
  List<enums.ApiV1Mt5UpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1Mt5UpdateRiskPostRiskType == null) {
    return defaultValue ?? [];
  }

  return apiV1Mt5UpdateRiskPostRiskType
      .map((e) => apiV1Mt5UpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1Mt5UpdateRiskPostRiskType>?
    apiV1Mt5UpdateRiskPostRiskTypeNullableListFromJson(
  List? apiV1Mt5UpdateRiskPostRiskType, [
  List<enums.ApiV1Mt5UpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1Mt5UpdateRiskPostRiskType == null) {
    return defaultValue;
  }

  return apiV1Mt5UpdateRiskPostRiskType
      .map((e) => apiV1Mt5UpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

int? apiV1Mt5UpdateStopsLimitsPostScalperModeNullableToJson(
    enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode?
        apiV1Mt5UpdateStopsLimitsPostScalperMode) {
  return apiV1Mt5UpdateStopsLimitsPostScalperMode?.value;
}

int? apiV1Mt5UpdateStopsLimitsPostScalperModeToJson(
    enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode
        apiV1Mt5UpdateStopsLimitsPostScalperMode) {
  return apiV1Mt5UpdateStopsLimitsPostScalperMode.value;
}

enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode
    apiV1Mt5UpdateStopsLimitsPostScalperModeFromJson(
  Object? apiV1Mt5UpdateStopsLimitsPostScalperMode, [
  enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  return enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode.values.firstWhereOrNull(
          (e) => e.value == apiV1Mt5UpdateStopsLimitsPostScalperMode) ??
      defaultValue ??
      enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode.swaggerGeneratedUnknown;
}

enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode?
    apiV1Mt5UpdateStopsLimitsPostScalperModeNullableFromJson(
  Object? apiV1Mt5UpdateStopsLimitsPostScalperMode, [
  enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  if (apiV1Mt5UpdateStopsLimitsPostScalperMode == null) {
    return null;
  }
  return enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode.values.firstWhereOrNull(
          (e) => e.value == apiV1Mt5UpdateStopsLimitsPostScalperMode) ??
      defaultValue;
}

String apiV1Mt5UpdateStopsLimitsPostScalperModeExplodedListToJson(
    List<enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode>?
        apiV1Mt5UpdateStopsLimitsPostScalperMode) {
  return apiV1Mt5UpdateStopsLimitsPostScalperMode
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1Mt5UpdateStopsLimitsPostScalperModeListToJson(
    List<enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode>?
        apiV1Mt5UpdateStopsLimitsPostScalperMode) {
  if (apiV1Mt5UpdateStopsLimitsPostScalperMode == null) {
    return [];
  }

  return apiV1Mt5UpdateStopsLimitsPostScalperMode.map((e) => e.value!).toList();
}

List<enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode>
    apiV1Mt5UpdateStopsLimitsPostScalperModeListFromJson(
  List? apiV1Mt5UpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1Mt5UpdateStopsLimitsPostScalperMode == null) {
    return defaultValue ?? [];
  }

  return apiV1Mt5UpdateStopsLimitsPostScalperMode
      .map(
          (e) => apiV1Mt5UpdateStopsLimitsPostScalperModeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode>?
    apiV1Mt5UpdateStopsLimitsPostScalperModeNullableListFromJson(
  List? apiV1Mt5UpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1Mt5UpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1Mt5UpdateStopsLimitsPostScalperMode == null) {
    return defaultValue;
  }

  return apiV1Mt5UpdateStopsLimitsPostScalperMode
      .map(
          (e) => apiV1Mt5UpdateStopsLimitsPostScalperModeFromJson(e.toString()))
      .toList();
}

int? apiV1Mt5UpdateStopsLimitsPostOrderFilterNullableToJson(
    enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter?
        apiV1Mt5UpdateStopsLimitsPostOrderFilter) {
  return apiV1Mt5UpdateStopsLimitsPostOrderFilter?.value;
}

int? apiV1Mt5UpdateStopsLimitsPostOrderFilterToJson(
    enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter
        apiV1Mt5UpdateStopsLimitsPostOrderFilter) {
  return apiV1Mt5UpdateStopsLimitsPostOrderFilter.value;
}

enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter
    apiV1Mt5UpdateStopsLimitsPostOrderFilterFromJson(
  Object? apiV1Mt5UpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  return enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter.values.firstWhereOrNull(
          (e) => e.value == apiV1Mt5UpdateStopsLimitsPostOrderFilter) ??
      defaultValue ??
      enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter.swaggerGeneratedUnknown;
}

enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter?
    apiV1Mt5UpdateStopsLimitsPostOrderFilterNullableFromJson(
  Object? apiV1Mt5UpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  if (apiV1Mt5UpdateStopsLimitsPostOrderFilter == null) {
    return null;
  }
  return enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter.values.firstWhereOrNull(
          (e) => e.value == apiV1Mt5UpdateStopsLimitsPostOrderFilter) ??
      defaultValue;
}

String apiV1Mt5UpdateStopsLimitsPostOrderFilterExplodedListToJson(
    List<enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter>?
        apiV1Mt5UpdateStopsLimitsPostOrderFilter) {
  return apiV1Mt5UpdateStopsLimitsPostOrderFilter
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1Mt5UpdateStopsLimitsPostOrderFilterListToJson(
    List<enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter>?
        apiV1Mt5UpdateStopsLimitsPostOrderFilter) {
  if (apiV1Mt5UpdateStopsLimitsPostOrderFilter == null) {
    return [];
  }

  return apiV1Mt5UpdateStopsLimitsPostOrderFilter.map((e) => e.value!).toList();
}

List<enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter>
    apiV1Mt5UpdateStopsLimitsPostOrderFilterListFromJson(
  List? apiV1Mt5UpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1Mt5UpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue ?? [];
  }

  return apiV1Mt5UpdateStopsLimitsPostOrderFilter
      .map(
          (e) => apiV1Mt5UpdateStopsLimitsPostOrderFilterFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter>?
    apiV1Mt5UpdateStopsLimitsPostOrderFilterNullableListFromJson(
  List? apiV1Mt5UpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1Mt5UpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1Mt5UpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue;
  }

  return apiV1Mt5UpdateStopsLimitsPostOrderFilter
      .map(
          (e) => apiV1Mt5UpdateStopsLimitsPostOrderFilterFromJson(e.toString()))
      .toList();
}

int? apiV1SendOrderCtraderPostAccountStatusNullableToJson(
    enums.ApiV1SendOrderCtraderPostAccountStatus?
        apiV1SendOrderCtraderPostAccountStatus) {
  return apiV1SendOrderCtraderPostAccountStatus?.value;
}

int? apiV1SendOrderCtraderPostAccountStatusToJson(
    enums.ApiV1SendOrderCtraderPostAccountStatus
        apiV1SendOrderCtraderPostAccountStatus) {
  return apiV1SendOrderCtraderPostAccountStatus.value;
}

enums.ApiV1SendOrderCtraderPostAccountStatus
    apiV1SendOrderCtraderPostAccountStatusFromJson(
  Object? apiV1SendOrderCtraderPostAccountStatus, [
  enums.ApiV1SendOrderCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1SendOrderCtraderPostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1SendOrderCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1SendOrderCtraderPostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1SendOrderCtraderPostAccountStatus?
    apiV1SendOrderCtraderPostAccountStatusNullableFromJson(
  Object? apiV1SendOrderCtraderPostAccountStatus, [
  enums.ApiV1SendOrderCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1SendOrderCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1SendOrderCtraderPostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1SendOrderCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1SendOrderCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1SendOrderCtraderPostAccountStatus>?
        apiV1SendOrderCtraderPostAccountStatus) {
  return apiV1SendOrderCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1SendOrderCtraderPostAccountStatusListToJson(
    List<enums.ApiV1SendOrderCtraderPostAccountStatus>?
        apiV1SendOrderCtraderPostAccountStatus) {
  if (apiV1SendOrderCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1SendOrderCtraderPostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1SendOrderCtraderPostAccountStatus>
    apiV1SendOrderCtraderPostAccountStatusListFromJson(
  List? apiV1SendOrderCtraderPostAccountStatus, [
  List<enums.ApiV1SendOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1SendOrderCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1SendOrderCtraderPostAccountStatus
      .map((e) => apiV1SendOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1SendOrderCtraderPostAccountStatus>?
    apiV1SendOrderCtraderPostAccountStatusNullableListFromJson(
  List? apiV1SendOrderCtraderPostAccountStatus, [
  List<enums.ApiV1SendOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1SendOrderCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1SendOrderCtraderPostAccountStatus
      .map((e) => apiV1SendOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrdersCtraderPostAccountStatusNullableToJson(
    enums.ApiV1GetOrdersCtraderPostAccountStatus?
        apiV1GetOrdersCtraderPostAccountStatus) {
  return apiV1GetOrdersCtraderPostAccountStatus?.value;
}

int? apiV1GetOrdersCtraderPostAccountStatusToJson(
    enums.ApiV1GetOrdersCtraderPostAccountStatus
        apiV1GetOrdersCtraderPostAccountStatus) {
  return apiV1GetOrdersCtraderPostAccountStatus.value;
}

enums.ApiV1GetOrdersCtraderPostAccountStatus
    apiV1GetOrdersCtraderPostAccountStatusFromJson(
  Object? apiV1GetOrdersCtraderPostAccountStatus, [
  enums.ApiV1GetOrdersCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrdersCtraderPostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1GetOrdersCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetOrdersCtraderPostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetOrdersCtraderPostAccountStatus?
    apiV1GetOrdersCtraderPostAccountStatusNullableFromJson(
  Object? apiV1GetOrdersCtraderPostAccountStatus, [
  enums.ApiV1GetOrdersCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrdersCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrdersCtraderPostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1GetOrdersCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrdersCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrdersCtraderPostAccountStatus>?
        apiV1GetOrdersCtraderPostAccountStatus) {
  return apiV1GetOrdersCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetOrdersCtraderPostAccountStatusListToJson(
    List<enums.ApiV1GetOrdersCtraderPostAccountStatus>?
        apiV1GetOrdersCtraderPostAccountStatus) {
  if (apiV1GetOrdersCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrdersCtraderPostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1GetOrdersCtraderPostAccountStatus>
    apiV1GetOrdersCtraderPostAccountStatusListFromJson(
  List? apiV1GetOrdersCtraderPostAccountStatus, [
  List<enums.ApiV1GetOrdersCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrdersCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrdersCtraderPostAccountStatus
      .map((e) => apiV1GetOrdersCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetOrdersCtraderPostAccountStatus>?
    apiV1GetOrdersCtraderPostAccountStatusNullableListFromJson(
  List? apiV1GetOrdersCtraderPostAccountStatus, [
  List<enums.ApiV1GetOrdersCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrdersCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrdersCtraderPostAccountStatus
      .map((e) => apiV1GetOrdersCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ModifyOrderCtraderPostAccountStatusNullableToJson(
    enums.ApiV1ModifyOrderCtraderPostAccountStatus?
        apiV1ModifyOrderCtraderPostAccountStatus) {
  return apiV1ModifyOrderCtraderPostAccountStatus?.value;
}

int? apiV1ModifyOrderCtraderPostAccountStatusToJson(
    enums.ApiV1ModifyOrderCtraderPostAccountStatus
        apiV1ModifyOrderCtraderPostAccountStatus) {
  return apiV1ModifyOrderCtraderPostAccountStatus.value;
}

enums.ApiV1ModifyOrderCtraderPostAccountStatus
    apiV1ModifyOrderCtraderPostAccountStatusFromJson(
  Object? apiV1ModifyOrderCtraderPostAccountStatus, [
  enums.ApiV1ModifyOrderCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyOrderCtraderPostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1ModifyOrderCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyOrderCtraderPostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1ModifyOrderCtraderPostAccountStatus?
    apiV1ModifyOrderCtraderPostAccountStatusNullableFromJson(
  Object? apiV1ModifyOrderCtraderPostAccountStatus, [
  enums.ApiV1ModifyOrderCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyOrderCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyOrderCtraderPostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1ModifyOrderCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyOrderCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyOrderCtraderPostAccountStatus>?
        apiV1ModifyOrderCtraderPostAccountStatus) {
  return apiV1ModifyOrderCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ModifyOrderCtraderPostAccountStatusListToJson(
    List<enums.ApiV1ModifyOrderCtraderPostAccountStatus>?
        apiV1ModifyOrderCtraderPostAccountStatus) {
  if (apiV1ModifyOrderCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyOrderCtraderPostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1ModifyOrderCtraderPostAccountStatus>
    apiV1ModifyOrderCtraderPostAccountStatusListFromJson(
  List? apiV1ModifyOrderCtraderPostAccountStatus, [
  List<enums.ApiV1ModifyOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyOrderCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyOrderCtraderPostAccountStatus
      .map(
          (e) => apiV1ModifyOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ModifyOrderCtraderPostAccountStatus>?
    apiV1ModifyOrderCtraderPostAccountStatusNullableListFromJson(
  List? apiV1ModifyOrderCtraderPostAccountStatus, [
  List<enums.ApiV1ModifyOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyOrderCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyOrderCtraderPostAccountStatus
      .map(
          (e) => apiV1ModifyOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseOrderCtraderPostAccountStatusNullableToJson(
    enums.ApiV1CloseOrderCtraderPostAccountStatus?
        apiV1CloseOrderCtraderPostAccountStatus) {
  return apiV1CloseOrderCtraderPostAccountStatus?.value;
}

int? apiV1CloseOrderCtraderPostAccountStatusToJson(
    enums.ApiV1CloseOrderCtraderPostAccountStatus
        apiV1CloseOrderCtraderPostAccountStatus) {
  return apiV1CloseOrderCtraderPostAccountStatus.value;
}

enums.ApiV1CloseOrderCtraderPostAccountStatus
    apiV1CloseOrderCtraderPostAccountStatusFromJson(
  Object? apiV1CloseOrderCtraderPostAccountStatus, [
  enums.ApiV1CloseOrderCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseOrderCtraderPostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1CloseOrderCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseOrderCtraderPostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1CloseOrderCtraderPostAccountStatus?
    apiV1CloseOrderCtraderPostAccountStatusNullableFromJson(
  Object? apiV1CloseOrderCtraderPostAccountStatus, [
  enums.ApiV1CloseOrderCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1CloseOrderCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseOrderCtraderPostAccountStatus.values.firstWhereOrNull(
          (e) => e.value == apiV1CloseOrderCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1CloseOrderCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseOrderCtraderPostAccountStatus>?
        apiV1CloseOrderCtraderPostAccountStatus) {
  return apiV1CloseOrderCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseOrderCtraderPostAccountStatusListToJson(
    List<enums.ApiV1CloseOrderCtraderPostAccountStatus>?
        apiV1CloseOrderCtraderPostAccountStatus) {
  if (apiV1CloseOrderCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1CloseOrderCtraderPostAccountStatus.map((e) => e.value!).toList();
}

List<enums.ApiV1CloseOrderCtraderPostAccountStatus>
    apiV1CloseOrderCtraderPostAccountStatusListFromJson(
  List? apiV1CloseOrderCtraderPostAccountStatus, [
  List<enums.ApiV1CloseOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseOrderCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseOrderCtraderPostAccountStatus
      .map((e) => apiV1CloseOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseOrderCtraderPostAccountStatus>?
    apiV1CloseOrderCtraderPostAccountStatusNullableListFromJson(
  List? apiV1CloseOrderCtraderPostAccountStatus, [
  List<enums.ApiV1CloseOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseOrderCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseOrderCtraderPostAccountStatus
      .map((e) => apiV1CloseOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CtraderPartialCloseOrderPostAccountStatusNullableToJson(
    enums.ApiV1CtraderPartialCloseOrderPostAccountStatus?
        apiV1CtraderPartialCloseOrderPostAccountStatus) {
  return apiV1CtraderPartialCloseOrderPostAccountStatus?.value;
}

int? apiV1CtraderPartialCloseOrderPostAccountStatusToJson(
    enums.ApiV1CtraderPartialCloseOrderPostAccountStatus
        apiV1CtraderPartialCloseOrderPostAccountStatus) {
  return apiV1CtraderPartialCloseOrderPostAccountStatus.value;
}

enums.ApiV1CtraderPartialCloseOrderPostAccountStatus
    apiV1CtraderPartialCloseOrderPostAccountStatusFromJson(
  Object? apiV1CtraderPartialCloseOrderPostAccountStatus, [
  enums.ApiV1CtraderPartialCloseOrderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CtraderPartialCloseOrderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CtraderPartialCloseOrderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CtraderPartialCloseOrderPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CtraderPartialCloseOrderPostAccountStatus?
    apiV1CtraderPartialCloseOrderPostAccountStatusNullableFromJson(
  Object? apiV1CtraderPartialCloseOrderPostAccountStatus, [
  enums.ApiV1CtraderPartialCloseOrderPostAccountStatus? defaultValue,
]) {
  if (apiV1CtraderPartialCloseOrderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CtraderPartialCloseOrderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CtraderPartialCloseOrderPostAccountStatus) ??
      defaultValue;
}

String apiV1CtraderPartialCloseOrderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1CtraderPartialCloseOrderPostAccountStatus>?
        apiV1CtraderPartialCloseOrderPostAccountStatus) {
  return apiV1CtraderPartialCloseOrderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CtraderPartialCloseOrderPostAccountStatusListToJson(
    List<enums.ApiV1CtraderPartialCloseOrderPostAccountStatus>?
        apiV1CtraderPartialCloseOrderPostAccountStatus) {
  if (apiV1CtraderPartialCloseOrderPostAccountStatus == null) {
    return [];
  }

  return apiV1CtraderPartialCloseOrderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CtraderPartialCloseOrderPostAccountStatus>
    apiV1CtraderPartialCloseOrderPostAccountStatusListFromJson(
  List? apiV1CtraderPartialCloseOrderPostAccountStatus, [
  List<enums.ApiV1CtraderPartialCloseOrderPostAccountStatus>? defaultValue,
]) {
  if (apiV1CtraderPartialCloseOrderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CtraderPartialCloseOrderPostAccountStatus
      .map((e) =>
          apiV1CtraderPartialCloseOrderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CtraderPartialCloseOrderPostAccountStatus>?
    apiV1CtraderPartialCloseOrderPostAccountStatusNullableListFromJson(
  List? apiV1CtraderPartialCloseOrderPostAccountStatus, [
  List<enums.ApiV1CtraderPartialCloseOrderPostAccountStatus>? defaultValue,
]) {
  if (apiV1CtraderPartialCloseOrderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CtraderPartialCloseOrderPostAccountStatus
      .map((e) =>
          apiV1CtraderPartialCloseOrderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1SendPendingOrderCtraderPostAccountStatusNullableToJson(
    enums.ApiV1SendPendingOrderCtraderPostAccountStatus?
        apiV1SendPendingOrderCtraderPostAccountStatus) {
  return apiV1SendPendingOrderCtraderPostAccountStatus?.value;
}

int? apiV1SendPendingOrderCtraderPostAccountStatusToJson(
    enums.ApiV1SendPendingOrderCtraderPostAccountStatus
        apiV1SendPendingOrderCtraderPostAccountStatus) {
  return apiV1SendPendingOrderCtraderPostAccountStatus.value;
}

enums.ApiV1SendPendingOrderCtraderPostAccountStatus
    apiV1SendPendingOrderCtraderPostAccountStatusFromJson(
  Object? apiV1SendPendingOrderCtraderPostAccountStatus, [
  enums.ApiV1SendPendingOrderCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1SendPendingOrderCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1SendPendingOrderCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1SendPendingOrderCtraderPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1SendPendingOrderCtraderPostAccountStatus?
    apiV1SendPendingOrderCtraderPostAccountStatusNullableFromJson(
  Object? apiV1SendPendingOrderCtraderPostAccountStatus, [
  enums.ApiV1SendPendingOrderCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1SendPendingOrderCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1SendPendingOrderCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1SendPendingOrderCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1SendPendingOrderCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1SendPendingOrderCtraderPostAccountStatus>?
        apiV1SendPendingOrderCtraderPostAccountStatus) {
  return apiV1SendPendingOrderCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1SendPendingOrderCtraderPostAccountStatusListToJson(
    List<enums.ApiV1SendPendingOrderCtraderPostAccountStatus>?
        apiV1SendPendingOrderCtraderPostAccountStatus) {
  if (apiV1SendPendingOrderCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1SendPendingOrderCtraderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1SendPendingOrderCtraderPostAccountStatus>
    apiV1SendPendingOrderCtraderPostAccountStatusListFromJson(
  List? apiV1SendPendingOrderCtraderPostAccountStatus, [
  List<enums.ApiV1SendPendingOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPendingOrderCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1SendPendingOrderCtraderPostAccountStatus
      .map((e) =>
          apiV1SendPendingOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1SendPendingOrderCtraderPostAccountStatus>?
    apiV1SendPendingOrderCtraderPostAccountStatusNullableListFromJson(
  List? apiV1SendPendingOrderCtraderPostAccountStatus, [
  List<enums.ApiV1SendPendingOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPendingOrderCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1SendPendingOrderCtraderPostAccountStatus
      .map((e) =>
          apiV1SendPendingOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ModifyPendingOrderCtraderPostAccountStatusNullableToJson(
    enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus?
        apiV1ModifyPendingOrderCtraderPostAccountStatus) {
  return apiV1ModifyPendingOrderCtraderPostAccountStatus?.value;
}

int? apiV1ModifyPendingOrderCtraderPostAccountStatusToJson(
    enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus
        apiV1ModifyPendingOrderCtraderPostAccountStatus) {
  return apiV1ModifyPendingOrderCtraderPostAccountStatus.value;
}

enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus
    apiV1ModifyPendingOrderCtraderPostAccountStatusFromJson(
  Object? apiV1ModifyPendingOrderCtraderPostAccountStatus, [
  enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPendingOrderCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus?
    apiV1ModifyPendingOrderCtraderPostAccountStatusNullableFromJson(
  Object? apiV1ModifyPendingOrderCtraderPostAccountStatus, [
  enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyPendingOrderCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPendingOrderCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyPendingOrderCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus>?
        apiV1ModifyPendingOrderCtraderPostAccountStatus) {
  return apiV1ModifyPendingOrderCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ModifyPendingOrderCtraderPostAccountStatusListToJson(
    List<enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus>?
        apiV1ModifyPendingOrderCtraderPostAccountStatus) {
  if (apiV1ModifyPendingOrderCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyPendingOrderCtraderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus>
    apiV1ModifyPendingOrderCtraderPostAccountStatusListFromJson(
  List? apiV1ModifyPendingOrderCtraderPostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyPendingOrderCtraderPostAccountStatus
      .map((e) =>
          apiV1ModifyPendingOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus>?
    apiV1ModifyPendingOrderCtraderPostAccountStatusNullableListFromJson(
  List? apiV1ModifyPendingOrderCtraderPostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyPendingOrderCtraderPostAccountStatus
      .map((e) =>
          apiV1ModifyPendingOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ClosePendingOrderCtraderPostAccountStatusNullableToJson(
    enums.ApiV1ClosePendingOrderCtraderPostAccountStatus?
        apiV1ClosePendingOrderCtraderPostAccountStatus) {
  return apiV1ClosePendingOrderCtraderPostAccountStatus?.value;
}

int? apiV1ClosePendingOrderCtraderPostAccountStatusToJson(
    enums.ApiV1ClosePendingOrderCtraderPostAccountStatus
        apiV1ClosePendingOrderCtraderPostAccountStatus) {
  return apiV1ClosePendingOrderCtraderPostAccountStatus.value;
}

enums.ApiV1ClosePendingOrderCtraderPostAccountStatus
    apiV1ClosePendingOrderCtraderPostAccountStatusFromJson(
  Object? apiV1ClosePendingOrderCtraderPostAccountStatus, [
  enums.ApiV1ClosePendingOrderCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ClosePendingOrderCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePendingOrderCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ClosePendingOrderCtraderPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ClosePendingOrderCtraderPostAccountStatus?
    apiV1ClosePendingOrderCtraderPostAccountStatusNullableFromJson(
  Object? apiV1ClosePendingOrderCtraderPostAccountStatus, [
  enums.ApiV1ClosePendingOrderCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1ClosePendingOrderCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ClosePendingOrderCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePendingOrderCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1ClosePendingOrderCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1ClosePendingOrderCtraderPostAccountStatus>?
        apiV1ClosePendingOrderCtraderPostAccountStatus) {
  return apiV1ClosePendingOrderCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ClosePendingOrderCtraderPostAccountStatusListToJson(
    List<enums.ApiV1ClosePendingOrderCtraderPostAccountStatus>?
        apiV1ClosePendingOrderCtraderPostAccountStatus) {
  if (apiV1ClosePendingOrderCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1ClosePendingOrderCtraderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ClosePendingOrderCtraderPostAccountStatus>
    apiV1ClosePendingOrderCtraderPostAccountStatusListFromJson(
  List? apiV1ClosePendingOrderCtraderPostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ClosePendingOrderCtraderPostAccountStatus
      .map((e) =>
          apiV1ClosePendingOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ClosePendingOrderCtraderPostAccountStatus>?
    apiV1ClosePendingOrderCtraderPostAccountStatusNullableListFromJson(
  List? apiV1ClosePendingOrderCtraderPostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ClosePendingOrderCtraderPostAccountStatus
      .map((e) =>
          apiV1ClosePendingOrderCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseAllOrdersForCtraderPostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus?
        apiV1CloseAllOrdersForCtraderPostAccountStatus) {
  return apiV1CloseAllOrdersForCtraderPostAccountStatus?.value;
}

int? apiV1CloseAllOrdersForCtraderPostAccountStatusToJson(
    enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus
        apiV1CloseAllOrdersForCtraderPostAccountStatus) {
  return apiV1CloseAllOrdersForCtraderPostAccountStatus.value;
}

enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus
    apiV1CloseAllOrdersForCtraderPostAccountStatusFromJson(
  Object? apiV1CloseAllOrdersForCtraderPostAccountStatus, [
  enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrdersForCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus?
    apiV1CloseAllOrdersForCtraderPostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrdersForCtraderPostAccountStatus, [
  enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrdersForCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrdersForCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrdersForCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus>?
        apiV1CloseAllOrdersForCtraderPostAccountStatus) {
  return apiV1CloseAllOrdersForCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrdersForCtraderPostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus>?
        apiV1CloseAllOrdersForCtraderPostAccountStatus) {
  if (apiV1CloseAllOrdersForCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrdersForCtraderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus>
    apiV1CloseAllOrdersForCtraderPostAccountStatusListFromJson(
  List? apiV1CloseAllOrdersForCtraderPostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrdersForCtraderPostAccountStatus
      .map((e) =>
          apiV1CloseAllOrdersForCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus>?
    apiV1CloseAllOrdersForCtraderPostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrdersForCtraderPostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrdersForCtraderPostAccountStatus
      .map((e) =>
          apiV1CloseAllOrdersForCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySymbolForCtraderPostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus?
        apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySymbolForCtraderPostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus
        apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus
    apiV1CloseAllOrderBySymbolForCtraderPostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus?
    apiV1CloseAllOrderBySymbolForCtraderPostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderBySymbolForCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus>?
        apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySymbolForCtraderPostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus>?
        apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus) {
  if (apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus>
    apiV1CloseAllOrderBySymbolForCtraderPostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus
      .map((e) => apiV1CloseAllOrderBySymbolForCtraderPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus>?
    apiV1CloseAllOrderBySymbolForCtraderPostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForCtraderPostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySymbolForCtraderPostAccountStatus
      .map((e) => apiV1CloseAllOrderBySymbolForCtraderPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySellCtraderPostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus?
        apiV1CloseAllOrderBySellCtraderPostAccountStatus) {
  return apiV1CloseAllOrderBySellCtraderPostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySellCtraderPostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus
        apiV1CloseAllOrderBySellCtraderPostAccountStatus) {
  return apiV1CloseAllOrderBySellCtraderPostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus
    apiV1CloseAllOrderBySellCtraderPostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySellCtraderPostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderBySellCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus?
    apiV1CloseAllOrderBySellCtraderPostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySellCtraderPostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderBySellCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderBySellCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus>?
        apiV1CloseAllOrderBySellCtraderPostAccountStatus) {
  return apiV1CloseAllOrderBySellCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySellCtraderPostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus>?
        apiV1CloseAllOrderBySellCtraderPostAccountStatus) {
  if (apiV1CloseAllOrderBySellCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySellCtraderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus>
    apiV1CloseAllOrderBySellCtraderPostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySellCtraderPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySellCtraderPostAccountStatus
      .map((e) => apiV1CloseAllOrderBySellCtraderPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus>?
    apiV1CloseAllOrderBySellCtraderPostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySellCtraderPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySellCtraderPostAccountStatus
      .map((e) => apiV1CloseAllOrderBySellCtraderPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1CloseAllOrderByBuyCtraderPostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus?
        apiV1CloseAllOrderByBuyCtraderPostAccountStatus) {
  return apiV1CloseAllOrderByBuyCtraderPostAccountStatus?.value;
}

int? apiV1CloseAllOrderByBuyCtraderPostAccountStatusToJson(
    enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus
        apiV1CloseAllOrderByBuyCtraderPostAccountStatus) {
  return apiV1CloseAllOrderByBuyCtraderPostAccountStatus.value;
}

enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus
    apiV1CloseAllOrderByBuyCtraderPostAccountStatusFromJson(
  Object? apiV1CloseAllOrderByBuyCtraderPostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderByBuyCtraderPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus?
    apiV1CloseAllOrderByBuyCtraderPostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderByBuyCtraderPostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderByBuyCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderByBuyCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus>?
        apiV1CloseAllOrderByBuyCtraderPostAccountStatus) {
  return apiV1CloseAllOrderByBuyCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderByBuyCtraderPostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus>?
        apiV1CloseAllOrderByBuyCtraderPostAccountStatus) {
  if (apiV1CloseAllOrderByBuyCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderByBuyCtraderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus>
    apiV1CloseAllOrderByBuyCtraderPostAccountStatusListFromJson(
  List? apiV1CloseAllOrderByBuyCtraderPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderByBuyCtraderPostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderByBuyCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus>?
    apiV1CloseAllOrderByBuyCtraderPostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderByBuyCtraderPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderByBuyCtraderPostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderByBuyCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrderHistoryCtraderPostAccountStatusNullableToJson(
    enums.ApiV1GetOrderHistoryCtraderPostAccountStatus?
        apiV1GetOrderHistoryCtraderPostAccountStatus) {
  return apiV1GetOrderHistoryCtraderPostAccountStatus?.value;
}

int? apiV1GetOrderHistoryCtraderPostAccountStatusToJson(
    enums.ApiV1GetOrderHistoryCtraderPostAccountStatus
        apiV1GetOrderHistoryCtraderPostAccountStatus) {
  return apiV1GetOrderHistoryCtraderPostAccountStatus.value;
}

enums.ApiV1GetOrderHistoryCtraderPostAccountStatus
    apiV1GetOrderHistoryCtraderPostAccountStatusFromJson(
  Object? apiV1GetOrderHistoryCtraderPostAccountStatus, [
  enums.ApiV1GetOrderHistoryCtraderPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrderHistoryCtraderPostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetOrderHistoryCtraderPostAccountStatus) ??
      defaultValue ??
      enums
          .ApiV1GetOrderHistoryCtraderPostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetOrderHistoryCtraderPostAccountStatus?
    apiV1GetOrderHistoryCtraderPostAccountStatusNullableFromJson(
  Object? apiV1GetOrderHistoryCtraderPostAccountStatus, [
  enums.ApiV1GetOrderHistoryCtraderPostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrderHistoryCtraderPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrderHistoryCtraderPostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetOrderHistoryCtraderPostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrderHistoryCtraderPostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrderHistoryCtraderPostAccountStatus>?
        apiV1GetOrderHistoryCtraderPostAccountStatus) {
  return apiV1GetOrderHistoryCtraderPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetOrderHistoryCtraderPostAccountStatusListToJson(
    List<enums.ApiV1GetOrderHistoryCtraderPostAccountStatus>?
        apiV1GetOrderHistoryCtraderPostAccountStatus) {
  if (apiV1GetOrderHistoryCtraderPostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrderHistoryCtraderPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetOrderHistoryCtraderPostAccountStatus>
    apiV1GetOrderHistoryCtraderPostAccountStatusListFromJson(
  List? apiV1GetOrderHistoryCtraderPostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryCtraderPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrderHistoryCtraderPostAccountStatus
      .map((e) =>
          apiV1GetOrderHistoryCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetOrderHistoryCtraderPostAccountStatus>?
    apiV1GetOrderHistoryCtraderPostAccountStatusNullableListFromJson(
  List? apiV1GetOrderHistoryCtraderPostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryCtraderPostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryCtraderPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrderHistoryCtraderPostAccountStatus
      .map((e) =>
          apiV1GetOrderHistoryCtraderPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrderHistoryCtraderMasterPostAccountStatusNullableToJson(
    enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus?
        apiV1GetOrderHistoryCtraderMasterPostAccountStatus) {
  return apiV1GetOrderHistoryCtraderMasterPostAccountStatus?.value;
}

int? apiV1GetOrderHistoryCtraderMasterPostAccountStatusToJson(
    enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus
        apiV1GetOrderHistoryCtraderMasterPostAccountStatus) {
  return apiV1GetOrderHistoryCtraderMasterPostAccountStatus.value;
}

enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus
    apiV1GetOrderHistoryCtraderMasterPostAccountStatusFromJson(
  Object? apiV1GetOrderHistoryCtraderMasterPostAccountStatus, [
  enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetOrderHistoryCtraderMasterPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus?
    apiV1GetOrderHistoryCtraderMasterPostAccountStatusNullableFromJson(
  Object? apiV1GetOrderHistoryCtraderMasterPostAccountStatus, [
  enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrderHistoryCtraderMasterPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetOrderHistoryCtraderMasterPostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrderHistoryCtraderMasterPostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus>?
        apiV1GetOrderHistoryCtraderMasterPostAccountStatus) {
  return apiV1GetOrderHistoryCtraderMasterPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetOrderHistoryCtraderMasterPostAccountStatusListToJson(
    List<enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus>?
        apiV1GetOrderHistoryCtraderMasterPostAccountStatus) {
  if (apiV1GetOrderHistoryCtraderMasterPostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrderHistoryCtraderMasterPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus>
    apiV1GetOrderHistoryCtraderMasterPostAccountStatusListFromJson(
  List? apiV1GetOrderHistoryCtraderMasterPostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryCtraderMasterPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrderHistoryCtraderMasterPostAccountStatus
      .map((e) => apiV1GetOrderHistoryCtraderMasterPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus>?
    apiV1GetOrderHistoryCtraderMasterPostAccountStatusNullableListFromJson(
  List? apiV1GetOrderHistoryCtraderMasterPostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryCtraderMasterPostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryCtraderMasterPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrderHistoryCtraderMasterPostAccountStatus
      .map((e) => apiV1GetOrderHistoryCtraderMasterPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1GetAllSymbolCtraderUserIdGetAccountStatusNullableToJson(
    enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus?
        apiV1GetAllSymbolCtraderUserIdGetAccountStatus) {
  return apiV1GetAllSymbolCtraderUserIdGetAccountStatus?.value;
}

int? apiV1GetAllSymbolCtraderUserIdGetAccountStatusToJson(
    enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus
        apiV1GetAllSymbolCtraderUserIdGetAccountStatus) {
  return apiV1GetAllSymbolCtraderUserIdGetAccountStatus.value;
}

enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus
    apiV1GetAllSymbolCtraderUserIdGetAccountStatusFromJson(
  Object? apiV1GetAllSymbolCtraderUserIdGetAccountStatus, [
  enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetAllSymbolCtraderUserIdGetAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus?
    apiV1GetAllSymbolCtraderUserIdGetAccountStatusNullableFromJson(
  Object? apiV1GetAllSymbolCtraderUserIdGetAccountStatus, [
  enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus? defaultValue,
]) {
  if (apiV1GetAllSymbolCtraderUserIdGetAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetAllSymbolCtraderUserIdGetAccountStatus) ??
      defaultValue;
}

String apiV1GetAllSymbolCtraderUserIdGetAccountStatusExplodedListToJson(
    List<enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus>?
        apiV1GetAllSymbolCtraderUserIdGetAccountStatus) {
  return apiV1GetAllSymbolCtraderUserIdGetAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetAllSymbolCtraderUserIdGetAccountStatusListToJson(
    List<enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus>?
        apiV1GetAllSymbolCtraderUserIdGetAccountStatus) {
  if (apiV1GetAllSymbolCtraderUserIdGetAccountStatus == null) {
    return [];
  }

  return apiV1GetAllSymbolCtraderUserIdGetAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus>
    apiV1GetAllSymbolCtraderUserIdGetAccountStatusListFromJson(
  List? apiV1GetAllSymbolCtraderUserIdGetAccountStatus, [
  List<enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus>? defaultValue,
]) {
  if (apiV1GetAllSymbolCtraderUserIdGetAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetAllSymbolCtraderUserIdGetAccountStatus
      .map((e) =>
          apiV1GetAllSymbolCtraderUserIdGetAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus>?
    apiV1GetAllSymbolCtraderUserIdGetAccountStatusNullableListFromJson(
  List? apiV1GetAllSymbolCtraderUserIdGetAccountStatus, [
  List<enums.ApiV1GetAllSymbolCtraderUserIdGetAccountStatus>? defaultValue,
]) {
  if (apiV1GetAllSymbolCtraderUserIdGetAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetAllSymbolCtraderUserIdGetAccountStatus
      .map((e) =>
          apiV1GetAllSymbolCtraderUserIdGetAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetAllSymbolMT5UserIdGetAccountStatusNullableToJson(
    enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus?
        apiV1GetAllSymbolMT5UserIdGetAccountStatus) {
  return apiV1GetAllSymbolMT5UserIdGetAccountStatus?.value;
}

int? apiV1GetAllSymbolMT5UserIdGetAccountStatusToJson(
    enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus
        apiV1GetAllSymbolMT5UserIdGetAccountStatus) {
  return apiV1GetAllSymbolMT5UserIdGetAccountStatus.value;
}

enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus
    apiV1GetAllSymbolMT5UserIdGetAccountStatusFromJson(
  Object? apiV1GetAllSymbolMT5UserIdGetAccountStatus, [
  enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetAllSymbolMT5UserIdGetAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus?
    apiV1GetAllSymbolMT5UserIdGetAccountStatusNullableFromJson(
  Object? apiV1GetAllSymbolMT5UserIdGetAccountStatus, [
  enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus? defaultValue,
]) {
  if (apiV1GetAllSymbolMT5UserIdGetAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetAllSymbolMT5UserIdGetAccountStatus) ??
      defaultValue;
}

String apiV1GetAllSymbolMT5UserIdGetAccountStatusExplodedListToJson(
    List<enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus>?
        apiV1GetAllSymbolMT5UserIdGetAccountStatus) {
  return apiV1GetAllSymbolMT5UserIdGetAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetAllSymbolMT5UserIdGetAccountStatusListToJson(
    List<enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus>?
        apiV1GetAllSymbolMT5UserIdGetAccountStatus) {
  if (apiV1GetAllSymbolMT5UserIdGetAccountStatus == null) {
    return [];
  }

  return apiV1GetAllSymbolMT5UserIdGetAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus>
    apiV1GetAllSymbolMT5UserIdGetAccountStatusListFromJson(
  List? apiV1GetAllSymbolMT5UserIdGetAccountStatus, [
  List<enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus>? defaultValue,
]) {
  if (apiV1GetAllSymbolMT5UserIdGetAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetAllSymbolMT5UserIdGetAccountStatus
      .map((e) =>
          apiV1GetAllSymbolMT5UserIdGetAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus>?
    apiV1GetAllSymbolMT5UserIdGetAccountStatusNullableListFromJson(
  List? apiV1GetAllSymbolMT5UserIdGetAccountStatus, [
  List<enums.ApiV1GetAllSymbolMT5UserIdGetAccountStatus>? defaultValue,
]) {
  if (apiV1GetAllSymbolMT5UserIdGetAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetAllSymbolMT5UserIdGetAccountStatus
      .map((e) =>
          apiV1GetAllSymbolMT5UserIdGetAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetAllSymbolMT4UserIdGetAccountStatusNullableToJson(
    enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus?
        apiV1GetAllSymbolMT4UserIdGetAccountStatus) {
  return apiV1GetAllSymbolMT4UserIdGetAccountStatus?.value;
}

int? apiV1GetAllSymbolMT4UserIdGetAccountStatusToJson(
    enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus
        apiV1GetAllSymbolMT4UserIdGetAccountStatus) {
  return apiV1GetAllSymbolMT4UserIdGetAccountStatus.value;
}

enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus
    apiV1GetAllSymbolMT4UserIdGetAccountStatusFromJson(
  Object? apiV1GetAllSymbolMT4UserIdGetAccountStatus, [
  enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetAllSymbolMT4UserIdGetAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus?
    apiV1GetAllSymbolMT4UserIdGetAccountStatusNullableFromJson(
  Object? apiV1GetAllSymbolMT4UserIdGetAccountStatus, [
  enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus? defaultValue,
]) {
  if (apiV1GetAllSymbolMT4UserIdGetAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetAllSymbolMT4UserIdGetAccountStatus) ??
      defaultValue;
}

String apiV1GetAllSymbolMT4UserIdGetAccountStatusExplodedListToJson(
    List<enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus>?
        apiV1GetAllSymbolMT4UserIdGetAccountStatus) {
  return apiV1GetAllSymbolMT4UserIdGetAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetAllSymbolMT4UserIdGetAccountStatusListToJson(
    List<enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus>?
        apiV1GetAllSymbolMT4UserIdGetAccountStatus) {
  if (apiV1GetAllSymbolMT4UserIdGetAccountStatus == null) {
    return [];
  }

  return apiV1GetAllSymbolMT4UserIdGetAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus>
    apiV1GetAllSymbolMT4UserIdGetAccountStatusListFromJson(
  List? apiV1GetAllSymbolMT4UserIdGetAccountStatus, [
  List<enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus>? defaultValue,
]) {
  if (apiV1GetAllSymbolMT4UserIdGetAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetAllSymbolMT4UserIdGetAccountStatus
      .map((e) =>
          apiV1GetAllSymbolMT4UserIdGetAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus>?
    apiV1GetAllSymbolMT4UserIdGetAccountStatusNullableListFromJson(
  List? apiV1GetAllSymbolMT4UserIdGetAccountStatus, [
  List<enums.ApiV1GetAllSymbolMT4UserIdGetAccountStatus>? defaultValue,
]) {
  if (apiV1GetAllSymbolMT4UserIdGetAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetAllSymbolMT4UserIdGetAccountStatus
      .map((e) =>
          apiV1GetAllSymbolMT4UserIdGetAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CtraderUpdateRiskPostRiskTypeNullableToJson(
    enums.ApiV1CtraderUpdateRiskPostRiskType?
        apiV1CtraderUpdateRiskPostRiskType) {
  return apiV1CtraderUpdateRiskPostRiskType?.value;
}

int? apiV1CtraderUpdateRiskPostRiskTypeToJson(
    enums.ApiV1CtraderUpdateRiskPostRiskType
        apiV1CtraderUpdateRiskPostRiskType) {
  return apiV1CtraderUpdateRiskPostRiskType.value;
}

enums.ApiV1CtraderUpdateRiskPostRiskType
    apiV1CtraderUpdateRiskPostRiskTypeFromJson(
  Object? apiV1CtraderUpdateRiskPostRiskType, [
  enums.ApiV1CtraderUpdateRiskPostRiskType? defaultValue,
]) {
  return enums.ApiV1CtraderUpdateRiskPostRiskType.values.firstWhereOrNull(
          (e) => e.value == apiV1CtraderUpdateRiskPostRiskType) ??
      defaultValue ??
      enums.ApiV1CtraderUpdateRiskPostRiskType.swaggerGeneratedUnknown;
}

enums.ApiV1CtraderUpdateRiskPostRiskType?
    apiV1CtraderUpdateRiskPostRiskTypeNullableFromJson(
  Object? apiV1CtraderUpdateRiskPostRiskType, [
  enums.ApiV1CtraderUpdateRiskPostRiskType? defaultValue,
]) {
  if (apiV1CtraderUpdateRiskPostRiskType == null) {
    return null;
  }
  return enums.ApiV1CtraderUpdateRiskPostRiskType.values.firstWhereOrNull(
          (e) => e.value == apiV1CtraderUpdateRiskPostRiskType) ??
      defaultValue;
}

String apiV1CtraderUpdateRiskPostRiskTypeExplodedListToJson(
    List<enums.ApiV1CtraderUpdateRiskPostRiskType>?
        apiV1CtraderUpdateRiskPostRiskType) {
  return apiV1CtraderUpdateRiskPostRiskType?.map((e) => e.value!).join(',') ??
      '';
}

List<int> apiV1CtraderUpdateRiskPostRiskTypeListToJson(
    List<enums.ApiV1CtraderUpdateRiskPostRiskType>?
        apiV1CtraderUpdateRiskPostRiskType) {
  if (apiV1CtraderUpdateRiskPostRiskType == null) {
    return [];
  }

  return apiV1CtraderUpdateRiskPostRiskType.map((e) => e.value!).toList();
}

List<enums.ApiV1CtraderUpdateRiskPostRiskType>
    apiV1CtraderUpdateRiskPostRiskTypeListFromJson(
  List? apiV1CtraderUpdateRiskPostRiskType, [
  List<enums.ApiV1CtraderUpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1CtraderUpdateRiskPostRiskType == null) {
    return defaultValue ?? [];
  }

  return apiV1CtraderUpdateRiskPostRiskType
      .map((e) => apiV1CtraderUpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CtraderUpdateRiskPostRiskType>?
    apiV1CtraderUpdateRiskPostRiskTypeNullableListFromJson(
  List? apiV1CtraderUpdateRiskPostRiskType, [
  List<enums.ApiV1CtraderUpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1CtraderUpdateRiskPostRiskType == null) {
    return defaultValue;
  }

  return apiV1CtraderUpdateRiskPostRiskType
      .map((e) => apiV1CtraderUpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

int? apiV1CtraderUpdateStopsLimitsPostScalperModeNullableToJson(
    enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode?
        apiV1CtraderUpdateStopsLimitsPostScalperMode) {
  return apiV1CtraderUpdateStopsLimitsPostScalperMode?.value;
}

int? apiV1CtraderUpdateStopsLimitsPostScalperModeToJson(
    enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode
        apiV1CtraderUpdateStopsLimitsPostScalperMode) {
  return apiV1CtraderUpdateStopsLimitsPostScalperMode.value;
}

enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode
    apiV1CtraderUpdateStopsLimitsPostScalperModeFromJson(
  Object? apiV1CtraderUpdateStopsLimitsPostScalperMode, [
  enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  return enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CtraderUpdateStopsLimitsPostScalperMode) ??
      defaultValue ??
      enums
          .ApiV1CtraderUpdateStopsLimitsPostScalperMode.swaggerGeneratedUnknown;
}

enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode?
    apiV1CtraderUpdateStopsLimitsPostScalperModeNullableFromJson(
  Object? apiV1CtraderUpdateStopsLimitsPostScalperMode, [
  enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  if (apiV1CtraderUpdateStopsLimitsPostScalperMode == null) {
    return null;
  }
  return enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CtraderUpdateStopsLimitsPostScalperMode) ??
      defaultValue;
}

String apiV1CtraderUpdateStopsLimitsPostScalperModeExplodedListToJson(
    List<enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode>?
        apiV1CtraderUpdateStopsLimitsPostScalperMode) {
  return apiV1CtraderUpdateStopsLimitsPostScalperMode
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CtraderUpdateStopsLimitsPostScalperModeListToJson(
    List<enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode>?
        apiV1CtraderUpdateStopsLimitsPostScalperMode) {
  if (apiV1CtraderUpdateStopsLimitsPostScalperMode == null) {
    return [];
  }

  return apiV1CtraderUpdateStopsLimitsPostScalperMode
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode>
    apiV1CtraderUpdateStopsLimitsPostScalperModeListFromJson(
  List? apiV1CtraderUpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1CtraderUpdateStopsLimitsPostScalperMode == null) {
    return defaultValue ?? [];
  }

  return apiV1CtraderUpdateStopsLimitsPostScalperMode
      .map((e) =>
          apiV1CtraderUpdateStopsLimitsPostScalperModeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode>?
    apiV1CtraderUpdateStopsLimitsPostScalperModeNullableListFromJson(
  List? apiV1CtraderUpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1CtraderUpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1CtraderUpdateStopsLimitsPostScalperMode == null) {
    return defaultValue;
  }

  return apiV1CtraderUpdateStopsLimitsPostScalperMode
      .map((e) =>
          apiV1CtraderUpdateStopsLimitsPostScalperModeFromJson(e.toString()))
      .toList();
}

int? apiV1CtraderUpdateStopsLimitsPostOrderFilterNullableToJson(
    enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter?
        apiV1CtraderUpdateStopsLimitsPostOrderFilter) {
  return apiV1CtraderUpdateStopsLimitsPostOrderFilter?.value;
}

int? apiV1CtraderUpdateStopsLimitsPostOrderFilterToJson(
    enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter
        apiV1CtraderUpdateStopsLimitsPostOrderFilter) {
  return apiV1CtraderUpdateStopsLimitsPostOrderFilter.value;
}

enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter
    apiV1CtraderUpdateStopsLimitsPostOrderFilterFromJson(
  Object? apiV1CtraderUpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  return enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CtraderUpdateStopsLimitsPostOrderFilter) ??
      defaultValue ??
      enums
          .ApiV1CtraderUpdateStopsLimitsPostOrderFilter.swaggerGeneratedUnknown;
}

enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter?
    apiV1CtraderUpdateStopsLimitsPostOrderFilterNullableFromJson(
  Object? apiV1CtraderUpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  if (apiV1CtraderUpdateStopsLimitsPostOrderFilter == null) {
    return null;
  }
  return enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter.values
          .firstWhereOrNull(
              (e) => e.value == apiV1CtraderUpdateStopsLimitsPostOrderFilter) ??
      defaultValue;
}

String apiV1CtraderUpdateStopsLimitsPostOrderFilterExplodedListToJson(
    List<enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter>?
        apiV1CtraderUpdateStopsLimitsPostOrderFilter) {
  return apiV1CtraderUpdateStopsLimitsPostOrderFilter
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CtraderUpdateStopsLimitsPostOrderFilterListToJson(
    List<enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter>?
        apiV1CtraderUpdateStopsLimitsPostOrderFilter) {
  if (apiV1CtraderUpdateStopsLimitsPostOrderFilter == null) {
    return [];
  }

  return apiV1CtraderUpdateStopsLimitsPostOrderFilter
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter>
    apiV1CtraderUpdateStopsLimitsPostOrderFilterListFromJson(
  List? apiV1CtraderUpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1CtraderUpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue ?? [];
  }

  return apiV1CtraderUpdateStopsLimitsPostOrderFilter
      .map((e) =>
          apiV1CtraderUpdateStopsLimitsPostOrderFilterFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter>?
    apiV1CtraderUpdateStopsLimitsPostOrderFilterNullableListFromJson(
  List? apiV1CtraderUpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1CtraderUpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1CtraderUpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue;
  }

  return apiV1CtraderUpdateStopsLimitsPostOrderFilter
      .map((e) =>
          apiV1CtraderUpdateStopsLimitsPostOrderFilterFromJson(e.toString()))
      .toList();
}

int? apiV1GetOpenPositionDxTradePostAccountStatusNullableToJson(
    enums.ApiV1GetOpenPositionDxTradePostAccountStatus?
        apiV1GetOpenPositionDxTradePostAccountStatus) {
  return apiV1GetOpenPositionDxTradePostAccountStatus?.value;
}

int? apiV1GetOpenPositionDxTradePostAccountStatusToJson(
    enums.ApiV1GetOpenPositionDxTradePostAccountStatus
        apiV1GetOpenPositionDxTradePostAccountStatus) {
  return apiV1GetOpenPositionDxTradePostAccountStatus.value;
}

enums.ApiV1GetOpenPositionDxTradePostAccountStatus
    apiV1GetOpenPositionDxTradePostAccountStatusFromJson(
  Object? apiV1GetOpenPositionDxTradePostAccountStatus, [
  enums.ApiV1GetOpenPositionDxTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOpenPositionDxTradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetOpenPositionDxTradePostAccountStatus) ??
      defaultValue ??
      enums
          .ApiV1GetOpenPositionDxTradePostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetOpenPositionDxTradePostAccountStatus?
    apiV1GetOpenPositionDxTradePostAccountStatusNullableFromJson(
  Object? apiV1GetOpenPositionDxTradePostAccountStatus, [
  enums.ApiV1GetOpenPositionDxTradePostAccountStatus? defaultValue,
]) {
  if (apiV1GetOpenPositionDxTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOpenPositionDxTradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetOpenPositionDxTradePostAccountStatus) ??
      defaultValue;
}

String apiV1GetOpenPositionDxTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOpenPositionDxTradePostAccountStatus>?
        apiV1GetOpenPositionDxTradePostAccountStatus) {
  return apiV1GetOpenPositionDxTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetOpenPositionDxTradePostAccountStatusListToJson(
    List<enums.ApiV1GetOpenPositionDxTradePostAccountStatus>?
        apiV1GetOpenPositionDxTradePostAccountStatus) {
  if (apiV1GetOpenPositionDxTradePostAccountStatus == null) {
    return [];
  }

  return apiV1GetOpenPositionDxTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetOpenPositionDxTradePostAccountStatus>
    apiV1GetOpenPositionDxTradePostAccountStatusListFromJson(
  List? apiV1GetOpenPositionDxTradePostAccountStatus, [
  List<enums.ApiV1GetOpenPositionDxTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOpenPositionDxTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOpenPositionDxTradePostAccountStatus
      .map((e) =>
          apiV1GetOpenPositionDxTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetOpenPositionDxTradePostAccountStatus>?
    apiV1GetOpenPositionDxTradePostAccountStatusNullableListFromJson(
  List? apiV1GetOpenPositionDxTradePostAccountStatus, [
  List<enums.ApiV1GetOpenPositionDxTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOpenPositionDxTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOpenPositionDxTradePostAccountStatus
      .map((e) =>
          apiV1GetOpenPositionDxTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ModifyPositionDxtradePostAccountStatusNullableToJson(
    enums.ApiV1ModifyPositionDxtradePostAccountStatus?
        apiV1ModifyPositionDxtradePostAccountStatus) {
  return apiV1ModifyPositionDxtradePostAccountStatus?.value;
}

int? apiV1ModifyPositionDxtradePostAccountStatusToJson(
    enums.ApiV1ModifyPositionDxtradePostAccountStatus
        apiV1ModifyPositionDxtradePostAccountStatus) {
  return apiV1ModifyPositionDxtradePostAccountStatus.value;
}

enums.ApiV1ModifyPositionDxtradePostAccountStatus
    apiV1ModifyPositionDxtradePostAccountStatusFromJson(
  Object? apiV1ModifyPositionDxtradePostAccountStatus, [
  enums.ApiV1ModifyPositionDxtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyPositionDxtradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1ModifyPositionDxtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyPositionDxtradePostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1ModifyPositionDxtradePostAccountStatus?
    apiV1ModifyPositionDxtradePostAccountStatusNullableFromJson(
  Object? apiV1ModifyPositionDxtradePostAccountStatus, [
  enums.ApiV1ModifyPositionDxtradePostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyPositionDxtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyPositionDxtradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1ModifyPositionDxtradePostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyPositionDxtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyPositionDxtradePostAccountStatus>?
        apiV1ModifyPositionDxtradePostAccountStatus) {
  return apiV1ModifyPositionDxtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ModifyPositionDxtradePostAccountStatusListToJson(
    List<enums.ApiV1ModifyPositionDxtradePostAccountStatus>?
        apiV1ModifyPositionDxtradePostAccountStatus) {
  if (apiV1ModifyPositionDxtradePostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyPositionDxtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ModifyPositionDxtradePostAccountStatus>
    apiV1ModifyPositionDxtradePostAccountStatusListFromJson(
  List? apiV1ModifyPositionDxtradePostAccountStatus, [
  List<enums.ApiV1ModifyPositionDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPositionDxtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyPositionDxtradePostAccountStatus
      .map((e) =>
          apiV1ModifyPositionDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ModifyPositionDxtradePostAccountStatus>?
    apiV1ModifyPositionDxtradePostAccountStatusNullableListFromJson(
  List? apiV1ModifyPositionDxtradePostAccountStatus, [
  List<enums.ApiV1ModifyPositionDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPositionDxtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyPositionDxtradePostAccountStatus
      .map((e) =>
          apiV1ModifyPositionDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ClosePositionDxtradePostAccountStatusNullableToJson(
    enums.ApiV1ClosePositionDxtradePostAccountStatus?
        apiV1ClosePositionDxtradePostAccountStatus) {
  return apiV1ClosePositionDxtradePostAccountStatus?.value;
}

int? apiV1ClosePositionDxtradePostAccountStatusToJson(
    enums.ApiV1ClosePositionDxtradePostAccountStatus
        apiV1ClosePositionDxtradePostAccountStatus) {
  return apiV1ClosePositionDxtradePostAccountStatus.value;
}

enums.ApiV1ClosePositionDxtradePostAccountStatus
    apiV1ClosePositionDxtradePostAccountStatusFromJson(
  Object? apiV1ClosePositionDxtradePostAccountStatus, [
  enums.ApiV1ClosePositionDxtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ClosePositionDxtradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1ClosePositionDxtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ClosePositionDxtradePostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1ClosePositionDxtradePostAccountStatus?
    apiV1ClosePositionDxtradePostAccountStatusNullableFromJson(
  Object? apiV1ClosePositionDxtradePostAccountStatus, [
  enums.ApiV1ClosePositionDxtradePostAccountStatus? defaultValue,
]) {
  if (apiV1ClosePositionDxtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ClosePositionDxtradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1ClosePositionDxtradePostAccountStatus) ??
      defaultValue;
}

String apiV1ClosePositionDxtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1ClosePositionDxtradePostAccountStatus>?
        apiV1ClosePositionDxtradePostAccountStatus) {
  return apiV1ClosePositionDxtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ClosePositionDxtradePostAccountStatusListToJson(
    List<enums.ApiV1ClosePositionDxtradePostAccountStatus>?
        apiV1ClosePositionDxtradePostAccountStatus) {
  if (apiV1ClosePositionDxtradePostAccountStatus == null) {
    return [];
  }

  return apiV1ClosePositionDxtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ClosePositionDxtradePostAccountStatus>
    apiV1ClosePositionDxtradePostAccountStatusListFromJson(
  List? apiV1ClosePositionDxtradePostAccountStatus, [
  List<enums.ApiV1ClosePositionDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePositionDxtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ClosePositionDxtradePostAccountStatus
      .map((e) =>
          apiV1ClosePositionDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ClosePositionDxtradePostAccountStatus>?
    apiV1ClosePositionDxtradePostAccountStatusNullableListFromJson(
  List? apiV1ClosePositionDxtradePostAccountStatus, [
  List<enums.ApiV1ClosePositionDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePositionDxtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ClosePositionDxtradePostAccountStatus
      .map((e) =>
          apiV1ClosePositionDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1PartialCloseOrderDxtradePostAccountStatusNullableToJson(
    enums.ApiV1PartialCloseOrderDxtradePostAccountStatus?
        apiV1PartialCloseOrderDxtradePostAccountStatus) {
  return apiV1PartialCloseOrderDxtradePostAccountStatus?.value;
}

int? apiV1PartialCloseOrderDxtradePostAccountStatusToJson(
    enums.ApiV1PartialCloseOrderDxtradePostAccountStatus
        apiV1PartialCloseOrderDxtradePostAccountStatus) {
  return apiV1PartialCloseOrderDxtradePostAccountStatus.value;
}

enums.ApiV1PartialCloseOrderDxtradePostAccountStatus
    apiV1PartialCloseOrderDxtradePostAccountStatusFromJson(
  Object? apiV1PartialCloseOrderDxtradePostAccountStatus, [
  enums.ApiV1PartialCloseOrderDxtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1PartialCloseOrderDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1PartialCloseOrderDxtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1PartialCloseOrderDxtradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1PartialCloseOrderDxtradePostAccountStatus?
    apiV1PartialCloseOrderDxtradePostAccountStatusNullableFromJson(
  Object? apiV1PartialCloseOrderDxtradePostAccountStatus, [
  enums.ApiV1PartialCloseOrderDxtradePostAccountStatus? defaultValue,
]) {
  if (apiV1PartialCloseOrderDxtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1PartialCloseOrderDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1PartialCloseOrderDxtradePostAccountStatus) ??
      defaultValue;
}

String apiV1PartialCloseOrderDxtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1PartialCloseOrderDxtradePostAccountStatus>?
        apiV1PartialCloseOrderDxtradePostAccountStatus) {
  return apiV1PartialCloseOrderDxtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1PartialCloseOrderDxtradePostAccountStatusListToJson(
    List<enums.ApiV1PartialCloseOrderDxtradePostAccountStatus>?
        apiV1PartialCloseOrderDxtradePostAccountStatus) {
  if (apiV1PartialCloseOrderDxtradePostAccountStatus == null) {
    return [];
  }

  return apiV1PartialCloseOrderDxtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1PartialCloseOrderDxtradePostAccountStatus>
    apiV1PartialCloseOrderDxtradePostAccountStatusListFromJson(
  List? apiV1PartialCloseOrderDxtradePostAccountStatus, [
  List<enums.ApiV1PartialCloseOrderDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1PartialCloseOrderDxtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1PartialCloseOrderDxtradePostAccountStatus
      .map((e) =>
          apiV1PartialCloseOrderDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1PartialCloseOrderDxtradePostAccountStatus>?
    apiV1PartialCloseOrderDxtradePostAccountStatusNullableListFromJson(
  List? apiV1PartialCloseOrderDxtradePostAccountStatus, [
  List<enums.ApiV1PartialCloseOrderDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1PartialCloseOrderDxtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1PartialCloseOrderDxtradePostAccountStatus
      .map((e) =>
          apiV1PartialCloseOrderDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseAllOrdersForDxtradePostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus?
        apiV1CloseAllOrdersForDxtradePostAccountStatus) {
  return apiV1CloseAllOrdersForDxtradePostAccountStatus?.value;
}

int? apiV1CloseAllOrdersForDxtradePostAccountStatusToJson(
    enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus
        apiV1CloseAllOrdersForDxtradePostAccountStatus) {
  return apiV1CloseAllOrdersForDxtradePostAccountStatus.value;
}

enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus
    apiV1CloseAllOrdersForDxtradePostAccountStatusFromJson(
  Object? apiV1CloseAllOrdersForDxtradePostAccountStatus, [
  enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrdersForDxtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus?
    apiV1CloseAllOrdersForDxtradePostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrdersForDxtradePostAccountStatus, [
  enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrdersForDxtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrdersForDxtradePostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrdersForDxtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus>?
        apiV1CloseAllOrdersForDxtradePostAccountStatus) {
  return apiV1CloseAllOrdersForDxtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrdersForDxtradePostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus>?
        apiV1CloseAllOrdersForDxtradePostAccountStatus) {
  if (apiV1CloseAllOrdersForDxtradePostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrdersForDxtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus>
    apiV1CloseAllOrdersForDxtradePostAccountStatusListFromJson(
  List? apiV1CloseAllOrdersForDxtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForDxtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrdersForDxtradePostAccountStatus
      .map((e) =>
          apiV1CloseAllOrdersForDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus>?
    apiV1CloseAllOrdersForDxtradePostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrdersForDxtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForDxtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrdersForDxtradePostAccountStatus
      .map((e) =>
          apiV1CloseAllOrdersForDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySymbolForDxtradePostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus?
        apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySymbolForDxtradePostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus
        apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus
    apiV1CloseAllOrderBySymbolForDxtradePostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus?
    apiV1CloseAllOrderBySymbolForDxtradePostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderBySymbolForDxtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus>?
        apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySymbolForDxtradePostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus>?
        apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus) {
  if (apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus>
    apiV1CloseAllOrderBySymbolForDxtradePostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus
      .map((e) => apiV1CloseAllOrderBySymbolForDxtradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus>?
    apiV1CloseAllOrderBySymbolForDxtradePostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForDxtradePostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySymbolForDxtradePostAccountStatus
      .map((e) => apiV1CloseAllOrderBySymbolForDxtradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySellForDxtradePostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus?
        apiV1CloseAllOrderBySellForDxtradePostAccountStatus) {
  return apiV1CloseAllOrderBySellForDxtradePostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySellForDxtradePostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus
        apiV1CloseAllOrderBySellForDxtradePostAccountStatus) {
  return apiV1CloseAllOrderBySellForDxtradePostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus
    apiV1CloseAllOrderBySellForDxtradePostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySellForDxtradePostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderBySellForDxtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus?
    apiV1CloseAllOrderBySellForDxtradePostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySellForDxtradePostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellForDxtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderBySellForDxtradePostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderBySellForDxtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus>?
        apiV1CloseAllOrderBySellForDxtradePostAccountStatus) {
  return apiV1CloseAllOrderBySellForDxtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySellForDxtradePostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus>?
        apiV1CloseAllOrderBySellForDxtradePostAccountStatus) {
  if (apiV1CloseAllOrderBySellForDxtradePostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySellForDxtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus>
    apiV1CloseAllOrderBySellForDxtradePostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySellForDxtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellForDxtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySellForDxtradePostAccountStatus
      .map((e) => apiV1CloseAllOrderBySellForDxtradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus>?
    apiV1CloseAllOrderBySellForDxtradePostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySellForDxtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellForDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellForDxtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySellForDxtradePostAccountStatus
      .map((e) => apiV1CloseAllOrderBySellForDxtradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1CloseAllOrderByBuyForDxtradePostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus?
        apiV1CloseAllOrderByBuyForDxtradePostAccountStatus) {
  return apiV1CloseAllOrderByBuyForDxtradePostAccountStatus?.value;
}

int? apiV1CloseAllOrderByBuyForDxtradePostAccountStatusToJson(
    enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus
        apiV1CloseAllOrderByBuyForDxtradePostAccountStatus) {
  return apiV1CloseAllOrderByBuyForDxtradePostAccountStatus.value;
}

enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus
    apiV1CloseAllOrderByBuyForDxtradePostAccountStatusFromJson(
  Object? apiV1CloseAllOrderByBuyForDxtradePostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderByBuyForDxtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus?
    apiV1CloseAllOrderByBuyForDxtradePostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderByBuyForDxtradePostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyForDxtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrderByBuyForDxtradePostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderByBuyForDxtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus>?
        apiV1CloseAllOrderByBuyForDxtradePostAccountStatus) {
  return apiV1CloseAllOrderByBuyForDxtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderByBuyForDxtradePostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus>?
        apiV1CloseAllOrderByBuyForDxtradePostAccountStatus) {
  if (apiV1CloseAllOrderByBuyForDxtradePostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderByBuyForDxtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus>
    apiV1CloseAllOrderByBuyForDxtradePostAccountStatusListFromJson(
  List? apiV1CloseAllOrderByBuyForDxtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyForDxtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderByBuyForDxtradePostAccountStatus
      .map((e) => apiV1CloseAllOrderByBuyForDxtradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus>?
    apiV1CloseAllOrderByBuyForDxtradePostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderByBuyForDxtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyForDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyForDxtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderByBuyForDxtradePostAccountStatus
      .map((e) => apiV1CloseAllOrderByBuyForDxtradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1GetPendingOrdersDxTradePostAccountStatusNullableToJson(
    enums.ApiV1GetPendingOrdersDxTradePostAccountStatus?
        apiV1GetPendingOrdersDxTradePostAccountStatus) {
  return apiV1GetPendingOrdersDxTradePostAccountStatus?.value;
}

int? apiV1GetPendingOrdersDxTradePostAccountStatusToJson(
    enums.ApiV1GetPendingOrdersDxTradePostAccountStatus
        apiV1GetPendingOrdersDxTradePostAccountStatus) {
  return apiV1GetPendingOrdersDxTradePostAccountStatus.value;
}

enums.ApiV1GetPendingOrdersDxTradePostAccountStatus
    apiV1GetPendingOrdersDxTradePostAccountStatusFromJson(
  Object? apiV1GetPendingOrdersDxTradePostAccountStatus, [
  enums.ApiV1GetPendingOrdersDxTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetPendingOrdersDxTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetPendingOrdersDxTradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetPendingOrdersDxTradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1GetPendingOrdersDxTradePostAccountStatus?
    apiV1GetPendingOrdersDxTradePostAccountStatusNullableFromJson(
  Object? apiV1GetPendingOrdersDxTradePostAccountStatus, [
  enums.ApiV1GetPendingOrdersDxTradePostAccountStatus? defaultValue,
]) {
  if (apiV1GetPendingOrdersDxTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetPendingOrdersDxTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetPendingOrdersDxTradePostAccountStatus) ??
      defaultValue;
}

String apiV1GetPendingOrdersDxTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetPendingOrdersDxTradePostAccountStatus>?
        apiV1GetPendingOrdersDxTradePostAccountStatus) {
  return apiV1GetPendingOrdersDxTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetPendingOrdersDxTradePostAccountStatusListToJson(
    List<enums.ApiV1GetPendingOrdersDxTradePostAccountStatus>?
        apiV1GetPendingOrdersDxTradePostAccountStatus) {
  if (apiV1GetPendingOrdersDxTradePostAccountStatus == null) {
    return [];
  }

  return apiV1GetPendingOrdersDxTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetPendingOrdersDxTradePostAccountStatus>
    apiV1GetPendingOrdersDxTradePostAccountStatusListFromJson(
  List? apiV1GetPendingOrdersDxTradePostAccountStatus, [
  List<enums.ApiV1GetPendingOrdersDxTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1GetPendingOrdersDxTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetPendingOrdersDxTradePostAccountStatus
      .map((e) =>
          apiV1GetPendingOrdersDxTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetPendingOrdersDxTradePostAccountStatus>?
    apiV1GetPendingOrdersDxTradePostAccountStatusNullableListFromJson(
  List? apiV1GetPendingOrdersDxTradePostAccountStatus, [
  List<enums.ApiV1GetPendingOrdersDxTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1GetPendingOrdersDxTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetPendingOrdersDxTradePostAccountStatus
      .map((e) =>
          apiV1GetPendingOrdersDxTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ModifyPendingOrderDxtradePostAccountStatusNullableToJson(
    enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus?
        apiV1ModifyPendingOrderDxtradePostAccountStatus) {
  return apiV1ModifyPendingOrderDxtradePostAccountStatus?.value;
}

int? apiV1ModifyPendingOrderDxtradePostAccountStatusToJson(
    enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus
        apiV1ModifyPendingOrderDxtradePostAccountStatus) {
  return apiV1ModifyPendingOrderDxtradePostAccountStatus.value;
}

enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus
    apiV1ModifyPendingOrderDxtradePostAccountStatusFromJson(
  Object? apiV1ModifyPendingOrderDxtradePostAccountStatus, [
  enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPendingOrderDxtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus?
    apiV1ModifyPendingOrderDxtradePostAccountStatusNullableFromJson(
  Object? apiV1ModifyPendingOrderDxtradePostAccountStatus, [
  enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyPendingOrderDxtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPendingOrderDxtradePostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyPendingOrderDxtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus>?
        apiV1ModifyPendingOrderDxtradePostAccountStatus) {
  return apiV1ModifyPendingOrderDxtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ModifyPendingOrderDxtradePostAccountStatusListToJson(
    List<enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus>?
        apiV1ModifyPendingOrderDxtradePostAccountStatus) {
  if (apiV1ModifyPendingOrderDxtradePostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyPendingOrderDxtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus>
    apiV1ModifyPendingOrderDxtradePostAccountStatusListFromJson(
  List? apiV1ModifyPendingOrderDxtradePostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderDxtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyPendingOrderDxtradePostAccountStatus
      .map((e) =>
          apiV1ModifyPendingOrderDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus>?
    apiV1ModifyPendingOrderDxtradePostAccountStatusNullableListFromJson(
  List? apiV1ModifyPendingOrderDxtradePostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderDxtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyPendingOrderDxtradePostAccountStatus
      .map((e) =>
          apiV1ModifyPendingOrderDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ClosePendingOrderDxtradePostAccountStatusNullableToJson(
    enums.ApiV1ClosePendingOrderDxtradePostAccountStatus?
        apiV1ClosePendingOrderDxtradePostAccountStatus) {
  return apiV1ClosePendingOrderDxtradePostAccountStatus?.value;
}

int? apiV1ClosePendingOrderDxtradePostAccountStatusToJson(
    enums.ApiV1ClosePendingOrderDxtradePostAccountStatus
        apiV1ClosePendingOrderDxtradePostAccountStatus) {
  return apiV1ClosePendingOrderDxtradePostAccountStatus.value;
}

enums.ApiV1ClosePendingOrderDxtradePostAccountStatus
    apiV1ClosePendingOrderDxtradePostAccountStatusFromJson(
  Object? apiV1ClosePendingOrderDxtradePostAccountStatus, [
  enums.ApiV1ClosePendingOrderDxtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ClosePendingOrderDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePendingOrderDxtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ClosePendingOrderDxtradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ClosePendingOrderDxtradePostAccountStatus?
    apiV1ClosePendingOrderDxtradePostAccountStatusNullableFromJson(
  Object? apiV1ClosePendingOrderDxtradePostAccountStatus, [
  enums.ApiV1ClosePendingOrderDxtradePostAccountStatus? defaultValue,
]) {
  if (apiV1ClosePendingOrderDxtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ClosePendingOrderDxtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePendingOrderDxtradePostAccountStatus) ??
      defaultValue;
}

String apiV1ClosePendingOrderDxtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1ClosePendingOrderDxtradePostAccountStatus>?
        apiV1ClosePendingOrderDxtradePostAccountStatus) {
  return apiV1ClosePendingOrderDxtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ClosePendingOrderDxtradePostAccountStatusListToJson(
    List<enums.ApiV1ClosePendingOrderDxtradePostAccountStatus>?
        apiV1ClosePendingOrderDxtradePostAccountStatus) {
  if (apiV1ClosePendingOrderDxtradePostAccountStatus == null) {
    return [];
  }

  return apiV1ClosePendingOrderDxtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ClosePendingOrderDxtradePostAccountStatus>
    apiV1ClosePendingOrderDxtradePostAccountStatusListFromJson(
  List? apiV1ClosePendingOrderDxtradePostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderDxtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ClosePendingOrderDxtradePostAccountStatus
      .map((e) =>
          apiV1ClosePendingOrderDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ClosePendingOrderDxtradePostAccountStatus>?
    apiV1ClosePendingOrderDxtradePostAccountStatusNullableListFromJson(
  List? apiV1ClosePendingOrderDxtradePostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderDxtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ClosePendingOrderDxtradePostAccountStatus
      .map((e) =>
          apiV1ClosePendingOrderDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrderHistoryDxtradePostAccountStatusNullableToJson(
    enums.ApiV1GetOrderHistoryDxtradePostAccountStatus?
        apiV1GetOrderHistoryDxtradePostAccountStatus) {
  return apiV1GetOrderHistoryDxtradePostAccountStatus?.value;
}

int? apiV1GetOrderHistoryDxtradePostAccountStatusToJson(
    enums.ApiV1GetOrderHistoryDxtradePostAccountStatus
        apiV1GetOrderHistoryDxtradePostAccountStatus) {
  return apiV1GetOrderHistoryDxtradePostAccountStatus.value;
}

enums.ApiV1GetOrderHistoryDxtradePostAccountStatus
    apiV1GetOrderHistoryDxtradePostAccountStatusFromJson(
  Object? apiV1GetOrderHistoryDxtradePostAccountStatus, [
  enums.ApiV1GetOrderHistoryDxtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrderHistoryDxtradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetOrderHistoryDxtradePostAccountStatus) ??
      defaultValue ??
      enums
          .ApiV1GetOrderHistoryDxtradePostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetOrderHistoryDxtradePostAccountStatus?
    apiV1GetOrderHistoryDxtradePostAccountStatusNullableFromJson(
  Object? apiV1GetOrderHistoryDxtradePostAccountStatus, [
  enums.ApiV1GetOrderHistoryDxtradePostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrderHistoryDxtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrderHistoryDxtradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetOrderHistoryDxtradePostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrderHistoryDxtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrderHistoryDxtradePostAccountStatus>?
        apiV1GetOrderHistoryDxtradePostAccountStatus) {
  return apiV1GetOrderHistoryDxtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetOrderHistoryDxtradePostAccountStatusListToJson(
    List<enums.ApiV1GetOrderHistoryDxtradePostAccountStatus>?
        apiV1GetOrderHistoryDxtradePostAccountStatus) {
  if (apiV1GetOrderHistoryDxtradePostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrderHistoryDxtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetOrderHistoryDxtradePostAccountStatus>
    apiV1GetOrderHistoryDxtradePostAccountStatusListFromJson(
  List? apiV1GetOrderHistoryDxtradePostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryDxtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrderHistoryDxtradePostAccountStatus
      .map((e) =>
          apiV1GetOrderHistoryDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetOrderHistoryDxtradePostAccountStatus>?
    apiV1GetOrderHistoryDxtradePostAccountStatusNullableListFromJson(
  List? apiV1GetOrderHistoryDxtradePostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryDxtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryDxtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrderHistoryDxtradePostAccountStatus
      .map((e) =>
          apiV1GetOrderHistoryDxtradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1DxTradeUpdateRiskPostRiskTypeNullableToJson(
    enums.ApiV1DxTradeUpdateRiskPostRiskType?
        apiV1DxTradeUpdateRiskPostRiskType) {
  return apiV1DxTradeUpdateRiskPostRiskType?.value;
}

int? apiV1DxTradeUpdateRiskPostRiskTypeToJson(
    enums.ApiV1DxTradeUpdateRiskPostRiskType
        apiV1DxTradeUpdateRiskPostRiskType) {
  return apiV1DxTradeUpdateRiskPostRiskType.value;
}

enums.ApiV1DxTradeUpdateRiskPostRiskType
    apiV1DxTradeUpdateRiskPostRiskTypeFromJson(
  Object? apiV1DxTradeUpdateRiskPostRiskType, [
  enums.ApiV1DxTradeUpdateRiskPostRiskType? defaultValue,
]) {
  return enums.ApiV1DxTradeUpdateRiskPostRiskType.values.firstWhereOrNull(
          (e) => e.value == apiV1DxTradeUpdateRiskPostRiskType) ??
      defaultValue ??
      enums.ApiV1DxTradeUpdateRiskPostRiskType.swaggerGeneratedUnknown;
}

enums.ApiV1DxTradeUpdateRiskPostRiskType?
    apiV1DxTradeUpdateRiskPostRiskTypeNullableFromJson(
  Object? apiV1DxTradeUpdateRiskPostRiskType, [
  enums.ApiV1DxTradeUpdateRiskPostRiskType? defaultValue,
]) {
  if (apiV1DxTradeUpdateRiskPostRiskType == null) {
    return null;
  }
  return enums.ApiV1DxTradeUpdateRiskPostRiskType.values.firstWhereOrNull(
          (e) => e.value == apiV1DxTradeUpdateRiskPostRiskType) ??
      defaultValue;
}

String apiV1DxTradeUpdateRiskPostRiskTypeExplodedListToJson(
    List<enums.ApiV1DxTradeUpdateRiskPostRiskType>?
        apiV1DxTradeUpdateRiskPostRiskType) {
  return apiV1DxTradeUpdateRiskPostRiskType?.map((e) => e.value!).join(',') ??
      '';
}

List<int> apiV1DxTradeUpdateRiskPostRiskTypeListToJson(
    List<enums.ApiV1DxTradeUpdateRiskPostRiskType>?
        apiV1DxTradeUpdateRiskPostRiskType) {
  if (apiV1DxTradeUpdateRiskPostRiskType == null) {
    return [];
  }

  return apiV1DxTradeUpdateRiskPostRiskType.map((e) => e.value!).toList();
}

List<enums.ApiV1DxTradeUpdateRiskPostRiskType>
    apiV1DxTradeUpdateRiskPostRiskTypeListFromJson(
  List? apiV1DxTradeUpdateRiskPostRiskType, [
  List<enums.ApiV1DxTradeUpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1DxTradeUpdateRiskPostRiskType == null) {
    return defaultValue ?? [];
  }

  return apiV1DxTradeUpdateRiskPostRiskType
      .map((e) => apiV1DxTradeUpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1DxTradeUpdateRiskPostRiskType>?
    apiV1DxTradeUpdateRiskPostRiskTypeNullableListFromJson(
  List? apiV1DxTradeUpdateRiskPostRiskType, [
  List<enums.ApiV1DxTradeUpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1DxTradeUpdateRiskPostRiskType == null) {
    return defaultValue;
  }

  return apiV1DxTradeUpdateRiskPostRiskType
      .map((e) => apiV1DxTradeUpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

int? apiV1DxTradeUpdateStopsLimitsPostScalperModeNullableToJson(
    enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode?
        apiV1DxTradeUpdateStopsLimitsPostScalperMode) {
  return apiV1DxTradeUpdateStopsLimitsPostScalperMode?.value;
}

int? apiV1DxTradeUpdateStopsLimitsPostScalperModeToJson(
    enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode
        apiV1DxTradeUpdateStopsLimitsPostScalperMode) {
  return apiV1DxTradeUpdateStopsLimitsPostScalperMode.value;
}

enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode
    apiV1DxTradeUpdateStopsLimitsPostScalperModeFromJson(
  Object? apiV1DxTradeUpdateStopsLimitsPostScalperMode, [
  enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  return enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode.values
          .firstWhereOrNull(
              (e) => e.value == apiV1DxTradeUpdateStopsLimitsPostScalperMode) ??
      defaultValue ??
      enums
          .ApiV1DxTradeUpdateStopsLimitsPostScalperMode.swaggerGeneratedUnknown;
}

enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode?
    apiV1DxTradeUpdateStopsLimitsPostScalperModeNullableFromJson(
  Object? apiV1DxTradeUpdateStopsLimitsPostScalperMode, [
  enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  if (apiV1DxTradeUpdateStopsLimitsPostScalperMode == null) {
    return null;
  }
  return enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode.values
          .firstWhereOrNull(
              (e) => e.value == apiV1DxTradeUpdateStopsLimitsPostScalperMode) ??
      defaultValue;
}

String apiV1DxTradeUpdateStopsLimitsPostScalperModeExplodedListToJson(
    List<enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode>?
        apiV1DxTradeUpdateStopsLimitsPostScalperMode) {
  return apiV1DxTradeUpdateStopsLimitsPostScalperMode
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1DxTradeUpdateStopsLimitsPostScalperModeListToJson(
    List<enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode>?
        apiV1DxTradeUpdateStopsLimitsPostScalperMode) {
  if (apiV1DxTradeUpdateStopsLimitsPostScalperMode == null) {
    return [];
  }

  return apiV1DxTradeUpdateStopsLimitsPostScalperMode
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode>
    apiV1DxTradeUpdateStopsLimitsPostScalperModeListFromJson(
  List? apiV1DxTradeUpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1DxTradeUpdateStopsLimitsPostScalperMode == null) {
    return defaultValue ?? [];
  }

  return apiV1DxTradeUpdateStopsLimitsPostScalperMode
      .map((e) =>
          apiV1DxTradeUpdateStopsLimitsPostScalperModeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode>?
    apiV1DxTradeUpdateStopsLimitsPostScalperModeNullableListFromJson(
  List? apiV1DxTradeUpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1DxTradeUpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1DxTradeUpdateStopsLimitsPostScalperMode == null) {
    return defaultValue;
  }

  return apiV1DxTradeUpdateStopsLimitsPostScalperMode
      .map((e) =>
          apiV1DxTradeUpdateStopsLimitsPostScalperModeFromJson(e.toString()))
      .toList();
}

int? apiV1DxTradeUpdateStopsLimitsPostOrderFilterNullableToJson(
    enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter?
        apiV1DxTradeUpdateStopsLimitsPostOrderFilter) {
  return apiV1DxTradeUpdateStopsLimitsPostOrderFilter?.value;
}

int? apiV1DxTradeUpdateStopsLimitsPostOrderFilterToJson(
    enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter
        apiV1DxTradeUpdateStopsLimitsPostOrderFilter) {
  return apiV1DxTradeUpdateStopsLimitsPostOrderFilter.value;
}

enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter
    apiV1DxTradeUpdateStopsLimitsPostOrderFilterFromJson(
  Object? apiV1DxTradeUpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  return enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter.values
          .firstWhereOrNull(
              (e) => e.value == apiV1DxTradeUpdateStopsLimitsPostOrderFilter) ??
      defaultValue ??
      enums
          .ApiV1DxTradeUpdateStopsLimitsPostOrderFilter.swaggerGeneratedUnknown;
}

enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter?
    apiV1DxTradeUpdateStopsLimitsPostOrderFilterNullableFromJson(
  Object? apiV1DxTradeUpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  if (apiV1DxTradeUpdateStopsLimitsPostOrderFilter == null) {
    return null;
  }
  return enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter.values
          .firstWhereOrNull(
              (e) => e.value == apiV1DxTradeUpdateStopsLimitsPostOrderFilter) ??
      defaultValue;
}

String apiV1DxTradeUpdateStopsLimitsPostOrderFilterExplodedListToJson(
    List<enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter>?
        apiV1DxTradeUpdateStopsLimitsPostOrderFilter) {
  return apiV1DxTradeUpdateStopsLimitsPostOrderFilter
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1DxTradeUpdateStopsLimitsPostOrderFilterListToJson(
    List<enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter>?
        apiV1DxTradeUpdateStopsLimitsPostOrderFilter) {
  if (apiV1DxTradeUpdateStopsLimitsPostOrderFilter == null) {
    return [];
  }

  return apiV1DxTradeUpdateStopsLimitsPostOrderFilter
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter>
    apiV1DxTradeUpdateStopsLimitsPostOrderFilterListFromJson(
  List? apiV1DxTradeUpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1DxTradeUpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue ?? [];
  }

  return apiV1DxTradeUpdateStopsLimitsPostOrderFilter
      .map((e) =>
          apiV1DxTradeUpdateStopsLimitsPostOrderFilterFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter>?
    apiV1DxTradeUpdateStopsLimitsPostOrderFilterNullableListFromJson(
  List? apiV1DxTradeUpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1DxTradeUpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1DxTradeUpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue;
  }

  return apiV1DxTradeUpdateStopsLimitsPostOrderFilter
      .map((e) =>
          apiV1DxTradeUpdateStopsLimitsPostOrderFilterFromJson(e.toString()))
      .toList();
}

int? apiV1SendPositionTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1SendPositionTradeLockerPostAccountStatus?
        apiV1SendPositionTradeLockerPostAccountStatus) {
  return apiV1SendPositionTradeLockerPostAccountStatus?.value;
}

int? apiV1SendPositionTradeLockerPostAccountStatusToJson(
    enums.ApiV1SendPositionTradeLockerPostAccountStatus
        apiV1SendPositionTradeLockerPostAccountStatus) {
  return apiV1SendPositionTradeLockerPostAccountStatus.value;
}

enums.ApiV1SendPositionTradeLockerPostAccountStatus
    apiV1SendPositionTradeLockerPostAccountStatusFromJson(
  Object? apiV1SendPositionTradeLockerPostAccountStatus, [
  enums.ApiV1SendPositionTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1SendPositionTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1SendPositionTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1SendPositionTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1SendPositionTradeLockerPostAccountStatus?
    apiV1SendPositionTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1SendPositionTradeLockerPostAccountStatus, [
  enums.ApiV1SendPositionTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1SendPositionTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1SendPositionTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1SendPositionTradeLockerPostAccountStatus) ??
      defaultValue;
}

String apiV1SendPositionTradeLockerPostAccountStatusExplodedListToJson(
    List<enums.ApiV1SendPositionTradeLockerPostAccountStatus>?
        apiV1SendPositionTradeLockerPostAccountStatus) {
  return apiV1SendPositionTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1SendPositionTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1SendPositionTradeLockerPostAccountStatus>?
        apiV1SendPositionTradeLockerPostAccountStatus) {
  if (apiV1SendPositionTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1SendPositionTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1SendPositionTradeLockerPostAccountStatus>
    apiV1SendPositionTradeLockerPostAccountStatusListFromJson(
  List? apiV1SendPositionTradeLockerPostAccountStatus, [
  List<enums.ApiV1SendPositionTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPositionTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1SendPositionTradeLockerPostAccountStatus
      .map((e) =>
          apiV1SendPositionTradeLockerPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1SendPositionTradeLockerPostAccountStatus>?
    apiV1SendPositionTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1SendPositionTradeLockerPostAccountStatus, [
  List<enums.ApiV1SendPositionTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPositionTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1SendPositionTradeLockerPostAccountStatus
      .map((e) =>
          apiV1SendPositionTradeLockerPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrdersTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1GetOrdersTradeLockerPostAccountStatus?
        apiV1GetOrdersTradeLockerPostAccountStatus) {
  return apiV1GetOrdersTradeLockerPostAccountStatus?.value;
}

int? apiV1GetOrdersTradeLockerPostAccountStatusToJson(
    enums.ApiV1GetOrdersTradeLockerPostAccountStatus
        apiV1GetOrdersTradeLockerPostAccountStatus) {
  return apiV1GetOrdersTradeLockerPostAccountStatus.value;
}

enums.ApiV1GetOrdersTradeLockerPostAccountStatus
    apiV1GetOrdersTradeLockerPostAccountStatusFromJson(
  Object? apiV1GetOrdersTradeLockerPostAccountStatus, [
  enums.ApiV1GetOrdersTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrdersTradeLockerPostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetOrdersTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetOrdersTradeLockerPostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetOrdersTradeLockerPostAccountStatus?
    apiV1GetOrdersTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1GetOrdersTradeLockerPostAccountStatus, [
  enums.ApiV1GetOrdersTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrdersTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrdersTradeLockerPostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetOrdersTradeLockerPostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrdersTradeLockerPostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrdersTradeLockerPostAccountStatus>?
        apiV1GetOrdersTradeLockerPostAccountStatus) {
  return apiV1GetOrdersTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetOrdersTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1GetOrdersTradeLockerPostAccountStatus>?
        apiV1GetOrdersTradeLockerPostAccountStatus) {
  if (apiV1GetOrdersTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrdersTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetOrdersTradeLockerPostAccountStatus>
    apiV1GetOrdersTradeLockerPostAccountStatusListFromJson(
  List? apiV1GetOrdersTradeLockerPostAccountStatus, [
  List<enums.ApiV1GetOrdersTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrdersTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrdersTradeLockerPostAccountStatus
      .map((e) =>
          apiV1GetOrdersTradeLockerPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetOrdersTradeLockerPostAccountStatus>?
    apiV1GetOrdersTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1GetOrdersTradeLockerPostAccountStatus, [
  List<enums.ApiV1GetOrdersTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrdersTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrdersTradeLockerPostAccountStatus
      .map((e) =>
          apiV1GetOrdersTradeLockerPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrderHistoryTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus?
        apiV1GetOrderHistoryTradeLockerPostAccountStatus) {
  return apiV1GetOrderHistoryTradeLockerPostAccountStatus?.value;
}

int? apiV1GetOrderHistoryTradeLockerPostAccountStatusToJson(
    enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus
        apiV1GetOrderHistoryTradeLockerPostAccountStatus) {
  return apiV1GetOrderHistoryTradeLockerPostAccountStatus.value;
}

enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus
    apiV1GetOrderHistoryTradeLockerPostAccountStatusFromJson(
  Object? apiV1GetOrderHistoryTradeLockerPostAccountStatus, [
  enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetOrderHistoryTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus?
    apiV1GetOrderHistoryTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1GetOrderHistoryTradeLockerPostAccountStatus, [
  enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrderHistoryTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetOrderHistoryTradeLockerPostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrderHistoryTradeLockerPostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus>?
        apiV1GetOrderHistoryTradeLockerPostAccountStatus) {
  return apiV1GetOrderHistoryTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetOrderHistoryTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus>?
        apiV1GetOrderHistoryTradeLockerPostAccountStatus) {
  if (apiV1GetOrderHistoryTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrderHistoryTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus>
    apiV1GetOrderHistoryTradeLockerPostAccountStatusListFromJson(
  List? apiV1GetOrderHistoryTradeLockerPostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrderHistoryTradeLockerPostAccountStatus
      .map((e) => apiV1GetOrderHistoryTradeLockerPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus>?
    apiV1GetOrderHistoryTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1GetOrderHistoryTradeLockerPostAccountStatus, [
  List<enums.ApiV1GetOrderHistoryTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrderHistoryTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrderHistoryTradeLockerPostAccountStatus
      .map((e) => apiV1GetOrderHistoryTradeLockerPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1ModifyPositionTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1ModifyPositionTradeLockerPostAccountStatus?
        apiV1ModifyPositionTradeLockerPostAccountStatus) {
  return apiV1ModifyPositionTradeLockerPostAccountStatus?.value;
}

int? apiV1ModifyPositionTradeLockerPostAccountStatusToJson(
    enums.ApiV1ModifyPositionTradeLockerPostAccountStatus
        apiV1ModifyPositionTradeLockerPostAccountStatus) {
  return apiV1ModifyPositionTradeLockerPostAccountStatus.value;
}

enums.ApiV1ModifyPositionTradeLockerPostAccountStatus
    apiV1ModifyPositionTradeLockerPostAccountStatusFromJson(
  Object? apiV1ModifyPositionTradeLockerPostAccountStatus, [
  enums.ApiV1ModifyPositionTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyPositionTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPositionTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyPositionTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ModifyPositionTradeLockerPostAccountStatus?
    apiV1ModifyPositionTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1ModifyPositionTradeLockerPostAccountStatus, [
  enums.ApiV1ModifyPositionTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyPositionTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyPositionTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPositionTradeLockerPostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyPositionTradeLockerPostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyPositionTradeLockerPostAccountStatus>?
        apiV1ModifyPositionTradeLockerPostAccountStatus) {
  return apiV1ModifyPositionTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ModifyPositionTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1ModifyPositionTradeLockerPostAccountStatus>?
        apiV1ModifyPositionTradeLockerPostAccountStatus) {
  if (apiV1ModifyPositionTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyPositionTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ModifyPositionTradeLockerPostAccountStatus>
    apiV1ModifyPositionTradeLockerPostAccountStatusListFromJson(
  List? apiV1ModifyPositionTradeLockerPostAccountStatus, [
  List<enums.ApiV1ModifyPositionTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPositionTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyPositionTradeLockerPostAccountStatus
      .map((e) =>
          apiV1ModifyPositionTradeLockerPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ModifyPositionTradeLockerPostAccountStatus>?
    apiV1ModifyPositionTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1ModifyPositionTradeLockerPostAccountStatus, [
  List<enums.ApiV1ModifyPositionTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPositionTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyPositionTradeLockerPostAccountStatus
      .map((e) =>
          apiV1ModifyPositionTradeLockerPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ClosePositionTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1ClosePositionTradeLockerPostAccountStatus?
        apiV1ClosePositionTradeLockerPostAccountStatus) {
  return apiV1ClosePositionTradeLockerPostAccountStatus?.value;
}

int? apiV1ClosePositionTradeLockerPostAccountStatusToJson(
    enums.ApiV1ClosePositionTradeLockerPostAccountStatus
        apiV1ClosePositionTradeLockerPostAccountStatus) {
  return apiV1ClosePositionTradeLockerPostAccountStatus.value;
}

enums.ApiV1ClosePositionTradeLockerPostAccountStatus
    apiV1ClosePositionTradeLockerPostAccountStatusFromJson(
  Object? apiV1ClosePositionTradeLockerPostAccountStatus, [
  enums.ApiV1ClosePositionTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ClosePositionTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePositionTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ClosePositionTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ClosePositionTradeLockerPostAccountStatus?
    apiV1ClosePositionTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1ClosePositionTradeLockerPostAccountStatus, [
  enums.ApiV1ClosePositionTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1ClosePositionTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ClosePositionTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePositionTradeLockerPostAccountStatus) ??
      defaultValue;
}

String apiV1ClosePositionTradeLockerPostAccountStatusExplodedListToJson(
    List<enums.ApiV1ClosePositionTradeLockerPostAccountStatus>?
        apiV1ClosePositionTradeLockerPostAccountStatus) {
  return apiV1ClosePositionTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ClosePositionTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1ClosePositionTradeLockerPostAccountStatus>?
        apiV1ClosePositionTradeLockerPostAccountStatus) {
  if (apiV1ClosePositionTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1ClosePositionTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ClosePositionTradeLockerPostAccountStatus>
    apiV1ClosePositionTradeLockerPostAccountStatusListFromJson(
  List? apiV1ClosePositionTradeLockerPostAccountStatus, [
  List<enums.ApiV1ClosePositionTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePositionTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ClosePositionTradeLockerPostAccountStatus
      .map((e) =>
          apiV1ClosePositionTradeLockerPostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ClosePositionTradeLockerPostAccountStatus>?
    apiV1ClosePositionTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1ClosePositionTradeLockerPostAccountStatus, [
  List<enums.ApiV1ClosePositionTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePositionTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ClosePositionTradeLockerPostAccountStatus
      .map((e) =>
          apiV1ClosePositionTradeLockerPostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1PartialCloseTradeLockerPostionPostAccountStatusNullableToJson(
    enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus?
        apiV1PartialCloseTradeLockerPostionPostAccountStatus) {
  return apiV1PartialCloseTradeLockerPostionPostAccountStatus?.value;
}

int? apiV1PartialCloseTradeLockerPostionPostAccountStatusToJson(
    enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus
        apiV1PartialCloseTradeLockerPostionPostAccountStatus) {
  return apiV1PartialCloseTradeLockerPostionPostAccountStatus.value;
}

enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus
    apiV1PartialCloseTradeLockerPostionPostAccountStatusFromJson(
  Object? apiV1PartialCloseTradeLockerPostionPostAccountStatus, [
  enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1PartialCloseTradeLockerPostionPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus?
    apiV1PartialCloseTradeLockerPostionPostAccountStatusNullableFromJson(
  Object? apiV1PartialCloseTradeLockerPostionPostAccountStatus, [
  enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus? defaultValue,
]) {
  if (apiV1PartialCloseTradeLockerPostionPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1PartialCloseTradeLockerPostionPostAccountStatus) ??
      defaultValue;
}

String apiV1PartialCloseTradeLockerPostionPostAccountStatusExplodedListToJson(
    List<enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus>?
        apiV1PartialCloseTradeLockerPostionPostAccountStatus) {
  return apiV1PartialCloseTradeLockerPostionPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1PartialCloseTradeLockerPostionPostAccountStatusListToJson(
    List<enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus>?
        apiV1PartialCloseTradeLockerPostionPostAccountStatus) {
  if (apiV1PartialCloseTradeLockerPostionPostAccountStatus == null) {
    return [];
  }

  return apiV1PartialCloseTradeLockerPostionPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus>
    apiV1PartialCloseTradeLockerPostionPostAccountStatusListFromJson(
  List? apiV1PartialCloseTradeLockerPostionPostAccountStatus, [
  List<enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus>?
      defaultValue,
]) {
  if (apiV1PartialCloseTradeLockerPostionPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1PartialCloseTradeLockerPostionPostAccountStatus
      .map((e) => apiV1PartialCloseTradeLockerPostionPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus>?
    apiV1PartialCloseTradeLockerPostionPostAccountStatusNullableListFromJson(
  List? apiV1PartialCloseTradeLockerPostionPostAccountStatus, [
  List<enums.ApiV1PartialCloseTradeLockerPostionPostAccountStatus>?
      defaultValue,
]) {
  if (apiV1PartialCloseTradeLockerPostionPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1PartialCloseTradeLockerPostionPostAccountStatus
      .map((e) => apiV1PartialCloseTradeLockerPostionPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1CloseAllOrdersForTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus?
        apiV1CloseAllOrdersForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrdersForTradeLockerPostAccountStatus?.value;
}

int? apiV1CloseAllOrdersForTradeLockerPostAccountStatusToJson(
    enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus
        apiV1CloseAllOrdersForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrdersForTradeLockerPostAccountStatus.value;
}

enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus
    apiV1CloseAllOrdersForTradeLockerPostAccountStatusFromJson(
  Object? apiV1CloseAllOrdersForTradeLockerPostAccountStatus, [
  enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrdersForTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus?
    apiV1CloseAllOrdersForTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrdersForTradeLockerPostAccountStatus, [
  enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrdersForTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrdersForTradeLockerPostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrdersForTradeLockerPostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus>?
        apiV1CloseAllOrdersForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrdersForTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrdersForTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus>?
        apiV1CloseAllOrdersForTradeLockerPostAccountStatus) {
  if (apiV1CloseAllOrdersForTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrdersForTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus>
    apiV1CloseAllOrdersForTradeLockerPostAccountStatusListFromJson(
  List? apiV1CloseAllOrdersForTradeLockerPostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrdersForTradeLockerPostAccountStatus
      .map((e) => apiV1CloseAllOrdersForTradeLockerPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus>?
    apiV1CloseAllOrdersForTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrdersForTradeLockerPostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrdersForTradeLockerPostAccountStatus
      .map((e) => apiV1CloseAllOrdersForTradeLockerPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus?
        apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus
        apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus
    apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus?
    apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus) ??
      defaultValue;
}

String
    apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatusExplodedListToJson(
        List<enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus>?
            apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus>?
        apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus) {
  if (apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus>
    apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatusFromJson(
              e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus>?
    apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySymbolForTradeLockerPostAccountStatusFromJson(
              e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySellForTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus?
        apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySellForTradeLockerPostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus
        apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus
    apiV1CloseAllOrderBySellForTradeLockerPostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus?
    apiV1CloseAllOrderBySellForTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus) ??
      defaultValue;
}

String
    apiV1CloseAllOrderBySellForTradeLockerPostAccountStatusExplodedListToJson(
        List<enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus>?
            apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySellForTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus>?
        apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus) {
  if (apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus>
    apiV1CloseAllOrderBySellForTradeLockerPostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySellForTradeLockerPostAccountStatusFromJson(
              e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus>?
    apiV1CloseAllOrderBySellForTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellForTradeLockerPostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySellForTradeLockerPostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySellForTradeLockerPostAccountStatusFromJson(
              e.toString()))
      .toList();
}

int? apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus?
        apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus?.value;
}

int? apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatusToJson(
    enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus
        apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus.value;
}

enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus
    apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatusFromJson(
  Object? apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus?
    apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus>?
        apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus) {
  return apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus>?
        apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus) {
  if (apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus>
    apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatusListFromJson(
  List? apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatusFromJson(
              e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus>?
    apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderByBuyForTradeLockerPostAccountStatusFromJson(
              e.toString()))
      .toList();
}

int? apiV1SendPendingOrderTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus?
        apiV1SendPendingOrderTradeLockerPostAccountStatus) {
  return apiV1SendPendingOrderTradeLockerPostAccountStatus?.value;
}

int? apiV1SendPendingOrderTradeLockerPostAccountStatusToJson(
    enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus
        apiV1SendPendingOrderTradeLockerPostAccountStatus) {
  return apiV1SendPendingOrderTradeLockerPostAccountStatus.value;
}

enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus
    apiV1SendPendingOrderTradeLockerPostAccountStatusFromJson(
  Object? apiV1SendPendingOrderTradeLockerPostAccountStatus, [
  enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1SendPendingOrderTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus?
    apiV1SendPendingOrderTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1SendPendingOrderTradeLockerPostAccountStatus, [
  enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1SendPendingOrderTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1SendPendingOrderTradeLockerPostAccountStatus) ??
      defaultValue;
}

String apiV1SendPendingOrderTradeLockerPostAccountStatusExplodedListToJson(
    List<enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus>?
        apiV1SendPendingOrderTradeLockerPostAccountStatus) {
  return apiV1SendPendingOrderTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1SendPendingOrderTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus>?
        apiV1SendPendingOrderTradeLockerPostAccountStatus) {
  if (apiV1SendPendingOrderTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1SendPendingOrderTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus>
    apiV1SendPendingOrderTradeLockerPostAccountStatusListFromJson(
  List? apiV1SendPendingOrderTradeLockerPostAccountStatus, [
  List<enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPendingOrderTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1SendPendingOrderTradeLockerPostAccountStatus
      .map((e) => apiV1SendPendingOrderTradeLockerPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus>?
    apiV1SendPendingOrderTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1SendPendingOrderTradeLockerPostAccountStatus, [
  List<enums.ApiV1SendPendingOrderTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPendingOrderTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1SendPendingOrderTradeLockerPostAccountStatus
      .map((e) => apiV1SendPendingOrderTradeLockerPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1ModifyPendingOrderTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus?
        apiV1ModifyPendingOrderTradeLockerPostAccountStatus) {
  return apiV1ModifyPendingOrderTradeLockerPostAccountStatus?.value;
}

int? apiV1ModifyPendingOrderTradeLockerPostAccountStatusToJson(
    enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus
        apiV1ModifyPendingOrderTradeLockerPostAccountStatus) {
  return apiV1ModifyPendingOrderTradeLockerPostAccountStatus.value;
}

enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus
    apiV1ModifyPendingOrderTradeLockerPostAccountStatusFromJson(
  Object? apiV1ModifyPendingOrderTradeLockerPostAccountStatus, [
  enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPendingOrderTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus?
    apiV1ModifyPendingOrderTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1ModifyPendingOrderTradeLockerPostAccountStatus, [
  enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyPendingOrderTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPendingOrderTradeLockerPostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyPendingOrderTradeLockerPostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus>?
        apiV1ModifyPendingOrderTradeLockerPostAccountStatus) {
  return apiV1ModifyPendingOrderTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ModifyPendingOrderTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus>?
        apiV1ModifyPendingOrderTradeLockerPostAccountStatus) {
  if (apiV1ModifyPendingOrderTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyPendingOrderTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus>
    apiV1ModifyPendingOrderTradeLockerPostAccountStatusListFromJson(
  List? apiV1ModifyPendingOrderTradeLockerPostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyPendingOrderTradeLockerPostAccountStatus
      .map((e) => apiV1ModifyPendingOrderTradeLockerPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus>?
    apiV1ModifyPendingOrderTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1ModifyPendingOrderTradeLockerPostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyPendingOrderTradeLockerPostAccountStatus
      .map((e) => apiV1ModifyPendingOrderTradeLockerPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1ClosePendingOrderTradeLockerPostAccountStatusNullableToJson(
    enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus?
        apiV1ClosePendingOrderTradeLockerPostAccountStatus) {
  return apiV1ClosePendingOrderTradeLockerPostAccountStatus?.value;
}

int? apiV1ClosePendingOrderTradeLockerPostAccountStatusToJson(
    enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus
        apiV1ClosePendingOrderTradeLockerPostAccountStatus) {
  return apiV1ClosePendingOrderTradeLockerPostAccountStatus.value;
}

enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus
    apiV1ClosePendingOrderTradeLockerPostAccountStatusFromJson(
  Object? apiV1ClosePendingOrderTradeLockerPostAccountStatus, [
  enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePendingOrderTradeLockerPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus?
    apiV1ClosePendingOrderTradeLockerPostAccountStatusNullableFromJson(
  Object? apiV1ClosePendingOrderTradeLockerPostAccountStatus, [
  enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus? defaultValue,
]) {
  if (apiV1ClosePendingOrderTradeLockerPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePendingOrderTradeLockerPostAccountStatus) ??
      defaultValue;
}

String apiV1ClosePendingOrderTradeLockerPostAccountStatusExplodedListToJson(
    List<enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus>?
        apiV1ClosePendingOrderTradeLockerPostAccountStatus) {
  return apiV1ClosePendingOrderTradeLockerPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ClosePendingOrderTradeLockerPostAccountStatusListToJson(
    List<enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus>?
        apiV1ClosePendingOrderTradeLockerPostAccountStatus) {
  if (apiV1ClosePendingOrderTradeLockerPostAccountStatus == null) {
    return [];
  }

  return apiV1ClosePendingOrderTradeLockerPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus>
    apiV1ClosePendingOrderTradeLockerPostAccountStatusListFromJson(
  List? apiV1ClosePendingOrderTradeLockerPostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderTradeLockerPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ClosePendingOrderTradeLockerPostAccountStatus
      .map((e) => apiV1ClosePendingOrderTradeLockerPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus>?
    apiV1ClosePendingOrderTradeLockerPostAccountStatusNullableListFromJson(
  List? apiV1ClosePendingOrderTradeLockerPostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderTradeLockerPostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderTradeLockerPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ClosePendingOrderTradeLockerPostAccountStatus
      .map((e) => apiV1ClosePendingOrderTradeLockerPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1TradeLockerUpdateRiskPostRiskTypeNullableToJson(
    enums.ApiV1TradeLockerUpdateRiskPostRiskType?
        apiV1TradeLockerUpdateRiskPostRiskType) {
  return apiV1TradeLockerUpdateRiskPostRiskType?.value;
}

int? apiV1TradeLockerUpdateRiskPostRiskTypeToJson(
    enums.ApiV1TradeLockerUpdateRiskPostRiskType
        apiV1TradeLockerUpdateRiskPostRiskType) {
  return apiV1TradeLockerUpdateRiskPostRiskType.value;
}

enums.ApiV1TradeLockerUpdateRiskPostRiskType
    apiV1TradeLockerUpdateRiskPostRiskTypeFromJson(
  Object? apiV1TradeLockerUpdateRiskPostRiskType, [
  enums.ApiV1TradeLockerUpdateRiskPostRiskType? defaultValue,
]) {
  return enums.ApiV1TradeLockerUpdateRiskPostRiskType.values.firstWhereOrNull(
          (e) => e.value == apiV1TradeLockerUpdateRiskPostRiskType) ??
      defaultValue ??
      enums.ApiV1TradeLockerUpdateRiskPostRiskType.swaggerGeneratedUnknown;
}

enums.ApiV1TradeLockerUpdateRiskPostRiskType?
    apiV1TradeLockerUpdateRiskPostRiskTypeNullableFromJson(
  Object? apiV1TradeLockerUpdateRiskPostRiskType, [
  enums.ApiV1TradeLockerUpdateRiskPostRiskType? defaultValue,
]) {
  if (apiV1TradeLockerUpdateRiskPostRiskType == null) {
    return null;
  }
  return enums.ApiV1TradeLockerUpdateRiskPostRiskType.values.firstWhereOrNull(
          (e) => e.value == apiV1TradeLockerUpdateRiskPostRiskType) ??
      defaultValue;
}

String apiV1TradeLockerUpdateRiskPostRiskTypeExplodedListToJson(
    List<enums.ApiV1TradeLockerUpdateRiskPostRiskType>?
        apiV1TradeLockerUpdateRiskPostRiskType) {
  return apiV1TradeLockerUpdateRiskPostRiskType
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1TradeLockerUpdateRiskPostRiskTypeListToJson(
    List<enums.ApiV1TradeLockerUpdateRiskPostRiskType>?
        apiV1TradeLockerUpdateRiskPostRiskType) {
  if (apiV1TradeLockerUpdateRiskPostRiskType == null) {
    return [];
  }

  return apiV1TradeLockerUpdateRiskPostRiskType.map((e) => e.value!).toList();
}

List<enums.ApiV1TradeLockerUpdateRiskPostRiskType>
    apiV1TradeLockerUpdateRiskPostRiskTypeListFromJson(
  List? apiV1TradeLockerUpdateRiskPostRiskType, [
  List<enums.ApiV1TradeLockerUpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1TradeLockerUpdateRiskPostRiskType == null) {
    return defaultValue ?? [];
  }

  return apiV1TradeLockerUpdateRiskPostRiskType
      .map((e) => apiV1TradeLockerUpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1TradeLockerUpdateRiskPostRiskType>?
    apiV1TradeLockerUpdateRiskPostRiskTypeNullableListFromJson(
  List? apiV1TradeLockerUpdateRiskPostRiskType, [
  List<enums.ApiV1TradeLockerUpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1TradeLockerUpdateRiskPostRiskType == null) {
    return defaultValue;
  }

  return apiV1TradeLockerUpdateRiskPostRiskType
      .map((e) => apiV1TradeLockerUpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

int? apiV1TradeLockerUpdateStopsLimitsPostScalperModeNullableToJson(
    enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode?
        apiV1TradeLockerUpdateStopsLimitsPostScalperMode) {
  return apiV1TradeLockerUpdateStopsLimitsPostScalperMode?.value;
}

int? apiV1TradeLockerUpdateStopsLimitsPostScalperModeToJson(
    enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode
        apiV1TradeLockerUpdateStopsLimitsPostScalperMode) {
  return apiV1TradeLockerUpdateStopsLimitsPostScalperMode.value;
}

enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode
    apiV1TradeLockerUpdateStopsLimitsPostScalperModeFromJson(
  Object? apiV1TradeLockerUpdateStopsLimitsPostScalperMode, [
  enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  return enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode.values
          .firstWhereOrNull((e) =>
              e.value == apiV1TradeLockerUpdateStopsLimitsPostScalperMode) ??
      defaultValue ??
      enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode
          .swaggerGeneratedUnknown;
}

enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode?
    apiV1TradeLockerUpdateStopsLimitsPostScalperModeNullableFromJson(
  Object? apiV1TradeLockerUpdateStopsLimitsPostScalperMode, [
  enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  if (apiV1TradeLockerUpdateStopsLimitsPostScalperMode == null) {
    return null;
  }
  return enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode.values
          .firstWhereOrNull((e) =>
              e.value == apiV1TradeLockerUpdateStopsLimitsPostScalperMode) ??
      defaultValue;
}

String apiV1TradeLockerUpdateStopsLimitsPostScalperModeExplodedListToJson(
    List<enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode>?
        apiV1TradeLockerUpdateStopsLimitsPostScalperMode) {
  return apiV1TradeLockerUpdateStopsLimitsPostScalperMode
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1TradeLockerUpdateStopsLimitsPostScalperModeListToJson(
    List<enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode>?
        apiV1TradeLockerUpdateStopsLimitsPostScalperMode) {
  if (apiV1TradeLockerUpdateStopsLimitsPostScalperMode == null) {
    return [];
  }

  return apiV1TradeLockerUpdateStopsLimitsPostScalperMode
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode>
    apiV1TradeLockerUpdateStopsLimitsPostScalperModeListFromJson(
  List? apiV1TradeLockerUpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1TradeLockerUpdateStopsLimitsPostScalperMode == null) {
    return defaultValue ?? [];
  }

  return apiV1TradeLockerUpdateStopsLimitsPostScalperMode
      .map((e) => apiV1TradeLockerUpdateStopsLimitsPostScalperModeFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode>?
    apiV1TradeLockerUpdateStopsLimitsPostScalperModeNullableListFromJson(
  List? apiV1TradeLockerUpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1TradeLockerUpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1TradeLockerUpdateStopsLimitsPostScalperMode == null) {
    return defaultValue;
  }

  return apiV1TradeLockerUpdateStopsLimitsPostScalperMode
      .map((e) => apiV1TradeLockerUpdateStopsLimitsPostScalperModeFromJson(
          e.toString()))
      .toList();
}

int? apiV1TradeLockerUpdateStopsLimitsPostOrderFilterNullableToJson(
    enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter?
        apiV1TradeLockerUpdateStopsLimitsPostOrderFilter) {
  return apiV1TradeLockerUpdateStopsLimitsPostOrderFilter?.value;
}

int? apiV1TradeLockerUpdateStopsLimitsPostOrderFilterToJson(
    enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter
        apiV1TradeLockerUpdateStopsLimitsPostOrderFilter) {
  return apiV1TradeLockerUpdateStopsLimitsPostOrderFilter.value;
}

enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter
    apiV1TradeLockerUpdateStopsLimitsPostOrderFilterFromJson(
  Object? apiV1TradeLockerUpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  return enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter.values
          .firstWhereOrNull((e) =>
              e.value == apiV1TradeLockerUpdateStopsLimitsPostOrderFilter) ??
      defaultValue ??
      enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter
          .swaggerGeneratedUnknown;
}

enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter?
    apiV1TradeLockerUpdateStopsLimitsPostOrderFilterNullableFromJson(
  Object? apiV1TradeLockerUpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  if (apiV1TradeLockerUpdateStopsLimitsPostOrderFilter == null) {
    return null;
  }
  return enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter.values
          .firstWhereOrNull((e) =>
              e.value == apiV1TradeLockerUpdateStopsLimitsPostOrderFilter) ??
      defaultValue;
}

String apiV1TradeLockerUpdateStopsLimitsPostOrderFilterExplodedListToJson(
    List<enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter>?
        apiV1TradeLockerUpdateStopsLimitsPostOrderFilter) {
  return apiV1TradeLockerUpdateStopsLimitsPostOrderFilter
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1TradeLockerUpdateStopsLimitsPostOrderFilterListToJson(
    List<enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter>?
        apiV1TradeLockerUpdateStopsLimitsPostOrderFilter) {
  if (apiV1TradeLockerUpdateStopsLimitsPostOrderFilter == null) {
    return [];
  }

  return apiV1TradeLockerUpdateStopsLimitsPostOrderFilter
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter>
    apiV1TradeLockerUpdateStopsLimitsPostOrderFilterListFromJson(
  List? apiV1TradeLockerUpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1TradeLockerUpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue ?? [];
  }

  return apiV1TradeLockerUpdateStopsLimitsPostOrderFilter
      .map((e) => apiV1TradeLockerUpdateStopsLimitsPostOrderFilterFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter>?
    apiV1TradeLockerUpdateStopsLimitsPostOrderFilterNullableListFromJson(
  List? apiV1TradeLockerUpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1TradeLockerUpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1TradeLockerUpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue;
  }

  return apiV1TradeLockerUpdateStopsLimitsPostOrderFilter
      .map((e) => apiV1TradeLockerUpdateStopsLimitsPostOrderFilterFromJson(
          e.toString()))
      .toList();
}

int? apiV1GetAllSymbolTradeLockerUserIdGetAccountStatusNullableToJson(
    enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus?
        apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus) {
  return apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus?.value;
}

int? apiV1GetAllSymbolTradeLockerUserIdGetAccountStatusToJson(
    enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus
        apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus) {
  return apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus.value;
}

enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus
    apiV1GetAllSymbolTradeLockerUserIdGetAccountStatusFromJson(
  Object? apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus, [
  enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus?
    apiV1GetAllSymbolTradeLockerUserIdGetAccountStatusNullableFromJson(
  Object? apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus, [
  enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus? defaultValue,
]) {
  if (apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus) ??
      defaultValue;
}

String apiV1GetAllSymbolTradeLockerUserIdGetAccountStatusExplodedListToJson(
    List<enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus>?
        apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus) {
  return apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetAllSymbolTradeLockerUserIdGetAccountStatusListToJson(
    List<enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus>?
        apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus) {
  if (apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus == null) {
    return [];
  }

  return apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus>
    apiV1GetAllSymbolTradeLockerUserIdGetAccountStatusListFromJson(
  List? apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus, [
  List<enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus>? defaultValue,
]) {
  if (apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus
      .map((e) => apiV1GetAllSymbolTradeLockerUserIdGetAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus>?
    apiV1GetAllSymbolTradeLockerUserIdGetAccountStatusNullableListFromJson(
  List? apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus, [
  List<enums.ApiV1GetAllSymbolTradeLockerUserIdGetAccountStatus>? defaultValue,
]) {
  if (apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetAllSymbolTradeLockerUserIdGetAccountStatus
      .map((e) => apiV1GetAllSymbolTradeLockerUserIdGetAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1SendPositionMatchTradePostAccountStatusNullableToJson(
    enums.ApiV1SendPositionMatchTradePostAccountStatus?
        apiV1SendPositionMatchTradePostAccountStatus) {
  return apiV1SendPositionMatchTradePostAccountStatus?.value;
}

int? apiV1SendPositionMatchTradePostAccountStatusToJson(
    enums.ApiV1SendPositionMatchTradePostAccountStatus
        apiV1SendPositionMatchTradePostAccountStatus) {
  return apiV1SendPositionMatchTradePostAccountStatus.value;
}

enums.ApiV1SendPositionMatchTradePostAccountStatus
    apiV1SendPositionMatchTradePostAccountStatusFromJson(
  Object? apiV1SendPositionMatchTradePostAccountStatus, [
  enums.ApiV1SendPositionMatchTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1SendPositionMatchTradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1SendPositionMatchTradePostAccountStatus) ??
      defaultValue ??
      enums
          .ApiV1SendPositionMatchTradePostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1SendPositionMatchTradePostAccountStatus?
    apiV1SendPositionMatchTradePostAccountStatusNullableFromJson(
  Object? apiV1SendPositionMatchTradePostAccountStatus, [
  enums.ApiV1SendPositionMatchTradePostAccountStatus? defaultValue,
]) {
  if (apiV1SendPositionMatchTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1SendPositionMatchTradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1SendPositionMatchTradePostAccountStatus) ??
      defaultValue;
}

String apiV1SendPositionMatchTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1SendPositionMatchTradePostAccountStatus>?
        apiV1SendPositionMatchTradePostAccountStatus) {
  return apiV1SendPositionMatchTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1SendPositionMatchTradePostAccountStatusListToJson(
    List<enums.ApiV1SendPositionMatchTradePostAccountStatus>?
        apiV1SendPositionMatchTradePostAccountStatus) {
  if (apiV1SendPositionMatchTradePostAccountStatus == null) {
    return [];
  }

  return apiV1SendPositionMatchTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1SendPositionMatchTradePostAccountStatus>
    apiV1SendPositionMatchTradePostAccountStatusListFromJson(
  List? apiV1SendPositionMatchTradePostAccountStatus, [
  List<enums.ApiV1SendPositionMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPositionMatchTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1SendPositionMatchTradePostAccountStatus
      .map((e) =>
          apiV1SendPositionMatchTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1SendPositionMatchTradePostAccountStatus>?
    apiV1SendPositionMatchTradePostAccountStatusNullableListFromJson(
  List? apiV1SendPositionMatchTradePostAccountStatus, [
  List<enums.ApiV1SendPositionMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPositionMatchTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1SendPositionMatchTradePostAccountStatus
      .map((e) =>
          apiV1SendPositionMatchTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1GetOrdersMatchTradePostAccountStatusNullableToJson(
    enums.ApiV1GetOrdersMatchTradePostAccountStatus?
        apiV1GetOrdersMatchTradePostAccountStatus) {
  return apiV1GetOrdersMatchTradePostAccountStatus?.value;
}

int? apiV1GetOrdersMatchTradePostAccountStatusToJson(
    enums.ApiV1GetOrdersMatchTradePostAccountStatus
        apiV1GetOrdersMatchTradePostAccountStatus) {
  return apiV1GetOrdersMatchTradePostAccountStatus.value;
}

enums.ApiV1GetOrdersMatchTradePostAccountStatus
    apiV1GetOrdersMatchTradePostAccountStatusFromJson(
  Object? apiV1GetOrdersMatchTradePostAccountStatus, [
  enums.ApiV1GetOrdersMatchTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetOrdersMatchTradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetOrdersMatchTradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetOrdersMatchTradePostAccountStatus.swaggerGeneratedUnknown;
}

enums.ApiV1GetOrdersMatchTradePostAccountStatus?
    apiV1GetOrdersMatchTradePostAccountStatusNullableFromJson(
  Object? apiV1GetOrdersMatchTradePostAccountStatus, [
  enums.ApiV1GetOrdersMatchTradePostAccountStatus? defaultValue,
]) {
  if (apiV1GetOrdersMatchTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetOrdersMatchTradePostAccountStatus.values
          .firstWhereOrNull(
              (e) => e.value == apiV1GetOrdersMatchTradePostAccountStatus) ??
      defaultValue;
}

String apiV1GetOrdersMatchTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1GetOrdersMatchTradePostAccountStatus>?
        apiV1GetOrdersMatchTradePostAccountStatus) {
  return apiV1GetOrdersMatchTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetOrdersMatchTradePostAccountStatusListToJson(
    List<enums.ApiV1GetOrdersMatchTradePostAccountStatus>?
        apiV1GetOrdersMatchTradePostAccountStatus) {
  if (apiV1GetOrdersMatchTradePostAccountStatus == null) {
    return [];
  }

  return apiV1GetOrdersMatchTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetOrdersMatchTradePostAccountStatus>
    apiV1GetOrdersMatchTradePostAccountStatusListFromJson(
  List? apiV1GetOrdersMatchTradePostAccountStatus, [
  List<enums.ApiV1GetOrdersMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrdersMatchTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetOrdersMatchTradePostAccountStatus
      .map((e) =>
          apiV1GetOrdersMatchTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1GetOrdersMatchTradePostAccountStatus>?
    apiV1GetOrdersMatchTradePostAccountStatusNullableListFromJson(
  List? apiV1GetOrdersMatchTradePostAccountStatus, [
  List<enums.ApiV1GetOrdersMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1GetOrdersMatchTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetOrdersMatchTradePostAccountStatus
      .map((e) =>
          apiV1GetOrdersMatchTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ModifyPositionMatchTradePostAccountStatusNullableToJson(
    enums.ApiV1ModifyPositionMatchTradePostAccountStatus?
        apiV1ModifyPositionMatchTradePostAccountStatus) {
  return apiV1ModifyPositionMatchTradePostAccountStatus?.value;
}

int? apiV1ModifyPositionMatchTradePostAccountStatusToJson(
    enums.ApiV1ModifyPositionMatchTradePostAccountStatus
        apiV1ModifyPositionMatchTradePostAccountStatus) {
  return apiV1ModifyPositionMatchTradePostAccountStatus.value;
}

enums.ApiV1ModifyPositionMatchTradePostAccountStatus
    apiV1ModifyPositionMatchTradePostAccountStatusFromJson(
  Object? apiV1ModifyPositionMatchTradePostAccountStatus, [
  enums.ApiV1ModifyPositionMatchTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyPositionMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPositionMatchTradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyPositionMatchTradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ModifyPositionMatchTradePostAccountStatus?
    apiV1ModifyPositionMatchTradePostAccountStatusNullableFromJson(
  Object? apiV1ModifyPositionMatchTradePostAccountStatus, [
  enums.ApiV1ModifyPositionMatchTradePostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyPositionMatchTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyPositionMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPositionMatchTradePostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyPositionMatchTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyPositionMatchTradePostAccountStatus>?
        apiV1ModifyPositionMatchTradePostAccountStatus) {
  return apiV1ModifyPositionMatchTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ModifyPositionMatchTradePostAccountStatusListToJson(
    List<enums.ApiV1ModifyPositionMatchTradePostAccountStatus>?
        apiV1ModifyPositionMatchTradePostAccountStatus) {
  if (apiV1ModifyPositionMatchTradePostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyPositionMatchTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ModifyPositionMatchTradePostAccountStatus>
    apiV1ModifyPositionMatchTradePostAccountStatusListFromJson(
  List? apiV1ModifyPositionMatchTradePostAccountStatus, [
  List<enums.ApiV1ModifyPositionMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPositionMatchTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyPositionMatchTradePostAccountStatus
      .map((e) =>
          apiV1ModifyPositionMatchTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ModifyPositionMatchTradePostAccountStatus>?
    apiV1ModifyPositionMatchTradePostAccountStatusNullableListFromJson(
  List? apiV1ModifyPositionMatchTradePostAccountStatus, [
  List<enums.ApiV1ModifyPositionMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPositionMatchTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyPositionMatchTradePostAccountStatus
      .map((e) =>
          apiV1ModifyPositionMatchTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1ClosePositionMatchTradePostAccountStatusNullableToJson(
    enums.ApiV1ClosePositionMatchTradePostAccountStatus?
        apiV1ClosePositionMatchTradePostAccountStatus) {
  return apiV1ClosePositionMatchTradePostAccountStatus?.value;
}

int? apiV1ClosePositionMatchTradePostAccountStatusToJson(
    enums.ApiV1ClosePositionMatchTradePostAccountStatus
        apiV1ClosePositionMatchTradePostAccountStatus) {
  return apiV1ClosePositionMatchTradePostAccountStatus.value;
}

enums.ApiV1ClosePositionMatchTradePostAccountStatus
    apiV1ClosePositionMatchTradePostAccountStatusFromJson(
  Object? apiV1ClosePositionMatchTradePostAccountStatus, [
  enums.ApiV1ClosePositionMatchTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ClosePositionMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePositionMatchTradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ClosePositionMatchTradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ClosePositionMatchTradePostAccountStatus?
    apiV1ClosePositionMatchTradePostAccountStatusNullableFromJson(
  Object? apiV1ClosePositionMatchTradePostAccountStatus, [
  enums.ApiV1ClosePositionMatchTradePostAccountStatus? defaultValue,
]) {
  if (apiV1ClosePositionMatchTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ClosePositionMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePositionMatchTradePostAccountStatus) ??
      defaultValue;
}

String apiV1ClosePositionMatchTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1ClosePositionMatchTradePostAccountStatus>?
        apiV1ClosePositionMatchTradePostAccountStatus) {
  return apiV1ClosePositionMatchTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ClosePositionMatchTradePostAccountStatusListToJson(
    List<enums.ApiV1ClosePositionMatchTradePostAccountStatus>?
        apiV1ClosePositionMatchTradePostAccountStatus) {
  if (apiV1ClosePositionMatchTradePostAccountStatus == null) {
    return [];
  }

  return apiV1ClosePositionMatchTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ClosePositionMatchTradePostAccountStatus>
    apiV1ClosePositionMatchTradePostAccountStatusListFromJson(
  List? apiV1ClosePositionMatchTradePostAccountStatus, [
  List<enums.ApiV1ClosePositionMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePositionMatchTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ClosePositionMatchTradePostAccountStatus
      .map((e) =>
          apiV1ClosePositionMatchTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1ClosePositionMatchTradePostAccountStatus>?
    apiV1ClosePositionMatchTradePostAccountStatusNullableListFromJson(
  List? apiV1ClosePositionMatchTradePostAccountStatus, [
  List<enums.ApiV1ClosePositionMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePositionMatchTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ClosePositionMatchTradePostAccountStatus
      .map((e) =>
          apiV1ClosePositionMatchTradePostAccountStatusFromJson(e.toString()))
      .toList();
}

int? apiV1PartialCloseMatchTradePostionPostAccountStatusNullableToJson(
    enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus?
        apiV1PartialCloseMatchTradePostionPostAccountStatus) {
  return apiV1PartialCloseMatchTradePostionPostAccountStatus?.value;
}

int? apiV1PartialCloseMatchTradePostionPostAccountStatusToJson(
    enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus
        apiV1PartialCloseMatchTradePostionPostAccountStatus) {
  return apiV1PartialCloseMatchTradePostionPostAccountStatus.value;
}

enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus
    apiV1PartialCloseMatchTradePostionPostAccountStatusFromJson(
  Object? apiV1PartialCloseMatchTradePostionPostAccountStatus, [
  enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus? defaultValue,
]) {
  return enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1PartialCloseMatchTradePostionPostAccountStatus) ??
      defaultValue ??
      enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus?
    apiV1PartialCloseMatchTradePostionPostAccountStatusNullableFromJson(
  Object? apiV1PartialCloseMatchTradePostionPostAccountStatus, [
  enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus? defaultValue,
]) {
  if (apiV1PartialCloseMatchTradePostionPostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1PartialCloseMatchTradePostionPostAccountStatus) ??
      defaultValue;
}

String apiV1PartialCloseMatchTradePostionPostAccountStatusExplodedListToJson(
    List<enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus>?
        apiV1PartialCloseMatchTradePostionPostAccountStatus) {
  return apiV1PartialCloseMatchTradePostionPostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1PartialCloseMatchTradePostionPostAccountStatusListToJson(
    List<enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus>?
        apiV1PartialCloseMatchTradePostionPostAccountStatus) {
  if (apiV1PartialCloseMatchTradePostionPostAccountStatus == null) {
    return [];
  }

  return apiV1PartialCloseMatchTradePostionPostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus>
    apiV1PartialCloseMatchTradePostionPostAccountStatusListFromJson(
  List? apiV1PartialCloseMatchTradePostionPostAccountStatus, [
  List<enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus>? defaultValue,
]) {
  if (apiV1PartialCloseMatchTradePostionPostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1PartialCloseMatchTradePostionPostAccountStatus
      .map((e) => apiV1PartialCloseMatchTradePostionPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus>?
    apiV1PartialCloseMatchTradePostionPostAccountStatusNullableListFromJson(
  List? apiV1PartialCloseMatchTradePostionPostAccountStatus, [
  List<enums.ApiV1PartialCloseMatchTradePostionPostAccountStatus>? defaultValue,
]) {
  if (apiV1PartialCloseMatchTradePostionPostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1PartialCloseMatchTradePostionPostAccountStatus
      .map((e) => apiV1PartialCloseMatchTradePostionPostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1CloseAllOrdersForMatchtradePostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus?
        apiV1CloseAllOrdersForMatchtradePostAccountStatus) {
  return apiV1CloseAllOrdersForMatchtradePostAccountStatus?.value;
}

int? apiV1CloseAllOrdersForMatchtradePostAccountStatusToJson(
    enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus
        apiV1CloseAllOrdersForMatchtradePostAccountStatus) {
  return apiV1CloseAllOrdersForMatchtradePostAccountStatus.value;
}

enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus
    apiV1CloseAllOrdersForMatchtradePostAccountStatusFromJson(
  Object? apiV1CloseAllOrdersForMatchtradePostAccountStatus, [
  enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrdersForMatchtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus?
    apiV1CloseAllOrdersForMatchtradePostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrdersForMatchtradePostAccountStatus, [
  enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrdersForMatchtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1CloseAllOrdersForMatchtradePostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrdersForMatchtradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus>?
        apiV1CloseAllOrdersForMatchtradePostAccountStatus) {
  return apiV1CloseAllOrdersForMatchtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrdersForMatchtradePostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus>?
        apiV1CloseAllOrdersForMatchtradePostAccountStatus) {
  if (apiV1CloseAllOrdersForMatchtradePostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrdersForMatchtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus>
    apiV1CloseAllOrdersForMatchtradePostAccountStatusListFromJson(
  List? apiV1CloseAllOrdersForMatchtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForMatchtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrdersForMatchtradePostAccountStatus
      .map((e) => apiV1CloseAllOrdersForMatchtradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus>?
    apiV1CloseAllOrdersForMatchtradePostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrdersForMatchtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrdersForMatchtradePostAccountStatus>? defaultValue,
]) {
  if (apiV1CloseAllOrdersForMatchtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrdersForMatchtradePostAccountStatus
      .map((e) => apiV1CloseAllOrdersForMatchtradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus?
        apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus
        apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus
    apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus?
    apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus, [
  enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus) ??
      defaultValue;
}

String
    apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatusExplodedListToJson(
        List<enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus>?
            apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus) {
  return apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus>?
        apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus) {
  if (apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus>
    apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatusFromJson(
              e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus>?
    apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySymbolForMatchtradePostAccountStatusFromJson(
              e.toString()))
      .toList();
}

int? apiV1CloseAllOrderBySellForMatchTradePostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus?
        apiV1CloseAllOrderBySellForMatchTradePostAccountStatus) {
  return apiV1CloseAllOrderBySellForMatchTradePostAccountStatus?.value;
}

int? apiV1CloseAllOrderBySellForMatchTradePostAccountStatusToJson(
    enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus
        apiV1CloseAllOrderBySellForMatchTradePostAccountStatus) {
  return apiV1CloseAllOrderBySellForMatchTradePostAccountStatus.value;
}

enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus
    apiV1CloseAllOrderBySellForMatchTradePostAccountStatusFromJson(
  Object? apiV1CloseAllOrderBySellForMatchTradePostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySellForMatchTradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus?
    apiV1CloseAllOrderBySellForMatchTradePostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderBySellForMatchTradePostAccountStatus, [
  enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderBySellForMatchTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderBySellForMatchTradePostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderBySellForMatchTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus>?
        apiV1CloseAllOrderBySellForMatchTradePostAccountStatus) {
  return apiV1CloseAllOrderBySellForMatchTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderBySellForMatchTradePostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus>?
        apiV1CloseAllOrderBySellForMatchTradePostAccountStatus) {
  if (apiV1CloseAllOrderBySellForMatchTradePostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderBySellForMatchTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus>
    apiV1CloseAllOrderBySellForMatchTradePostAccountStatusListFromJson(
  List? apiV1CloseAllOrderBySellForMatchTradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySellForMatchTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderBySellForMatchTradePostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySellForMatchTradePostAccountStatusFromJson(
              e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus>?
    apiV1CloseAllOrderBySellForMatchTradePostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderBySellForMatchTradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderBySellForMatchTradePostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderBySellForMatchTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderBySellForMatchTradePostAccountStatus
      .map((e) =>
          apiV1CloseAllOrderBySellForMatchTradePostAccountStatusFromJson(
              e.toString()))
      .toList();
}

int? apiV1CloseAllOrderByBuyForMatchTradePostAccountStatusNullableToJson(
    enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus?
        apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus) {
  return apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus?.value;
}

int? apiV1CloseAllOrderByBuyForMatchTradePostAccountStatusToJson(
    enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus
        apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus) {
  return apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus.value;
}

enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus
    apiV1CloseAllOrderByBuyForMatchTradePostAccountStatusFromJson(
  Object? apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus?
    apiV1CloseAllOrderByBuyForMatchTradePostAccountStatusNullableFromJson(
  Object? apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus, [
  enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus? defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value ==
              apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus) ??
      defaultValue;
}

String apiV1CloseAllOrderByBuyForMatchTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus>?
        apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus) {
  return apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1CloseAllOrderByBuyForMatchTradePostAccountStatusListToJson(
    List<enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus>?
        apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus) {
  if (apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus == null) {
    return [];
  }

  return apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus>
    apiV1CloseAllOrderByBuyForMatchTradePostAccountStatusListFromJson(
  List? apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus
      .map((e) => apiV1CloseAllOrderByBuyForMatchTradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus>?
    apiV1CloseAllOrderByBuyForMatchTradePostAccountStatusNullableListFromJson(
  List? apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus, [
  List<enums.ApiV1CloseAllOrderByBuyForMatchTradePostAccountStatus>?
      defaultValue,
]) {
  if (apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1CloseAllOrderByBuyForMatchTradePostAccountStatus
      .map((e) => apiV1CloseAllOrderByBuyForMatchTradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1SendPendingOrderMatchTradePostAccountStatusNullableToJson(
    enums.ApiV1SendPendingOrderMatchTradePostAccountStatus?
        apiV1SendPendingOrderMatchTradePostAccountStatus) {
  return apiV1SendPendingOrderMatchTradePostAccountStatus?.value;
}

int? apiV1SendPendingOrderMatchTradePostAccountStatusToJson(
    enums.ApiV1SendPendingOrderMatchTradePostAccountStatus
        apiV1SendPendingOrderMatchTradePostAccountStatus) {
  return apiV1SendPendingOrderMatchTradePostAccountStatus.value;
}

enums.ApiV1SendPendingOrderMatchTradePostAccountStatus
    apiV1SendPendingOrderMatchTradePostAccountStatusFromJson(
  Object? apiV1SendPendingOrderMatchTradePostAccountStatus, [
  enums.ApiV1SendPendingOrderMatchTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1SendPendingOrderMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1SendPendingOrderMatchTradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1SendPendingOrderMatchTradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1SendPendingOrderMatchTradePostAccountStatus?
    apiV1SendPendingOrderMatchTradePostAccountStatusNullableFromJson(
  Object? apiV1SendPendingOrderMatchTradePostAccountStatus, [
  enums.ApiV1SendPendingOrderMatchTradePostAccountStatus? defaultValue,
]) {
  if (apiV1SendPendingOrderMatchTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1SendPendingOrderMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1SendPendingOrderMatchTradePostAccountStatus) ??
      defaultValue;
}

String apiV1SendPendingOrderMatchTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1SendPendingOrderMatchTradePostAccountStatus>?
        apiV1SendPendingOrderMatchTradePostAccountStatus) {
  return apiV1SendPendingOrderMatchTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1SendPendingOrderMatchTradePostAccountStatusListToJson(
    List<enums.ApiV1SendPendingOrderMatchTradePostAccountStatus>?
        apiV1SendPendingOrderMatchTradePostAccountStatus) {
  if (apiV1SendPendingOrderMatchTradePostAccountStatus == null) {
    return [];
  }

  return apiV1SendPendingOrderMatchTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1SendPendingOrderMatchTradePostAccountStatus>
    apiV1SendPendingOrderMatchTradePostAccountStatusListFromJson(
  List? apiV1SendPendingOrderMatchTradePostAccountStatus, [
  List<enums.ApiV1SendPendingOrderMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPendingOrderMatchTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1SendPendingOrderMatchTradePostAccountStatus
      .map((e) => apiV1SendPendingOrderMatchTradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1SendPendingOrderMatchTradePostAccountStatus>?
    apiV1SendPendingOrderMatchTradePostAccountStatusNullableListFromJson(
  List? apiV1SendPendingOrderMatchTradePostAccountStatus, [
  List<enums.ApiV1SendPendingOrderMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1SendPendingOrderMatchTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1SendPendingOrderMatchTradePostAccountStatus
      .map((e) => apiV1SendPendingOrderMatchTradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1ModifyPendingOrderMatchTradePostAccountStatusNullableToJson(
    enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus?
        apiV1ModifyPendingOrderMatchTradePostAccountStatus) {
  return apiV1ModifyPendingOrderMatchTradePostAccountStatus?.value;
}

int? apiV1ModifyPendingOrderMatchTradePostAccountStatusToJson(
    enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus
        apiV1ModifyPendingOrderMatchTradePostAccountStatus) {
  return apiV1ModifyPendingOrderMatchTradePostAccountStatus.value;
}

enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus
    apiV1ModifyPendingOrderMatchTradePostAccountStatusFromJson(
  Object? apiV1ModifyPendingOrderMatchTradePostAccountStatus, [
  enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPendingOrderMatchTradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus?
    apiV1ModifyPendingOrderMatchTradePostAccountStatusNullableFromJson(
  Object? apiV1ModifyPendingOrderMatchTradePostAccountStatus, [
  enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus? defaultValue,
]) {
  if (apiV1ModifyPendingOrderMatchTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ModifyPendingOrderMatchTradePostAccountStatus) ??
      defaultValue;
}

String apiV1ModifyPendingOrderMatchTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus>?
        apiV1ModifyPendingOrderMatchTradePostAccountStatus) {
  return apiV1ModifyPendingOrderMatchTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ModifyPendingOrderMatchTradePostAccountStatusListToJson(
    List<enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus>?
        apiV1ModifyPendingOrderMatchTradePostAccountStatus) {
  if (apiV1ModifyPendingOrderMatchTradePostAccountStatus == null) {
    return [];
  }

  return apiV1ModifyPendingOrderMatchTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus>
    apiV1ModifyPendingOrderMatchTradePostAccountStatusListFromJson(
  List? apiV1ModifyPendingOrderMatchTradePostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderMatchTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ModifyPendingOrderMatchTradePostAccountStatus
      .map((e) => apiV1ModifyPendingOrderMatchTradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus>?
    apiV1ModifyPendingOrderMatchTradePostAccountStatusNullableListFromJson(
  List? apiV1ModifyPendingOrderMatchTradePostAccountStatus, [
  List<enums.ApiV1ModifyPendingOrderMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ModifyPendingOrderMatchTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ModifyPendingOrderMatchTradePostAccountStatus
      .map((e) => apiV1ModifyPendingOrderMatchTradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1ClosePendingOrderMatchTradePostAccountStatusNullableToJson(
    enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus?
        apiV1ClosePendingOrderMatchTradePostAccountStatus) {
  return apiV1ClosePendingOrderMatchTradePostAccountStatus?.value;
}

int? apiV1ClosePendingOrderMatchTradePostAccountStatusToJson(
    enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus
        apiV1ClosePendingOrderMatchTradePostAccountStatus) {
  return apiV1ClosePendingOrderMatchTradePostAccountStatus.value;
}

enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus
    apiV1ClosePendingOrderMatchTradePostAccountStatusFromJson(
  Object? apiV1ClosePendingOrderMatchTradePostAccountStatus, [
  enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus? defaultValue,
]) {
  return enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePendingOrderMatchTradePostAccountStatus) ??
      defaultValue ??
      enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus?
    apiV1ClosePendingOrderMatchTradePostAccountStatusNullableFromJson(
  Object? apiV1ClosePendingOrderMatchTradePostAccountStatus, [
  enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus? defaultValue,
]) {
  if (apiV1ClosePendingOrderMatchTradePostAccountStatus == null) {
    return null;
  }
  return enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1ClosePendingOrderMatchTradePostAccountStatus) ??
      defaultValue;
}

String apiV1ClosePendingOrderMatchTradePostAccountStatusExplodedListToJson(
    List<enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus>?
        apiV1ClosePendingOrderMatchTradePostAccountStatus) {
  return apiV1ClosePendingOrderMatchTradePostAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1ClosePendingOrderMatchTradePostAccountStatusListToJson(
    List<enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus>?
        apiV1ClosePendingOrderMatchTradePostAccountStatus) {
  if (apiV1ClosePendingOrderMatchTradePostAccountStatus == null) {
    return [];
  }

  return apiV1ClosePendingOrderMatchTradePostAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus>
    apiV1ClosePendingOrderMatchTradePostAccountStatusListFromJson(
  List? apiV1ClosePendingOrderMatchTradePostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderMatchTradePostAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1ClosePendingOrderMatchTradePostAccountStatus
      .map((e) => apiV1ClosePendingOrderMatchTradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus>?
    apiV1ClosePendingOrderMatchTradePostAccountStatusNullableListFromJson(
  List? apiV1ClosePendingOrderMatchTradePostAccountStatus, [
  List<enums.ApiV1ClosePendingOrderMatchTradePostAccountStatus>? defaultValue,
]) {
  if (apiV1ClosePendingOrderMatchTradePostAccountStatus == null) {
    return defaultValue;
  }

  return apiV1ClosePendingOrderMatchTradePostAccountStatus
      .map((e) => apiV1ClosePendingOrderMatchTradePostAccountStatusFromJson(
          e.toString()))
      .toList();
}

int? apiV1MatchTradeUpdateRiskPostRiskTypeNullableToJson(
    enums.ApiV1MatchTradeUpdateRiskPostRiskType?
        apiV1MatchTradeUpdateRiskPostRiskType) {
  return apiV1MatchTradeUpdateRiskPostRiskType?.value;
}

int? apiV1MatchTradeUpdateRiskPostRiskTypeToJson(
    enums.ApiV1MatchTradeUpdateRiskPostRiskType
        apiV1MatchTradeUpdateRiskPostRiskType) {
  return apiV1MatchTradeUpdateRiskPostRiskType.value;
}

enums.ApiV1MatchTradeUpdateRiskPostRiskType
    apiV1MatchTradeUpdateRiskPostRiskTypeFromJson(
  Object? apiV1MatchTradeUpdateRiskPostRiskType, [
  enums.ApiV1MatchTradeUpdateRiskPostRiskType? defaultValue,
]) {
  return enums.ApiV1MatchTradeUpdateRiskPostRiskType.values.firstWhereOrNull(
          (e) => e.value == apiV1MatchTradeUpdateRiskPostRiskType) ??
      defaultValue ??
      enums.ApiV1MatchTradeUpdateRiskPostRiskType.swaggerGeneratedUnknown;
}

enums.ApiV1MatchTradeUpdateRiskPostRiskType?
    apiV1MatchTradeUpdateRiskPostRiskTypeNullableFromJson(
  Object? apiV1MatchTradeUpdateRiskPostRiskType, [
  enums.ApiV1MatchTradeUpdateRiskPostRiskType? defaultValue,
]) {
  if (apiV1MatchTradeUpdateRiskPostRiskType == null) {
    return null;
  }
  return enums.ApiV1MatchTradeUpdateRiskPostRiskType.values.firstWhereOrNull(
          (e) => e.value == apiV1MatchTradeUpdateRiskPostRiskType) ??
      defaultValue;
}

String apiV1MatchTradeUpdateRiskPostRiskTypeExplodedListToJson(
    List<enums.ApiV1MatchTradeUpdateRiskPostRiskType>?
        apiV1MatchTradeUpdateRiskPostRiskType) {
  return apiV1MatchTradeUpdateRiskPostRiskType
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1MatchTradeUpdateRiskPostRiskTypeListToJson(
    List<enums.ApiV1MatchTradeUpdateRiskPostRiskType>?
        apiV1MatchTradeUpdateRiskPostRiskType) {
  if (apiV1MatchTradeUpdateRiskPostRiskType == null) {
    return [];
  }

  return apiV1MatchTradeUpdateRiskPostRiskType.map((e) => e.value!).toList();
}

List<enums.ApiV1MatchTradeUpdateRiskPostRiskType>
    apiV1MatchTradeUpdateRiskPostRiskTypeListFromJson(
  List? apiV1MatchTradeUpdateRiskPostRiskType, [
  List<enums.ApiV1MatchTradeUpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1MatchTradeUpdateRiskPostRiskType == null) {
    return defaultValue ?? [];
  }

  return apiV1MatchTradeUpdateRiskPostRiskType
      .map((e) => apiV1MatchTradeUpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1MatchTradeUpdateRiskPostRiskType>?
    apiV1MatchTradeUpdateRiskPostRiskTypeNullableListFromJson(
  List? apiV1MatchTradeUpdateRiskPostRiskType, [
  List<enums.ApiV1MatchTradeUpdateRiskPostRiskType>? defaultValue,
]) {
  if (apiV1MatchTradeUpdateRiskPostRiskType == null) {
    return defaultValue;
  }

  return apiV1MatchTradeUpdateRiskPostRiskType
      .map((e) => apiV1MatchTradeUpdateRiskPostRiskTypeFromJson(e.toString()))
      .toList();
}

int? apiV1MatchTradeUpdateStopsLimitsPostScalperModeNullableToJson(
    enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode?
        apiV1MatchTradeUpdateStopsLimitsPostScalperMode) {
  return apiV1MatchTradeUpdateStopsLimitsPostScalperMode?.value;
}

int? apiV1MatchTradeUpdateStopsLimitsPostScalperModeToJson(
    enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode
        apiV1MatchTradeUpdateStopsLimitsPostScalperMode) {
  return apiV1MatchTradeUpdateStopsLimitsPostScalperMode.value;
}

enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode
    apiV1MatchTradeUpdateStopsLimitsPostScalperModeFromJson(
  Object? apiV1MatchTradeUpdateStopsLimitsPostScalperMode, [
  enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  return enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode.values
          .firstWhereOrNull((e) =>
              e.value == apiV1MatchTradeUpdateStopsLimitsPostScalperMode) ??
      defaultValue ??
      enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode
          .swaggerGeneratedUnknown;
}

enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode?
    apiV1MatchTradeUpdateStopsLimitsPostScalperModeNullableFromJson(
  Object? apiV1MatchTradeUpdateStopsLimitsPostScalperMode, [
  enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode? defaultValue,
]) {
  if (apiV1MatchTradeUpdateStopsLimitsPostScalperMode == null) {
    return null;
  }
  return enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode.values
          .firstWhereOrNull((e) =>
              e.value == apiV1MatchTradeUpdateStopsLimitsPostScalperMode) ??
      defaultValue;
}

String apiV1MatchTradeUpdateStopsLimitsPostScalperModeExplodedListToJson(
    List<enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode>?
        apiV1MatchTradeUpdateStopsLimitsPostScalperMode) {
  return apiV1MatchTradeUpdateStopsLimitsPostScalperMode
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1MatchTradeUpdateStopsLimitsPostScalperModeListToJson(
    List<enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode>?
        apiV1MatchTradeUpdateStopsLimitsPostScalperMode) {
  if (apiV1MatchTradeUpdateStopsLimitsPostScalperMode == null) {
    return [];
  }

  return apiV1MatchTradeUpdateStopsLimitsPostScalperMode
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode>
    apiV1MatchTradeUpdateStopsLimitsPostScalperModeListFromJson(
  List? apiV1MatchTradeUpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1MatchTradeUpdateStopsLimitsPostScalperMode == null) {
    return defaultValue ?? [];
  }

  return apiV1MatchTradeUpdateStopsLimitsPostScalperMode
      .map((e) =>
          apiV1MatchTradeUpdateStopsLimitsPostScalperModeFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode>?
    apiV1MatchTradeUpdateStopsLimitsPostScalperModeNullableListFromJson(
  List? apiV1MatchTradeUpdateStopsLimitsPostScalperMode, [
  List<enums.ApiV1MatchTradeUpdateStopsLimitsPostScalperMode>? defaultValue,
]) {
  if (apiV1MatchTradeUpdateStopsLimitsPostScalperMode == null) {
    return defaultValue;
  }

  return apiV1MatchTradeUpdateStopsLimitsPostScalperMode
      .map((e) =>
          apiV1MatchTradeUpdateStopsLimitsPostScalperModeFromJson(e.toString()))
      .toList();
}

int? apiV1MatchTradeUpdateStopsLimitsPostOrderFilterNullableToJson(
    enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter?
        apiV1MatchTradeUpdateStopsLimitsPostOrderFilter) {
  return apiV1MatchTradeUpdateStopsLimitsPostOrderFilter?.value;
}

int? apiV1MatchTradeUpdateStopsLimitsPostOrderFilterToJson(
    enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter
        apiV1MatchTradeUpdateStopsLimitsPostOrderFilter) {
  return apiV1MatchTradeUpdateStopsLimitsPostOrderFilter.value;
}

enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter
    apiV1MatchTradeUpdateStopsLimitsPostOrderFilterFromJson(
  Object? apiV1MatchTradeUpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  return enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter.values
          .firstWhereOrNull((e) =>
              e.value == apiV1MatchTradeUpdateStopsLimitsPostOrderFilter) ??
      defaultValue ??
      enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter
          .swaggerGeneratedUnknown;
}

enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter?
    apiV1MatchTradeUpdateStopsLimitsPostOrderFilterNullableFromJson(
  Object? apiV1MatchTradeUpdateStopsLimitsPostOrderFilter, [
  enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter? defaultValue,
]) {
  if (apiV1MatchTradeUpdateStopsLimitsPostOrderFilter == null) {
    return null;
  }
  return enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter.values
          .firstWhereOrNull((e) =>
              e.value == apiV1MatchTradeUpdateStopsLimitsPostOrderFilter) ??
      defaultValue;
}

String apiV1MatchTradeUpdateStopsLimitsPostOrderFilterExplodedListToJson(
    List<enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter>?
        apiV1MatchTradeUpdateStopsLimitsPostOrderFilter) {
  return apiV1MatchTradeUpdateStopsLimitsPostOrderFilter
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1MatchTradeUpdateStopsLimitsPostOrderFilterListToJson(
    List<enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter>?
        apiV1MatchTradeUpdateStopsLimitsPostOrderFilter) {
  if (apiV1MatchTradeUpdateStopsLimitsPostOrderFilter == null) {
    return [];
  }

  return apiV1MatchTradeUpdateStopsLimitsPostOrderFilter
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter>
    apiV1MatchTradeUpdateStopsLimitsPostOrderFilterListFromJson(
  List? apiV1MatchTradeUpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1MatchTradeUpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue ?? [];
  }

  return apiV1MatchTradeUpdateStopsLimitsPostOrderFilter
      .map((e) =>
          apiV1MatchTradeUpdateStopsLimitsPostOrderFilterFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter>?
    apiV1MatchTradeUpdateStopsLimitsPostOrderFilterNullableListFromJson(
  List? apiV1MatchTradeUpdateStopsLimitsPostOrderFilter, [
  List<enums.ApiV1MatchTradeUpdateStopsLimitsPostOrderFilter>? defaultValue,
]) {
  if (apiV1MatchTradeUpdateStopsLimitsPostOrderFilter == null) {
    return defaultValue;
  }

  return apiV1MatchTradeUpdateStopsLimitsPostOrderFilter
      .map((e) =>
          apiV1MatchTradeUpdateStopsLimitsPostOrderFilterFromJson(e.toString()))
      .toList();
}

int? apiV1GetAllSymbolMatchTradeUserIdGetAccountStatusNullableToJson(
    enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus?
        apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus) {
  return apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus?.value;
}

int? apiV1GetAllSymbolMatchTradeUserIdGetAccountStatusToJson(
    enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus
        apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus) {
  return apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus.value;
}

enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus
    apiV1GetAllSymbolMatchTradeUserIdGetAccountStatusFromJson(
  Object? apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus, [
  enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus? defaultValue,
]) {
  return enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus) ??
      defaultValue ??
      enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus
          .swaggerGeneratedUnknown;
}

enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus?
    apiV1GetAllSymbolMatchTradeUserIdGetAccountStatusNullableFromJson(
  Object? apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus, [
  enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus? defaultValue,
]) {
  if (apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus == null) {
    return null;
  }
  return enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus.values
          .firstWhereOrNull((e) =>
              e.value == apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus) ??
      defaultValue;
}

String apiV1GetAllSymbolMatchTradeUserIdGetAccountStatusExplodedListToJson(
    List<enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus>?
        apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus) {
  return apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<int> apiV1GetAllSymbolMatchTradeUserIdGetAccountStatusListToJson(
    List<enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus>?
        apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus) {
  if (apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus == null) {
    return [];
  }

  return apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus>
    apiV1GetAllSymbolMatchTradeUserIdGetAccountStatusListFromJson(
  List? apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus, [
  List<enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus>? defaultValue,
]) {
  if (apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus == null) {
    return defaultValue ?? [];
  }

  return apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus
      .map((e) => apiV1GetAllSymbolMatchTradeUserIdGetAccountStatusFromJson(
          e.toString()))
      .toList();
}

List<enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus>?
    apiV1GetAllSymbolMatchTradeUserIdGetAccountStatusNullableListFromJson(
  List? apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus, [
  List<enums.ApiV1GetAllSymbolMatchTradeUserIdGetAccountStatus>? defaultValue,
]) {
  if (apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus == null) {
    return defaultValue;
  }

  return apiV1GetAllSymbolMatchTradeUserIdGetAccountStatus
      .map((e) => apiV1GetAllSymbolMatchTradeUserIdGetAccountStatusFromJson(
          e.toString()))
      .toList();
}

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
