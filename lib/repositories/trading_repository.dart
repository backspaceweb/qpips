import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/api/generated/api.swagger.dart';

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
      print('SUPABASE_SAVE_START: Saving $accountName ($loginNumber)...');
      await _supabase.from('trading_accounts').upsert({
        'account_name': accountName,
        'login_number': loginNumber,
        'platform': platform,
        'account_type': accountType,
        'server_id': serverId,
        'master_id': masterId,
      }, onConflict: 'login_number');
      print('SUPABASE_SAVE_SUCCESS: Account $accountName is now in the cloud.');
    } catch (e) {
      print('SUPABASE_SAVE_CRITICAL_ERROR: $e');
      // Fallback: try simple insert if upsert fails
      try {
        print('SUPABASE_SAVE_FALLBACK: Attempting simple insert...');
        await _supabase.from('trading_accounts').insert({
          'account_name': accountName,
          'login_number': loginNumber,
          'platform': platform,
          'account_type': accountType,
          'server_id': serverId,
          'master_id': masterId,
        });
        print('SUPABASE_SAVE_FALLBACK_SUCCESS: Saved via insert.');
      } catch (e2) {
        print('SUPABASE_SAVE_TOTAL_FAILURE: $e2');
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchAccountsFromCloud() async {
    try {
      print('Supabase: Fetching accounts from cloud...');
      final response = await _supabase.from('trading_accounts').select('*');
      print('Supabase: Fetched ${response.length} accounts.');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Supabase Error (fetch): $e');
      return [];
    }
  }

  Future<void> deleteAccountFromCloud(String loginNumber) async {
    try {
      await _supabase.from('trading_accounts').delete().eq('login_number', loginNumber);
      print('Cloud: Account $loginNumber deleted successfully.');
    } catch (e) {
      print('Cloud Error: Failed to delete account: $e');
    }
  }

  Future<void> updateServerIdInCloud(String loginNumber, String serverId) async {
    try {
      await _supabase.from('trading_accounts').update({'server_id': serverId}).eq('login_number', loginNumber);
      print('Cloud: Linked Server ID $serverId to Login $loginNumber');
    } catch (e) {
      print('Cloud Error: Failed to update Server ID: $e');
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
      print('Error toggling account activation: $e');
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
      print('Error fetching MT5 risk settings: $e');
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
      print('Error updating MT5 risk settings: $e');
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
      print('DEBUG: registerTradingAccount start: userId=$userId, platform=$platformType, isMaster=$isMaster');
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

      print('DEBUG: registerTradingAccount response status: ${response.statusCode}');
      if (response.isSuccessful) {
        print('DEBUG: registerTradingAccount success: ${response.body?.message}');
        return {
          'message': response.body?.message ?? 'Registration successful',
          'id': response.body?.data?.toString(),
          'success': true,
        };
      } else {
        final error = response.error;
        print('DEBUG: registerTradingAccount failure: $error');
        return {
          'message': 'Registration failed: ${error ?? response.base.reasonPhrase}',
          'success': false,
        };
      }
    } catch (e, stack) {
      print('DEBUG: registerTradingAccount error: $e');
      print('DEBUG: stack trace: $stack');
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
      
      print('DEBUG: registerTradingAccount successful. ID assigned: $serverId');
      
      // AUTO-SAVE TO SUPABASE WITH EXPLICIT ERROR CATCHING
      try {
        print('DEBUG: Initiating Cloud Save for $accountName...');
        await saveAccountToCloud(
          accountName: accountName,
          loginNumber: userId.toString(),
          platform: platformType,
          accountType: isMaster ? 'Master' : 'Slave',
          serverId: serverId,
          masterId: masterId?.toString(),
        );
        print('DEBUG: Cloud Save process finished.');
      } catch (cloudErr) {
        print('DEBUG: CRITICAL CLOUD SAVE FAILURE: $cloudErr');
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

  Future<List<Map<String, dynamic>>> fetchUserAccounts(List<int> userIds, {Map<String, dynamic>? metadata}) async {
    try {
      if (userIds.isEmpty) return [];
      
      final response = await _api.apiV1GetStatusbyIDGet(userId: userIds);
      if (response.isSuccessful && response.body != null) {
        return response.body!.map((status) {
          final id = status.userId.toString();
          var m = metadata?[id];

          // --- DEEP BRIDGE FIX ---
          if (m == null && metadata != null) {
            try {
              m = metadata[id] ?? metadata.values.firstWhere(
                (entry) => entry['accountNumber']?.toString() == id && id.isNotEmpty,
                orElse: () => null,
              );
            } catch (e) {}
          }
          // ------------------
          
          return {
            'id': id,
            'accountName': m?['accountName'] ?? 'Slave',
            'accountNumber': m?['accountNumber'] ?? id,
            'accountType': m?['accountType'] ?? (id.startsWith('5') ? 'Slave' : 'Master'),
            'platform': m?['platform'] ?? (id.startsWith('5') ? 'MT5' : 'MT4'),
            'status': status.status ?? 'Offline',
          };
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getAPIInfo(String key) async {
    try {
      final response = await _api.client.get(
        Uri.parse('/api/v1/getAPIInfo'),
        parameters: {'key': key},
      );
      if (response.isSuccessful && response.body != null) {
        return response.body as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error in getAPIInfo: $e');
      return null;
    }
  }

  Future<List<int>> getAccountIds(int userId) async {
    try {
      const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
      final response = await _api.client.get(
        Uri.parse('/api/v1/get_id'),
        parameters: {
          'userId': userId.toString(),
          'key': apiKey,
        },
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
      const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
      final response = await _api.client.get(
        Uri.parse('/api/v1/getbyid'),
        parameters: {
          'userId': userId.toString(),
          'key': apiKey,
        },
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
      const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
      final response = await _api.client.get(
        Uri.parse('/api/v1/getStatus'),
        parameters: {
          'userId': userId.toString(),
          'key': apiKey,
        },
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
      const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
      
      final response = await _api.client.get(
        Uri.parse('/api/v1/getStatusbyID'),
        parameters: {
          'userId': userIds,
          'key': apiKey,
        },
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
      print('Error in getStatusByIds: $e');
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
      print('Error fetching slave IDs: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> syncAccountsWithServer() async {
    try {
      const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
      
      // 1. FETCH FROM CLOUD (Primary Source)
      final cloudAccounts = await fetchAccountsFromCloud();
      
      // 2. FETCH ALL IDS FROM TRADING SERVER
      final dataMap = await getAPIInfo(apiKey);
      final List<int> serverIds = (dataMap != null && dataMap['accounts'] is List)
          ? (dataMap['accounts'] as List).map((e) => int.tryParse(e.toString()) ?? 0).toList()
          : [];

      // 3. GET STATUSES
      final List<int> idsToCheck = {...serverIds, ...cloudAccounts.map((a) => int.tryParse(a['server_id'] ?? a['login_number'] ?? '') ?? 0)}
          .where((id) => id != 0).toSet().toList();
      final statuses = idsToCheck.isNotEmpty ? await getStatusByIds(idsToCheck) : [];

      final List<Map<String, dynamic>> synchedAccounts = [];
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
             print('DEBUG: Linked $login to new Server ID $serverId');
           }
        }

        if (serverId != null) linkedServerIds.add(serverId);
        linkedServerIds.add(login);

        final statusDto = statuses.firstWhere(
          (s) => s.userId.toString() == serverId || s.userId.toString() == login,
          orElse: () => UserStatusDto(userId: 0, status: 'Offline'),
        );

        synchedAccounts.add({
          'id': serverId ?? login,
          'accountName': cloudAcc['account_name'],
          'accountNumber': login,
          'accountType': cloudAcc['account_type'],
          'platform': cloudAcc['platform'],
          'status': statusDto.status ?? 'Offline',
          'balance': '0.00',
          'equity': '0.00',
        });
      }

      // 5. ADD UNRECOGNIZED SERVER ACCOUNTS (Fallback)
      for (final sId in serverIds) {
        if (linkedServerIds.contains(sId.toString())) continue;
        
        final statusDto = statuses.firstWhere((s) => s.userId == sId, orElse: () => UserStatusDto(userId: 0, status: 'Offline'));
        synchedAccounts.add({
          'id': sId.toString(),
          'accountName': 'Account $sId',
          'accountNumber': sId.toString(),
          'accountType': sId.toString().startsWith('5') ? 'Slave' : 'Master',
          'platform': sId.toString().startsWith('5') ? 'MT5' : 'MT4',
          'status': statusDto.status ?? 'Offline',
          'balance': '0.00',
          'equity': '0.00',
        });
      }

      print('\n--- [DASHBOARD TABLE DATA FROM CLOUD + SERVER] ---');
      for (var acc in synchedAccounts) {
        print('Row -> ID: ${acc['id']}, Name: ${acc['accountName']}, Login: ${acc['accountNumber']}, Platform: ${acc['platform']}, Type: ${acc['accountType']}');
      }
      print('--------------------------------------------------\n');

      return synchedAccounts;
    } catch (e) {
      print('Cloud Sync error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getDashboardMetrics() async {
    int totalAccounts = 0;
    String limit = '--';
    try {
      const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
      if (apiKey.isNotEmpty) {
        final dataMap = await getAPIInfo(apiKey);
        if (dataMap != null) {
          totalAccounts = dataMap['usedAccountCount'] ?? 0;
          limit = (dataMap['accountLimit'] ?? '--').toString();
        }
      }
    } catch (e) {}
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
      print('API: Attempting to delete account $userId (isMaster: $isMaster)');
      Response<BooleanResponseDto> response;
      
      // Attempt 1: Using the primary ID (Server ID)
      if (isMaster) {
        response = await _api.apiV1SourceUserIdDelete(userId: userId);
      } else {
        response = await _api.apiV1FollowUserIdDelete(userId: userId);
      }

      // Attempt 2: If primary ID fails (404), try using the Login Number
      if (!response.isSuccessful && loginNumber != null) {
        final backupId = int.tryParse(loginNumber) ?? 0;
        if (backupId != 0 && backupId != userId) {
           print('API: Primary delete failed, trying backup Login Number: $backupId');
           if (isMaster) {
             response = await _api.apiV1SourceUserIdDelete(userId: backupId);
           } else {
             response = await _api.apiV1FollowUserIdDelete(userId: backupId);
           }
        }
      }

      if (response.isSuccessful) {
        final success = response.body?.success;
        final message = response.body?.message?.toLowerCase() ?? '';
        if (success == true || message.contains('success')) {
          // SYNC SUCCESS: Now remove from Supabase
          await deleteAccountFromCloud(loginNumber ?? userId.toString());
          // Also try removing by server_id just in case
          await _supabase.from('trading_accounts').delete().eq('server_id', userId.toString());
          
          return 'Account deleted successfully from Server and Cloud';
        } else {
          return 'Delete failed: ${response.body?.message ?? response.base.reasonPhrase}';
        }
      } else {
        final errorBody = response.error;
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
        }
        return '$errorMessage (Code: ${response.statusCode})';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }
}