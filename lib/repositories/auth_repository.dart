import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Email and password are required';
    }
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session == null) {
        return 'Login failed: no session returned';
      }
      return 'Login successful';
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials') ||
          msg.contains('invalid email or password')) {
        return 'Invalid email or password';
      }
      if (msg.contains('email not confirmed')) {
        return 'Email not confirmed. Open this user in Supabase Dashboard → Authentication → Users and toggle "Auto Confirm" on.';
      }
      return 'Login failed: ${e.message}';
    } catch (e) {
      return 'Login failed: $e';
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Session? get currentSession => _supabase.auth.currentSession;
  bool get isLoggedIn => currentSession != null;
}
