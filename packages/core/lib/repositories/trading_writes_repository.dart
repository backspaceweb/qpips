import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import '../api/generated/api.swagger.dart';
import '../domain/account.dart';

/// **Parked / not currently wired into the UI.**
///
/// QuantumPips's admin panel is view-only for trading per the product
/// spec (2026-04-30): trades originate on the Master account through
/// the trader's own MT4 / MT5 client, and Slaves auto-replicate via
/// the trading server's FIX-API backend. The admin dashboard's role
/// is monitoring + per-slave configuration, not order execution.
///
/// These methods are kept here, fully working and dispatched-by-platform,
/// so we can re-introduce manual-override or an admin-side trading
/// surface later without re-deriving the spec quirks.
///
/// Spec quirks captured here (so future maintainers don't relearn them):
///  - `accountStatus` enum: index 0 of `.values` is `swaggerGeneratedUnknown`,
///    not master. Reference `value_0` / `value_1` directly.
///  - MT4's `send_order` accepts `accountStatus` as raw String
///    (`'ExistsAsMaster'` / `'ExistsAsFollow'`); MT5's takes the typed
///    enum.
///  - MT5's `send_pending_order` does NOT accept `stopLoss` / `takeProfit`
///    at creation, while MT4's does. Set them via `modifyOrder` after
///    the pending lands.
///
/// Not registered in `ApiClientProvider.providers`; future feature work
/// can wire it in when needed, or instantiate locally with the existing
/// `Api` instance.
class TradingWritesRepository {
  final Api _api;

  TradingWritesRepository(this._api);

  static const String _statusMaster = 'ExistsAsMaster';
  static const String _statusFollow = 'ExistsAsFollow';

  /// Update SL / TP on an existing open order. Pass 0 to clear a level.
  Future<bool> modifyOrder({
    required Account account,
    required int ticket,
    required num stopLoss,
    required num takeProfit,
  }) async {
    try {
      Response response;
      switch (account.platform) {
        case Platform.mt5:
          response = await _api.apiV1ModifyOrderMt5Post(
            ticket: ticket,
            userId: account.serverId,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            accountStatus: account.isMaster
                ? ApiV1ModifyOrderMt5PostAccountStatus.value_0
                : ApiV1ModifyOrderMt5PostAccountStatus.value_1,
          );
          break;
        case Platform.mt4:
          response = await _api.apiV1ModifyOrderMt4Post(
            ticket: ticket,
            userId: account.serverId,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            accountStatus: account.isMaster
                ? ApiV1ModifyOrderMt4PostAccountStatus.value_0
                : ApiV1ModifyOrderMt4PostAccountStatus.value_1,
          );
          break;
        default:
          if (kDebugMode) {
            print('modifyOrder: ${account.platform.wireValue} not yet supported');
          }
          return false;
      }
      return response.isSuccessful;
    } catch (e) {
      if (kDebugMode) print('modifyOrder error: $e');
      return false;
    }
  }

  /// Fully close an open order at the current market price.
  Future<bool> closeOrder({
    required Account account,
    required int ticket,
  }) async {
    try {
      Response response;
      switch (account.platform) {
        case Platform.mt5:
          response = await _api.apiV1CloseOrderForMT5Post(
            userId: account.serverId,
            ticket: ticket,
            accountStatus: account.isMaster
                ? ApiV1CloseOrderForMT5PostAccountStatus.value_0
                : ApiV1CloseOrderForMT5PostAccountStatus.value_1,
          );
          break;
        case Platform.mt4:
          response = await _api.apiV1CloseOrderMt4Post(
            userId: account.serverId,
            ticket: ticket,
            accountStatus: account.isMaster
                ? ApiV1CloseOrderMt4PostAccountStatus.value_0
                : ApiV1CloseOrderMt4PostAccountStatus.value_1,
          );
          break;
        default:
          if (kDebugMode) {
            print('closeOrder: ${account.platform.wireValue} not yet supported');
          }
          return false;
      }
      return response.isSuccessful;
    } catch (e) {
      if (kDebugMode) print('closeOrder error: $e');
      return false;
    }
  }

  /// Open a new market order at current price.
  Future<bool> sendMarketOrder({
    required Account account,
    required String side, // "Buy" or "Sell"
    required num lots,
    required String symbol,
    num? stopLoss,
    num? takeProfit,
  }) async {
    try {
      Response<StringResponseDto> response;
      switch (account.platform) {
        case Platform.mt5:
          response = await _api.apiV1SendOrderMt5Post(
            userId: account.serverId,
            orderType: side,
            lots: lots,
            symbol: symbol,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            accountStatus: account.isMaster
                ? ApiV1SendOrderMt5PostAccountStatus.value_0
                : ApiV1SendOrderMt5PostAccountStatus.value_1,
          );
          break;
        case Platform.mt4:
          response = await _api.apiV1SendOrderMt4Post(
            userId: account.serverId,
            orderType: side,
            lots: lots,
            symbol: symbol,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            accountStatus: account.isMaster ? _statusMaster : _statusFollow,
          );
          break;
        default:
          if (kDebugMode) {
            print('sendMarketOrder: ${account.platform.wireValue} not yet supported');
          }
          return false;
      }
      return response.isSuccessful;
    } catch (e) {
      if (kDebugMode) print('sendMarketOrder error: $e');
      return false;
    }
  }

  /// Open a new pending order. [orderType] is one of:
  /// BuyLimit, SellLimit, BuyStop, SellStop. (BuyStopLimit / SellStopLimit
  /// are also accepted by the API but not modeled in the UI today.)
  ///
  /// Note: MT5's send_pending_order does NOT accept stopLoss / takeProfit
  /// at creation; call [modifyOrder] after the pending lands to set them.
  Future<bool> sendPendingOrder({
    required Account account,
    required String orderType,
    required num lots,
    required num price,
    required String symbol,
    num? stopLoss,
    num? takeProfit,
  }) async {
    try {
      Response<StringResponseDto> response;
      switch (account.platform) {
        case Platform.mt5:
          response = await _api.apiV1SendPendingOrderMt5Post(
            userId: account.serverId,
            orderType: orderType,
            lots: lots,
            price: price,
            symbol: symbol,
            accountStatus: account.isMaster
                ? ApiV1SendPendingOrderMt5PostAccountStatus.value_0
                : ApiV1SendPendingOrderMt5PostAccountStatus.value_1,
          );
          break;
        case Platform.mt4:
          response = await _api.apiV1SendPendingOrderMt4Post(
            userId: account.serverId,
            orderType: orderType,
            lots: lots,
            price: price,
            symbol: symbol,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            accountStatus: account.isMaster
                ? ApiV1SendPendingOrderMt4PostAccountStatus.value_0
                : ApiV1SendPendingOrderMt4PostAccountStatus.value_1,
          );
          break;
        default:
          if (kDebugMode) {
            print('sendPendingOrder: ${account.platform.wireValue} not yet supported');
          }
          return false;
      }
      return response.isSuccessful;
    } catch (e) {
      if (kDebugMode) print('sendPendingOrder error: $e');
      return false;
    }
  }
}
