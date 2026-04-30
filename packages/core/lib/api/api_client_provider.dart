import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'generated/api.swagger.dart';
import '../interceptors/supabase_auth_interceptor.dart';
import '../repositories/trading_repository.dart';
import '../repositories/auth_repository.dart';

class ApiClientProvider {
  /// All trading-API calls flow through the Supabase Edge Function
  /// `trading-proxy`. The function holds the trading API key
  /// server-side, so the Flutter bundle no longer ships the key.
  ///
  /// Auth: SupabaseAuthInterceptor adds `Authorization: Bearer <jwt>`
  /// from the current Supabase Auth session on every Chopper request.
  /// The proxy rejects anon callers with 401.
  static List<SingleChildWidget> providers = [
    Provider<Api>(
      create: (_) => Api.create(
        baseUrl: Uri.parse(
          '${const String.fromEnvironment('SUPABASE_URL')}'
          '/functions/v1/trading-proxy',
        ),
        interceptors: [
          SupabaseAuthInterceptor(),
          if (kDebugMode) HttpLoggingInterceptor(),
        ],
      ),
      dispose: (_, Api client) => client.client.dispose(),
    ),

    ProxyProvider<Api, TradingRepository>(
      update: (_, api, __) => TradingRepository(api),
    ),

    Provider<AuthRepository>(
      create: (_) => AuthRepository(),
    ),
  ];
}
