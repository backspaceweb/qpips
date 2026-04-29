import 'package:chopper/chopper.dart';
import '../core/api/generated/api.swagger.dart';

class AuthRepository {
  final Api _api;

  AuthRepository(this._api);

  Future<String> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (email == "susanto@admin.com" && password == "1234") {
        return "Login successful";
      }
      return "Invalid email or password";
    } catch (e) {
      return "Login failed: $e";
    }
  }
}