import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'generated/api.swagger.dart';
import '../interceptors/api_key_interceptor.dart';
import '../../repositories/trading_repository.dart';
import '../../repositories/auth_repository.dart';

class ApiClientProvider {
  // TODO(server): Trading server currently HTTP-only on port 3310.
  // Ask API team to expose HTTPS + cert for this host before production.
  static List<SingleChildWidget> providers = [
    Provider<Api>(
      create: (_) => Api.create(
        baseUrl: Uri.parse('http://us-2-server.tradecopy.online:3310'),
        interceptors: [
          ApiKeyInterceptor(),
          if (kDebugMode) HttpLoggingInterceptor(),
        ],
      ),
      dispose: (_, Api client) => client.client.dispose(),
    ),
    
    ProxyProvider<Api, TradingRepository>(
      update: (_, api, __) => TradingRepository(api),
    ),

    ProxyProvider<Api, AuthRepository>(
      update: (_, api, __) => AuthRepository(api),
    ),
  ];
}