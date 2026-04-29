import 'dart:async';
import 'package:chopper/chopper.dart';

class ApiKeyInterceptor implements RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    // Reads API Key from environment variable (--dart-define=API_KEY=your_key)
    const apiKey = String.fromEnvironment('API_KEY');
    
    if (apiKey.isNotEmpty) {
      return request.copyWith(headers: {
        ...request.headers,
        'X-API-KEY': apiKey,
      });
    }
    
    return request;
  }
}
