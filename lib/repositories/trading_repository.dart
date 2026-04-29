import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/api/generated/api.swagger.dart';
import '../domain/account.dart';

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

  Future<bool> toggleAccountActivation({
    required int userId,
    required bool isMaster,
    required bool activate,
  }) async {
    try {
      Response<StringResponseDto> response;
      if (isMaster) {
        response = await _api.apiV1ActiveMasterMT5Post(
          id: userId,
          status: activate,
        );
      } else {
        response = await _api.apiV1ActiveSlaveMT5Post(
          id: userId,
          status: activate,
        );
      }
      return response.isSuccessful;
    } catch (e) {
      if (kDebugMode) print('Error toggling account activation: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getMT5RiskSettings(int userId) async {
    try {
      final riskResponse = await _api.apiV1Mt5GetRiskGet(userId: userId);
      final stopsResponse = await _api.apiV1Mt5GetStopsLimitsGet(userId: userId);

      return {
        'risk': riskResponse.isSuccessful ? riskResponse.body : null,
        'stops': stopsResponse.isSuccessful ? stopsResponse.body : null,
      };
    } catch (e) {
      if (kDebugMode) print('Error fetching MT5 risk settings: $e');
      return {'risk': null, 'stops': null};
    }
  }

  Future<bool> updateMT5RiskSettings({
    required int userId,
    required int riskType,
    required double multiplier,
    required bool copySLTP,
    required int scalperMode,
    required int orderFilter,
    required int scalperValue,
  }) async {
    try {
      // Risk Settings
      final riskResponse = await _api.apiV1Mt5UpdateRiskPost(
        userId: userId,
        riskType: ApiV1Mt5UpdateRiskPostRiskType.values[riskType],
        multiplier: multiplier,
      );

      // Stops/Limits Settings
      final stopsResponse = await _api.apiV1Mt5UpdateStopsLimitsPost(
        userId: userId,
        copySLTP: copySLTP,
        scalperMode: ApiV1Mt5UpdateStopsLimitsPostScalperMode.values[scalperMode],
        orderFilter: ApiV1Mt5UpdateStopsLimitsPostOrderFilter.values[orderFilter],
        scalperValue: scalperValue,
      );

      return riskResponse.isSuccessful && stopsResponse.isSuccessful;
    } catch (e) {
      if (kDebugMode) print('Error updating MT5 risk settings: $e');
      return false;
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

  // Auth note: ApiKeyInterceptor injects X-API-KEY header on every request
  // through `_api.client`. Most endpoints accept header-only auth.
  //
  // EXCEPTION: /api/v1/getAPIInfo rejects header-only with HTTP 400
  // ("The key field is required.") even though the OpenAPI spec advertises
  // the header-only ApiKey scheme. This is a server-side bug — TODO(server):
  // ask the API team to fix getAPIInfo to honor the documented auth scheme.
  // Until then we send the key as a query param for this one endpoint and
  // accept the URL-leak risk for this single call.
  Future<Map<String, dynamic>?> getAPIInfo() async {
    try {
      const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
      final response = await _api.client.get(
        Uri.parse('/api/v1/getAPIInfo'),
        parameters: {'key': apiKey},
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

  Future<Map<String, String>> getAccountDetails(int userId) async {
    return {
      'Account Number': userId.toString(),
      'Broker': 'Broker Name',
      'Leverage': '1:500',
      'Currency': 'USD',
    };
  }

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