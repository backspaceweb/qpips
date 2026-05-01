import 'package:supabase_flutter/supabase_flutter.dart';

/// Outcome of [AuthRepository.signUp]. Three possibilities:
///   - [signedIn] — Supabase auto-confirmed; trader is logged in.
///   - [checkEmail] — confirmation email sent; trader must click the
///     link before they can sign in.
///   - [error] — sign-up rejected (already-registered, weak password,
///     network failure, etc.); [errorMessage] is human-readable.
class SignUpResult {
  final SignUpStatus status;
  final String? errorMessage;

  const SignUpResult._(this.status, [this.errorMessage]);
  const SignUpResult.signedIn() : this._(SignUpStatus.signedIn);
  const SignUpResult.checkEmail() : this._(SignUpStatus.checkEmail);
  const SignUpResult.error(String message)
      : this._(SignUpStatus.error, message);

  bool get isError => status == SignUpStatus.error;
}

enum SignUpStatus { signedIn, checkEmail, error }

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

  /// Creates a new trader account via Supabase Auth.
  ///
  /// `username` is forwarded as auth metadata; the
  /// `handle_new_user` trigger reads it and seeds
  /// `profiles.display_name` so admin views surface it instead of the
  /// email. Returns a [SignUpResult] describing what to do next: with
  /// email confirmation enabled (recommended for production), the
  /// returned session is null and the trader must click the link in
  /// their inbox before logging in.
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      return const SignUpResult.error(
        'Email, username, and password are all required.',
      );
    }
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      if (response.user == null) {
        return const SignUpResult.error(
          'Sign-up failed: no user returned.',
        );
      }
      // Session non-null = Supabase has email confirmation disabled
      // and the trader is logged in immediately. Session null = email
      // confirmation required.
      return response.session != null
          ? const SignUpResult.signedIn()
          : const SignUpResult.checkEmail();
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('already registered') ||
          msg.contains('already exists') ||
          msg.contains('user already registered')) {
        return const SignUpResult.error(
          'That email is already registered. Try logging in instead.',
        );
      }
      if (msg.contains('weak password') || msg.contains('password should')) {
        return SignUpResult.error('Password too weak: ${e.message}');
      }
      return SignUpResult.error('Sign-up failed: ${e.message}');
    } catch (e) {
      return SignUpResult.error('Sign-up failed: $e');
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Session? get currentSession => _supabase.auth.currentSession;
  bool get isLoggedIn => currentSession != null;

  /// Calls the SQL `is_admin()` helper. Returns false on any error
  /// (no session, RPC missing, network error) so callers can fail
  /// closed without try/catching.
  Future<bool> isCurrentUserAdmin() async {
    if (currentSession == null) return false;
    try {
      final result = await _supabase.rpc('is_admin');
      return result == true;
    } catch (_) {
      return false;
    }
  }
}
