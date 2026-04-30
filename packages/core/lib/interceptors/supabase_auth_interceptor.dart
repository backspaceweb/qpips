import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Adds `Authorization: Bearer <session.accessToken>` to every Chopper
/// request, sourced from the active Supabase Auth session.
///
/// Phase C wires the Chopper `Api` base URL to the Supabase Edge Function
/// `trading-proxy`. The proxy verifies the JWT server-side and rejects
/// anon callers, so this interceptor is the gate that ties admin-panel
/// API access to a logged-in Supabase user.
///
/// If there's no current session, the request is sent without the
/// header and the proxy will reject it with 401. We don't proactively
/// fail here — the route guard at app startup already redirects
/// unauthenticated users back to the login screen.
class SupabaseAuthInterceptor implements RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) return request;
    return request.copyWith(headers: {
      ...request.headers,
      'Authorization': 'Bearer ${session.accessToken}',
    });
  }
}
