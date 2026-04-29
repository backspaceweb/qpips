import '../core/api/generated/api.swagger.dart';

class AuthRepository {
  // ignore: unused_field
  final Api _api;

  AuthRepository(this._api);

  // TODO(auth): Replace with Supabase Auth `signInWithPassword` before any
  // production deployment. This is a permissive mock retained for one more
  // dev cycle while the Supabase Auth flow is built out.
  // See: https://supabase.com/docs/reference/dart/auth-signinwithpassword
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.isEmpty || password.isEmpty) {
      return "Email and password are required";
    }
    return "Login successful";
  }
}