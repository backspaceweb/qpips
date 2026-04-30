import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/api/generated/api.swagger.dart';
import '../domain/account.dart';
import '../domain/order_control_settings.dart';
import '../domain/symbol_map.dart';
import '../domain/trade_order.dart';

class TradingRepository {
  final Api _api;
  final _supabase = Supabase.instance.client;

  TradingRepository(this._api);

  // --- SUPABASE METHODS ---

  Future<void> saveAccountToCloud({
    required String accountName,
    required String loginNumber,
    required String platform,
    required String accountType,
    String? serverId,
    String? masterId,
  }) async {
    try {
      if (kDebugMode) print('SUPABASE_SAVE_START: Saving $accountName ($loginNumber)...');
      await _supabase.from('trading_accounts').upsert({
        'account_name': accountName,
        'login_number': loginNumber,
        'platform': platform,
        'account_type': accountType,
        'server_id': serverId,
        'master_id': masterId,
      }, onConflict: 'login_number');
      if (kDebugMode) print('SUPABASE_SAVE_SUCCESS: Account $accountName is now in the cloud.');
    } catch (e) {
      if (kDebugMode) print('SUPABASE_SAVE_CRITICAL_ERROR: $e');
      // Fallback: try simple insert if upsert fails
      try {
        if (kDebugMode) print('SUPABASE_SAVE_FALLBACK: Attempting simple insert...');
        await _supabase.from('trading_accounts').insert({
          'account_name': accountName,
          'login_number': loginNumber,
          'platform': platform,
          'account_type': accountType,
          'server_id': serverId,
          'master_id': masterId,
        });
        if (kDebugMode) print('SUPABASE_SAVE_FALLBACK_SUCCESS: Saved via insert.');
      } catch (e2) {
        if (kDebugMode) print('SUPABASE_SAVE_TOTAL_FAILURE: $e2');
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchAccountsFromCloud() async {
    try {
      if (kDebugMode) print('Supabase: Fetching accounts from cloud...');
      final response = await _supabase.from('trading_accounts').select('*');
      if (kDebugMode) print('Supabase: Fetched ${response.length} accounts.');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) print('Supabase Error (fetch): $e');
      return [];
    }
  }

  Future<void> deleteAccountFromCloud(String loginNumber) async {
    try {
      await _supabase.from('trading_accounts').delete().eq('login_number', loginNumber);
      if (kDebugMode) print('Cloud: Account $loginNumber deleted successfully.');
    } catch (e) {
      if (kDebugMode) print('Cloud Error: Failed to delete account: $e');
    }
  }

  Future<void> updateServerIdInCloud(String loginNumber, String serverId) async {
    try {
      await _supabase.from('trading_accounts').update({'server_id': serverId}).eq('login_number', loginNumber);
      if (kDebugMode) print('Cloud: Linked Server ID $serverId to Login $loginNumber');
    } catch (e) {
      if (kDebugMode) print('Cloud Error: Failed to update Server ID: $e');
    }
  }

  // --- EXISTING METHODS UPDATED ---

  Future<Map<String, double>> getLivePrices() async {
    // Mock prices for now as the endpoint is missing in the API
    return {
      'EURUSD': 1.08452,
      'GBPUSD': 1.26784,
      'USDJPY': 151.423,
      'AUDUSD': 0.65432,
      'USDCAD': 1.35678,
      'BTCUSD': 67452.10,
    };
  }

  /// Activate or deactivate an account on its trading-server side.
  /// Dispatches MT4/MT5 by [account.platform]. Other platforms (cTrader,
  /// DxTrade, TradeLocker, MatchTrade) still need their own dispatch
  /// branches added — return false until then.
  Future<bool> toggleAccountActivation({
    required Account account,
    required bool activate,
  }) async {
    try {
      Response<StringResponseDto> response;
      switch (account.platform) {
        case Platform.mt5:
          response = account.isMaster
              ? await _api.apiV1ActiveMasterMT5Post(id: account.serverId, status: activate)
              : await _api.apiV1ActiveSlaveMT5Post(id: account.serverId, status: activate);
          break;
        case Platform.mt4:
          response = account.isMaster
              ? await _api.apiV1ActiveMasterMT4Post(id: account.serverId, status: activate)
              : await _api.apiV1ActiveSlaveMT4Post(id: account.serverId, status: activate);
          break;
        default:
          if (kDebugMode) {
            print('toggleAccountActivation: ${account.platform.wireValue} not yet supported');
          }
          return false;
      }
      return response.isSuccessful;
    } catch (e) {
      if (kDebugMode) print('toggleAccountActivation error: $e');
      return false;
    }
  }

  /// Read the slave's risk multiplier + stops/limits config.
  /// Dispatches MT4/MT5 by [account.platform].
  Future<Map<String, dynamic>> getRiskSettings({required Account account}) async {
    try {
      Response<Risk> riskResponse;
      Response<StopsLimits> stopsResponse;
      switch (account.platform) {
        case Platform.mt5:
          riskResponse = await _api.apiV1Mt5GetRiskGet(userId: account.serverId);
          stopsResponse = await _api.apiV1Mt5GetStopsLimitsGet(userId: account.serverId);
          break;
        case Platform.mt4:
          riskResponse = await _api.apiV1Mt4GetRiskGet(userId: account.serverId);
          stopsResponse = await _api.apiV1Mt4GetStopsLimitsGet(userId: account.serverId);
          break;
        default:
          return {'risk': null, 'stops': null};
      }
      return {
        'risk': riskResponse.isSuccessful ? riskResponse.body : null,
        'stops': stopsResponse.isSuccessful ? stopsResponse.body : null,
      };
    } catch (e) {
      if (kDebugMode) print('getRiskSettings error: $e');
      return {'risk': null, 'stops': null};
    }
  }

  /// Persist the slave's risk multiplier + stops/limits config.
  /// Dispatches MT4/MT5 by [account.platform]. Returns true only if BOTH
  /// the Risk and StopsLimits writes succeeded.
  Future<bool> updateRiskSettings({
    required Account account,
    required int riskType,
    required double multiplier,
    required bool copySLTP,
    required int scalperMode,
    required int orderFilter,
    required int scalperValue,
  }) async {
    try {
      Response riskResponse;
      Response stopsResponse;
      switch (account.platform) {
        case Platform.mt5:
          riskResponse = await _api.apiV1Mt5UpdateRiskPost(
            userId: account.serverId,
            riskType: ApiV1Mt5UpdateRiskPostRiskType.values[riskType],
            multiplier: multiplier,
          );
          stopsResponse = await _api.apiV1Mt5UpdateStopsLimitsPost(
            userId: account.serverId,
            copySLTP: copySLTP,
            scalperMode: ApiV1Mt5UpdateStopsLimitsPostScalperMode.values[scalperMode],
            orderFilter: ApiV1Mt5UpdateStopsLimitsPostOrderFilter.values[orderFilter],
            scalperValue: scalperValue,
          );
          break;
        case Platform.mt4:
          riskResponse = await _api.apiV1Mt4UpdateRiskPost(
            userId: account.serverId,
            riskType: ApiV1Mt4UpdateRiskPostRiskType.values[riskType],
            multiplier: multiplier,
          );
          stopsResponse = await _api.apiV1Mt4UpdateStopsLimitsPost(
            userId: account.serverId,
            copySLTP: copySLTP,
            scalperMode: ApiV1Mt4UpdateStopsLimitsPostScalperMode.values[scalperMode],
            orderFilter: ApiV1Mt4UpdateStopsLimitsPostOrderFilter.values[orderFilter],
            scalperValue: scalperValue,
          );
          break;
        default:
          return false;
      }
      return riskResponse.isSuccessful && stopsResponse.isSuccessful;
    } catch (e) {
      if (kDebugMode) print('updateRiskSettings error: $e');
      return false;
    }
  }

  // --- B2.1: Order Control settings (advanced auto-close) ---
  //
  // Read returns the swagger-generated FollowRiskSetting (21 fields, 10 of
  // which are server-computed ranges). We extract the 11 user-editable
  // fields into the typed OrderControlSettings.
  //
  // Write takes the 11 editable fields. Setting a field to 0 disables
  // that auto-close trigger.

  /// Read the slave's auto-close / equity-protection settings.
  /// Returns [OrderControlSettings.empty] on failure or unsupported platform.
  Future<OrderControlSettings> getOrderControlSettings({required Account account}) async {
    try {
      Response<FollowRiskSetting> response;
      switch (account.platform) {
        case Platform.mt5:
          response = await _api.apiV1Mt5GetOrderControlSettingsGet(userId: account.serverId);
          break;
        case Platform.mt4:
          response = await _api.apiV1Mt4GetOrderControlSettingsGet(userId: account.serverId);
          break;
        default:
          return OrderControlSettings.empty;
      }
      if (response.isSuccessful && response.body != null) {
        return OrderControlSettings.fromFollowRiskSetting(response.body!);
      }
      return OrderControlSettings.empty;
    } catch (e) {
      if (kDebugMode) print('getOrderControlSettings error: $e');
      return OrderControlSettings.empty;
    }
  }

  /// Persist the slave's auto-close / equity-protection settings.
  /// Returns true on HTTP 2xx success.
  Future<bool> updateOrderControlSettings({
    required Account account,
    required OrderControlSettings settings,
  }) async {
    try {
      Response response;
      switch (account.platform) {
        case Platform.mt5:
          response = await _api.apiV1Mt5UpdateOrderControlSettingPost(
            userId: account.serverId,
            profitOverPoint: settings.profitOverPoint,
            lossOverPoint: settings.lossOverPoint,
            profitForEveryOrder: settings.profitForEveryOrder,
            lossForEveryOrder: settings.lossForEveryOrder,
            profitForAllOrder: settings.profitForAllOrder,
            lossForAllOrder: settings.lossForAllOrder,
            equityUnderLow: settings.equityUnderLow,
            equityUnderHigh: settings.equityUnderHigh,
            pendingOrderProfitPoint: settings.pendingOrderProfitPoint,
            pendingOrderLossPoint: settings.pendingOrderLossPoint,
            pendingTimeout: settings.pendingTimeout,
          );
          break;
        case Platform.mt4:
          response = await _api.apiV1Mt4UpdateOrderControlSettingPost(
            userId: account.serverId,
            profitOverPoint: settings.profitOverPoint,
            lossOverPoint: settings.lossOverPoint,
            profitForEveryOrder: settings.profitForEveryOrder,
            lossForEveryOrder: settings.lossForEveryOrder,
            profitForAllOrder: settings.profitForAllOrder,
            lossForAllOrder: settings.lossForAllOrder,
            equityUnderLow: settings.equityUnderLow,
            equityUnderHigh: settings.equityUnderHigh,
            pendingOrderProfitPoint: settings.pendingOrderProfitPoint,
            pendingOrderLossPoint: settings.pendingOrderLossPoint,
            pendingTimeout: settings.pendingTimeout,
          );
          break;
        default:
          return false;
      }
      return response.isSuccessful;
    } catch (e) {
      if (kDebugMode) print('updateOrderControlSettings error: $e');
      return false;
    }
  }

  // --- B2.2: Symbol mapping (cross-broker) ---
  //
  // When master and slave are on different brokers, the same instrument
  // may have a different symbol on each side (e.g. master "EURUSD",
  // slave "EURUSD.x"). The trading server's symbol_map endpoints add
  // a translation layer per slave account.

  /// Register a symbol mapping for a slave account.
  ///
  /// `sourceSymbol` is the symbol as it appears on the master.
  /// `followSymbol` is the symbol on the slave's broker.
  /// `type` chooses Suffix (pattern-style) or Special (one-off).
  Future<bool> addSymbolMap({
    required Account account,
    required String sourceSymbol,
    required String followSymbol,
    required SymbolMapType type,
  }) async {
    try {
      Response response;
      switch (account.platform) {
        case Platform.mt5:
          response = await _api.apiV1SymbolMapMt5Post(
            userid: account.serverId,
            sourceSymbol: sourceSymbol,
            followSymbol: followSymbol,
            type: type.wireValue,
          );
          break;
        case Platform.mt4:
          response = await _api.apiV1SymbolMapMt4Post(
            userid: account.serverId,
            sourceSymbol: sourceSymbol,
            followSymbol: followSymbol,
            type: type.wireValue,
          );
          break;
        default:
          if (kDebugMode) {
            print('addSymbolMap: ${account.platform.wireValue} not yet supported');
          }
          return false;
      }
      return response.isSuccessful;
    } catch (e) {
      if (kDebugMode) print('addSymbolMap error: $e');
      return false;
    }
  }

  /// List the slave's currently-configured suffix mappings.
  /// Returns an empty list on failure or unsupported platform.
  Future<List<String>> getSuffixMappings({required Account account}) {
    return _fetchSymbolList(
      account: account,
      mt5Path: '/api/v1/getSuffix/mt5/${account.serverId}',
      mt4Path: '/api/v1/getSuffix/mt4/${account.serverId}',
    );
  }

  /// List the slave's currently-configured special mappings.
  Future<List<String>> getSpecialMappings({required Account account}) {
    return _fetchSymbolList(
      account: account,
      mt5Path: '/api/v1/getSpecial/mt5/${account.serverId}',
      mt4Path: '/api/v1/getSpecial/mt4/${account.serverId}',
    );
  }

  /// Shared helper for the suffix / special list endpoints. Both return
  /// either a JSON array of strings OR an empty array. The chopper
  /// generated methods are typed `Response<dynamic>` so we use raw GET.
  Future<List<String>> _fetchSymbolList({
    required Account account,
    required String mt5Path,
    required String mt4Path,
  }) async {
    Uri uri;
    switch (account.platform) {
      case Platform.mt5:
        uri = Uri.parse(mt5Path);
        break;
      case Platform.mt4:
        uri = Uri.parse(mt4Path);
        break;
      default:
        return [];
    }
    try {
      final response = await _api.client.get(uri);
      if (!response.isSuccessful || response.body == null) return [];
      final body = response.body;
      if (body is List) {
        return body.map((e) => e.toString()).toList();
      }
      if (body is String) {
        final s = body.trim();
        if (!s.startsWith('[')) return [];
        try {
          final decoded = jsonDecode(s);
          if (decoded is List) {
            return decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {}
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('_fetchSymbolList error ($uri): $e');
      return [];
    }
  }


  Future<Map<String, dynamic>> registerTradingAccount({
    required int userId,
    required String platformType,
    String? password,
    String? server,
    String? comment,
    bool isMaster = true,
    int? masterId,
    int? copyOrderType,
    // Additional fields for other platforms
    String? clientId,
    String? clientSecret,
    String? refreshToken,
    String? expireIn,
    String? email,
    String? accountName,
    String? userName,
    String? brokerId,
  }) async {
    try {
      if (kDebugMode) print('DEBUG: registerTradingAccount start: userId=$userId, platform=$platformType, isMaster=$isMaster');
      Response<StringResponseDto> response;
      final platform = platformType.toUpperCase();

      switch (platform) {
        case 'MT4':
          if (isMaster) {
            response = await _api.apiV1RegisterMasterMt4Post(
              userId: userId,
              password: password,
              server: server,
              comment: accountName ?? comment,
            );
          } else {
            response = await _api.apiV1RegisterSlaveMt4Post(
              userId: userId,
              password: password,
              server: server,
              masterId: masterId ?? 0,
              comment: accountName ?? comment,
              copyOrderType: copyOrderType ?? 0,
            );
          }
          break;

        case 'MT5':
          if (isMaster) {
            response = await _api.apiV1RegisterMasterForMT5Post(
              userId: userId,
              password: password,
              server: server,
              comment: accountName ?? comment,
            );
          } else {
            response = await _api.apiV1RegisterSlaveForMT5Post(
              userId: userId,
              password: password,
              server: server,
              masterId: masterId ?? 0,
              comment: accountName ?? comment,
              copyOrderType: copyOrderType ?? 0,
            );
          }
          break;

        case 'CTRADER':
          if (isMaster) {
            response = await _api.apiV1RegisterMasterCtraderPost(
              userId: userId,
              clientId: clientId,
              clientSecret: clientSecret,
              refreshToken: refreshToken,
              expireIn: expireIn,
              email: email,
              accountName: accountName,
              comment: comment,
            );
          } else {
            response = await _api.apiV1RegisterSlaveCtraderPost(
              userId: userId,
              clientId: clientId,
              clientSecret: clientSecret,
              refreshToken: refreshToken,
              expireIn: expireIn,
              masterId: masterId ?? 0,
              email: email,
              accountName: accountName,
              comment: comment,
              copyOrderType: copyOrderType ?? 0,
            );
          }
          break;

        case 'DXTRADE':
          if (isMaster) {
            response = await _api.apiV1RegisterMasterDxTradePost(
              userId: userId,
              userName: userName,
              password: password,
              server: server,
              comment: comment,
            );
          } else {
            response = await _api.apiV1RegisterSlaveDxTradePost(
              userId: userId,
              userName: userName,
              password: password,
              server: server,
              masterId: masterId ?? 0,
              comment: comment,
            );
          }
          break;

        case 'TRADELOCKER':
          if (isMaster) {
            response = await _api.apiV1RegisterMasterTradeLockerPost(
              userId: userId,
              password: password,
              server: server,
              emailId: email,
              comment: comment,
            );
          } else {
            response = await _api.apiV1RegisterSlaveTradeLockerPost(
              userId: userId,
              password: password,
              server: server,
              emailId: email,
              comment: comment,
              masterAcountId: masterId ?? 0,
            );
          }
          break;

        case 'MATCHTRADE':
          if (isMaster) {
            response = await _api.apiV1RegisterMasterMatchTradePost(
              userId: userId,
              password: password,
              server: server,
              emailId: email,
              brokerId: brokerId,
              comment: comment,
            );
          } else {
            response = await _api.apiV1RegisterSlaveMatchTradePost(
              userId: userId,
              password: password,
              server: server,
              emailId: email,
              brokerId: brokerId,
              comment: comment,
              masterAcountId: masterId ?? 0,
            );
          }
          break;

        default:
          return {'message': 'Unsupported platform: $platformType', 'success': false};
      }

      if (kDebugMode) print('DEBUG: registerTradingAccount response status: ${response.statusCode}');
      if (response.isSuccessful) {
        if (kDebugMode) print('DEBUG: registerTradingAccount success: ${response.body?.message}');
        return {
          'message': response.body?.message ?? 'Registration successful',
          'id': response.body?.data?.toString(),
          'success': true,
        };
      } else {
        final error = response.error;
        if (kDebugMode) print('DEBUG: registerTradingAccount failure: $error');
        return {
          'message': 'Registration failed: ${error ?? response.base.reasonPhrase}',
          'success': false,
        };
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('DEBUG: registerTradingAccount error: $e');
        print('DEBUG: stack trace: $stack');
      }
      return {'message': 'An error occurred: $e', 'success': false};
    }
  }

  Future<String> getAccountSummary(int userId) async {
    try {
      final response = await _api.apiV1GetUserInfoGet(userid: userId);
      if (response.isSuccessful) {
        return response.body?.message ?? 'No summary data available';
      } else {
        return 'Failed to fetch summary: ${response.error ?? response.base.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<Map<String, dynamic>> addAccount({
    required int userId,
    required String platformType,
    required String accountName,
    String? password,
    String? server,
    bool isMaster = true,
    int? masterId,
  }) async {
    final result = await registerTradingAccount(
      userId: userId,
      platformType: platformType,
      accountName: accountName,
      password: password,
      server: server,
      isMaster: isMaster,
      masterId: masterId,
    );

    if (result['success'] == true) {
      final String serverId = result['id']?.toString() ?? userId.toString();

      if (kDebugMode) print('DEBUG: registerTradingAccount successful. ID assigned: $serverId');

      // AUTO-SAVE TO SUPABASE WITH EXPLICIT ERROR CATCHING
      try {
        if (kDebugMode) print('DEBUG: Initiating Cloud Save for $accountName...');
        await saveAccountToCloud(
          accountName: accountName,
          loginNumber: userId.toString(),
          platform: platformType,
          accountType: isMaster ? 'Master' : 'Slave',
          serverId: serverId,
          masterId: masterId?.toString(),
        );
        if (kDebugMode) print('DEBUG: Cloud Save process finished.');
      } catch (cloudErr) {
        if (kDebugMode) print('DEBUG: CRITICAL CLOUD SAVE FAILURE: $cloudErr');
      }

      return {
        'id': serverId,
        'accountName': accountName,
        'accountNumber': userId.toString(),
        'platform': platformType,
        'accountType': isMaster ? 'Master' : 'Slave',
        'status': 'Offline',
        'success': true,
        'message': result['message'],
      };
    }
    return result;
  }

  // Phase C.1: this single endpoint is now routed through the Supabase
  // Edge Function `trading-proxy`. The function injects the trading API
  // key server-side (so it doesn't ship in the client bundle) and works
  // around the server's getAPIInfo `?key=` quirk transparently.
  //
  // The other endpoints below still call the trading server directly —
  // they'll be migrated in C.2 once we've verified this one works
  // end-to-end.
  Future<Map<String, dynamic>?> getAPIInfo() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) {
        if (kDebugMode) print('getAPIInfo: no Supabase session');
        return null;
      }
      const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
      final response = await _api.client.get(
        Uri.parse('$supabaseUrl/functions/v1/trading-proxy/api/v1/getAPIInfo'),
        headers: {'Authorization': 'Bearer ${session.accessToken}'},
      );
      if (response.isSuccessful && response.body != null) {
        return response.body as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('Error in getAPIInfo: $e');
      return null;
    }
  }

  Future<List<int>> getAccountIds(int userId) async {
    try {
      final response = await _api.client.get(
        Uri.parse('/api/v1/get_id'),
        parameters: {'userId': userId.toString()},
      );
      if (response.isSuccessful && response.body != null) {
        final dynamic body = response.body;
        if (body is List) {
          return body.map((e) => int.tryParse(e.toString()) ?? 0).toList();
        } else if (body is String) {
          String cleanData = body.trim();
          if (cleanData.startsWith('[') && cleanData.endsWith(']')) {
            cleanData = cleanData.substring(1, cleanData.length - 1);
          }
          if (cleanData.isEmpty) return [];
          return cleanData
              .split(',')
              .map((e) => int.tryParse(e.trim()) ?? 0)
              .where((id) => id != 0)
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getAccountDetailsById(int userId) async {
    try {
      final response = await _api.client.get(
        Uri.parse('/api/v1/getbyid'),
        parameters: {'userId': userId.toString()},
      );

      if (response.isSuccessful && response.body != null) {
        final dynamic body = response.body;
        if (body is Map<String, dynamic>) {
          return body;
        } else if (body is List && body.isNotEmpty) {
          if (body[0] is Map<String, dynamic>) return body[0];
        }
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<List<int>> getStatus(int userId) async {
    try {
      final response = await _api.client.get(
        Uri.parse('/api/v1/getStatus'),
        parameters: {'userId': userId.toString()},
      );

      if (response.isSuccessful && response.body != null) {
        final dynamic body = response.body;
        if (body is List) {
          return body.map((e) => int.tryParse(e.toString()) ?? 0).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<UserStatusDto>> getStatusByIds(List<int> userIds) async {
    try {
      final response = await _api.client.get(
        Uri.parse('/api/v1/getStatusbyID'),
        parameters: {'userId': userIds},
      );

      if (response.isSuccessful && response.body != null) {
        final dynamic body = response.body;
        if (body is List) {
          return body.map((item) {
            final map = item as Map<String, dynamic>;
            return UserStatusDto(
              userId: map['userId'] ?? 0,
              status: map['status'] ?? 'Offline',
            );
          }).toList();
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('Error in getStatusByIds: $e');
      return [];
    }
  }

  Future<bool> deleteFollowAccount(int userId) async {
    try {
      final response = await _api.apiV1FollowUserIdDelete(userId: userId);
      return response.isSuccessful && response.body?.success == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteSourceAccount(int userId) async {
    try {
      final response = await _api.apiV1SourceUserIdDelete(userId: userId);
      return response.isSuccessful && response.body?.success == true;
    } catch (e) {
      return false;
    }
  }

  Future<List<int>> getSlaveAccountIds(int userId) async {
    try {
      final response = await _api.client.get(
        Uri.parse('/api/v1/get_id_slave?userId=$userId'),
      );
      
      if (response.isSuccessful && response.body != null) {
        final dynamic body = response.body;
        if (body is List) {
          return body.map((e) => int.tryParse(e.toString()) ?? 0).toList();
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('Error fetching slave IDs: $e');
      return [];
    }
  }

  Future<List<Account>> syncAccountsWithServer() async {
    try {
      // 1. FETCH FROM CLOUD (Primary Source)
      final cloudAccounts = await fetchAccountsFromCloud();

      // 2. FETCH ALL IDS FROM TRADING SERVER
      final dataMap = await getAPIInfo();
      final List<int> serverIds = (dataMap != null && dataMap['accounts'] is List)
          ? (dataMap['accounts'] as List).map((e) => int.tryParse(e.toString()) ?? 0).toList()
          : [];

      // 3. GET STATUSES
      final List<int> idsToCheck = {
        ...serverIds,
        ...cloudAccounts.map((a) =>
            int.tryParse(a['server_id'] ?? a['login_number'] ?? '') ?? 0)
      }.where((id) => id != 0).toSet().toList();
      final statuses = idsToCheck.isNotEmpty ? await getStatusByIds(idsToCheck) : [];

      final List<Account> synchedAccounts = [];
      final Set<String> linkedServerIds = {};

      // 4. PROCESS CLOUD ACCOUNTS FIRST (Ensures Names/Platforms are correct)
      for (final cloudAcc in cloudAccounts) {
        final login = cloudAcc['login_number'].toString();
        var serverId = cloudAcc['server_id']?.toString();

        // AUTO-LINK: If server has an ID that we don't recognize yet, link it to this cloud account
        if (serverId == null || serverId == login) {
          final newServerId = serverIds.firstWhere(
            (sId) => sId.toString() != login && !cloudAccounts.any((a) => a['server_id'] == sId.toString()),
            orElse: () => 0,
          );
          if (newServerId != 0) {
            serverId = newServerId.toString();
            await updateServerIdInCloud(login, serverId);
            if (kDebugMode) print('DEBUG: Linked $login to new Server ID $serverId');
          }
        }

        if (serverId != null) linkedServerIds.add(serverId);
        linkedServerIds.add(login);

        final statusDto = statuses.firstWhere(
          (s) => s.userId.toString() == serverId || s.userId.toString() == login,
          orElse: () => UserStatusDto(userId: 0, status: 'Offline'),
        );

        synchedAccounts.add(Account(
          serverId: int.tryParse(serverId ?? login) ?? 0,
          loginNumber: login,
          accountName: (cloudAcc['account_name'] ?? '').toString(),
          accountType: AccountType.parse(cloudAcc['account_type']),
          platform: Platform.parse(cloudAcc['platform']),
          status: statusDto.status ?? 'Offline',
          masterId: int.tryParse((cloudAcc['master_id'] ?? '').toString()),
        ));
      }

      // 5. ADD UNRECOGNIZED SERVER ACCOUNTS (Fallback)
      // NOTE: heuristic — we have no metadata for server-only IDs, so we
      // guess type/platform from the ID prefix. This is wrong for many
      // brokers; once an account is registered through this app, the
      // cloud row in step 4 overrides this guess.
      for (final sId in serverIds) {
        if (linkedServerIds.contains(sId.toString())) continue;

        final statusDto = statuses.firstWhere(
          (s) => s.userId == sId,
          orElse: () => UserStatusDto(userId: 0, status: 'Offline'),
        );
        final guessedType = sId.toString().startsWith('5')
            ? AccountType.slave
            : AccountType.master;
        final guessedPlatform = sId.toString().startsWith('5')
            ? Platform.mt5
            : Platform.mt4;

        synchedAccounts.add(Account(
          serverId: sId,
          loginNumber: sId.toString(),
          accountName: 'Account $sId',
          accountType: guessedType,
          platform: guessedPlatform,
          status: statusDto.status ?? 'Offline',
        ));
      }

      if (kDebugMode) {
        print('\n--- [DASHBOARD TABLE DATA FROM CLOUD + SERVER] ---');
        for (final acc in synchedAccounts) {
          print('Row -> ID: ${acc.serverId}, Name: ${acc.accountName}, Login: ${acc.loginNumber}, Platform: ${acc.platform.wireValue}, Type: ${acc.accountType.wireValue}');
        }
        print('--------------------------------------------------\n');
      }

      return synchedAccounts;
    } catch (e) {
      if (kDebugMode) print('Cloud Sync error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getDashboardMetrics() async {
    int totalAccounts = 0;
    String limit = '--';
    try {
      final dataMap = await getAPIInfo();
      if (dataMap != null) {
        totalAccounts = dataMap['usedAccountCount'] ?? 0;
        limit = (dataMap['accountLimit'] ?? '--').toString();
      }
    } catch (e) {
      if (kDebugMode) print('getDashboardMetrics error: $e');
    }
    return {
      'totalAccounts': totalAccounts,
      'accountLimit': limit,
      'activeTrades': 0,
      'dailyProfit': 0.0,
    };
  }

  // --- Phase B read paths: open orders, history, symbols ---
  //
  // The Chopper-generated methods for these endpoints declare return type
  // `Response<StringResponseDto>`, but the live server returns a raw JSON
  // array (the OpenAPI spec is wrong). So we use raw `_api.client.get/post`
  // and parse the body ourselves.

  /// Fetch all currently-open orders/positions for [account].
  /// Returns an empty list if the platform isn't supported or the call fails.
  Future<List<TradeOrder>> getOpenOrders({required Account account}) async {
    switch (account.platform) {
      case Platform.mt5:
        return _fetchOrders('/api/v1/get_orders_mt5', account);
      case Platform.mt4:
        return _fetchOrders('/api/v1/get_orders_mt4', account);
      default:
        // Other platforms ship in later sub-PRs (cTrader, DxTrade, ...).
        return [];
    }
  }

  /// Fetch closed-order history for [account] within `[from, to]`.
  /// History responses include non-trade Balance entries — pass
  /// `tradesOnly: true` to filter them out.
  Future<List<TradeOrder>> getOrderHistory({
    required Account account,
    required DateTime from,
    required DateTime to,
    bool tradesOnly = false,
  }) async {
    final fromStr = _ymd(from);
    final toStr = _ymd(to);
    List<TradeOrder> orders;
    switch (account.platform) {
      case Platform.mt5:
        orders = await _fetchOrderHistory('/api/v1/get_order_history_mt5', account, fromStr, toStr);
        break;
      case Platform.mt4:
        orders = await _fetchOrderHistory('/api/v1/get_order_history_mt4', account, fromStr, toStr);
        break;
      default:
        return [];
    }
    if (tradesOnly) {
      orders = orders.where((o) => !o.isBalanceEntry).toList();
    }
    return orders;
  }

  /// Full list of tradable symbols available to [account] on its broker.
  /// Response can be ~5KB+ so callers should cache.
  Future<List<String>> getAllSymbols({required Account account}) async {
    final status = account.isMaster ? 0 : 1;
    Uri uri;
    switch (account.platform) {
      case Platform.mt5:
        uri = Uri.parse('/api/v1/getAllSymbol/MT5/${account.serverId}?accountStatus=$status');
        break;
      case Platform.mt4:
        uri = Uri.parse('/api/v1/getAllSymbol/MT4/${account.serverId}?accountStatus=$status');
        break;
      default:
        return [];
    }
    try {
      final response = await _api.client.get(uri);
      if (response.isSuccessful && response.body is List) {
        return (response.body as List).map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('getAllSymbols error: $e');
      return [];
    }
  }

  // --- Internal helpers for the read endpoints ---

  Future<List<TradeOrder>> _fetchOrders(String path, Account account) async {
    final status = account.isMaster ? 0 : 1;
    try {
      final response = await _api.client.post(
        Uri.parse(path),
        parameters: {'accountStatus': status, 'userId': account.serverId},
      );
      return _parseOrderListBody(response.body);
    } catch (e) {
      if (kDebugMode) print('getOpenOrders error ($path): $e');
      return [];
    }
  }

  Future<List<TradeOrder>> _fetchOrderHistory(
    String path,
    Account account,
    String from,
    String to,
  ) async {
    final status = account.isMaster ? 0 : 1;
    try {
      final response = await _api.client.post(
        Uri.parse(path),
        parameters: {
          'accountStatus': status,
          'id': account.serverId,
          'from': from,
          'to': to,
        },
      );
      return _parseOrderListBody(response.body);
    } catch (e) {
      if (kDebugMode) print('getOrderHistory error ($path): $e');
      return [];
    }
  }

  /// The server can return either a raw JSON array or a JSON string
  /// containing an array (sometimes with a leading error like "Master
  /// account not found"). Be tolerant.
  List<TradeOrder> _parseOrderListBody(dynamic body) {
    if (body == null) return [];
    if (body is List) {
      return body
          .whereType<Map>()
          .map((m) => TradeOrder.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    }
    if (body is String) {
      final s = body.trim();
      if (!s.startsWith('[')) return [];
      try {
        final decoded = jsonDecode(s);
        if (decoded is List) {
          return decoded
              .whereType<Map>()
              .map((m) => TradeOrder.fromMap(Map<String, dynamic>.from(m)))
              .toList();
        }
      } catch (_) {}
    }
    return [];
  }

  /// Format DateTime as `yyyy-MM-dd` for the history endpoint.
  String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<Map<String, dynamic>> updateTradingAccount({
    required int userId,
    required String platformType,
    String? password,
    String? server,
    String? comment,
    bool isMaster = true,
    int? masterId,
    // Additional fields for other platforms
    String? clientId,
    String? clientSecret,
    String? refreshToken,
    String? expireIn,
    String? email,
    String? accountName,
    String? userName,
    String? brokerId,
  }) async {
    try {
      Response<StringResponseDto> response;
      final platform = platformType.toUpperCase();

      switch (platform) {
        case 'MT4':
          if (isMaster) {
            response = await _api.apiV1UpdateMasterMt4Post(
              userId: userId,
              password: password,
              server: server,
              comment: accountName ?? comment,
            );
          } else {
            response = await _api.apiV1UpdateSlaveMt4Post(
              userId: userId,
              password: password,
              server: server,
              comment: accountName ?? comment,
            );
          }
          break;

        case 'MT5':
          if (isMaster) {
            response = await _api.apiV1UpdateMasterMt5Post(
              userId: userId,
              password: password,
              server: server,
              comment: accountName ?? comment,
            );
          } else {
            response = await _api.apiV1UpdateSlaveMt5Post(
              userId: userId,
              password: password,
              server: server,
              comment: accountName ?? comment,
            );
          }
          break;

        case 'CTRADER':
          if (isMaster) {
            response = await _api.apiV1UpdateMasterCtraderPost(
              userId: userId,
              refreshToken: refreshToken ?? '',
              expireIn: int.tryParse(expireIn ?? '0'),
              comment: comment,
            );
          } else {
            response = await _api.apiV1UpdateSlaveCtraderPost(
              userId: userId,
              refreshToken: refreshToken ?? '',
              expireIn: int.tryParse(expireIn ?? '0'),
              comment: comment,
            );
          }
          break;

        case 'DXTRADE':
          if (isMaster) {
            response = await _api.apiV1UpdateMasterDxtradePost(
              userId: userId,
              password: password,
              server: server,
              comment: comment,
            );
          } else {
            response = await _api.apiV1UpdateSlaveDxtradePost(
              userId: userId,
              password: password,
              server: server,
              comment: comment,
            );
          }
          break;

        case 'TRADELOCKER':
          if (isMaster) {
            response = await _api.apiV1UpdateMasterTradeLockerPost(
              userId: userId,
              password: password,
              server: server,
              comment: comment,
            );
          } else {
            response = await _api.apiV1UpdateSlaveTradeLockerPost(
              userId: userId,
              password: password,
              server: server,
              comment: comment,
            );
          }
          break;

        case 'MATCHTRADE':
          if (isMaster) {
            response = await _api.apiV1UpdateMasterMatchTradePost(
              userId: userId,
              password: password,
              server: server,
              comment: comment,
            );
          } else {
            response = await _api.apiV1UpdateSlaveMatchTradePost(
              userId: userId,
              password: password,
              server: server,
              comment: comment,
            );
          }
          break;

        default:
          return {'message': 'Unsupported platform: $platformType', 'success': false};
      }

      if (response.isSuccessful) {
        return {
          'message': response.body?.message ?? 'Update successful',
          'success': true,
        };
      } else {
        return {
          'message': 'Update failed: ${response.error ?? response.base.reasonPhrase}',
          'success': false,
        };
      }
    } catch (e) {
      return {'message': 'An error occurred: $e', 'success': false};
    }
  }

  Future<String> deleteTradingAccount({
    required int userId, // This is the ID displayed in the 'Account ID' column
    bool isMaster = true,
    String? platform,
    String? loginNumber, // Added backup login number
  }) async {
    try {
      if (kDebugMode) print('API: Attempting to delete account $userId (isMaster: $isMaster)');

      // Build the list of (id, role) attempts. We try both roles for each ID
      // so a delete cannot get stuck just because the UI label was wrong
      // (e.g. sync race or stale heuristic). First success wins.
      final ids = <int>[userId];
      final backupId = int.tryParse(loginNumber ?? '') ?? 0;
      if (backupId != 0 && backupId != userId) ids.add(backupId);
      final roles = <bool>[isMaster, !isMaster];

      Response<BooleanResponseDto>? lastResponse;
      for (final id in ids) {
        for (final asMaster in roles) {
          final response = asMaster
              ? await _api.apiV1SourceUserIdDelete(userId: id)
              : await _api.apiV1FollowUserIdDelete(userId: id);
          lastResponse = response;

          if (response.isSuccessful) {
            final success = response.body?.success;
            final message = response.body?.message?.toLowerCase() ?? '';
            if (success == true || message.contains('success')) {
              if (kDebugMode) {
                print('API: Delete succeeded with id=$id asMaster=$asMaster');
              }
              await deleteAccountFromCloud(loginNumber ?? userId.toString());
              // Defensive: also drop any cloud row keyed by server_id
              await _supabase
                  .from('trading_accounts')
                  .delete()
                  .eq('server_id', userId.toString());
              return 'Account deleted successfully from Server and Cloud';
            }
          }
          if (kDebugMode) {
            print('API: Delete attempt failed (id=$id asMaster=$asMaster, status=${response.statusCode})');
          }
        }
      }

      // All attempts exhausted: format the last failure for the user.
      final r = lastResponse!;
      final errorBody = r.error;
      String errorMessage = 'Delete failed';
      if (errorBody is Map) {
        errorMessage = errorBody['message'] ?? errorBody['status'] ?? errorMessage;
      } else if (errorBody is String) {
        try {
          final Map parsed = jsonDecode(errorBody);
          errorMessage = parsed['message'] ?? parsed['status'] ?? errorMessage;
        } catch (e) {
          errorMessage = errorBody;
        }
      } else {
        errorMessage = r.body?.message ?? r.base.reasonPhrase ?? errorMessage;
      }
      return '$errorMessage (Code: ${r.statusCode})';
    } catch (e) {
      return 'An error occurred: $e';
    }
  }
}