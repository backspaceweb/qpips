import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repositories/trading_repository.dart';
import '../../../repositories/auth_repository.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _serverController = TextEditingController();
  final _emailController = TextEditingController();
  final _accountNameController = TextEditingController();
  
  String _platformType = 'MT4';
  bool _isLoading = false;
  bool _isLoginMode = true;

  Future<void> _handleAction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String message;
    bool isSuccess = false;
    String? apiId;
    int? userId;
    
    if (_isLoginMode) {
      final authRepo = context.read<AuthRepository>();
      final resultStr = await authRepo.login(_emailController.text, _passwordController.text);
      message = resultStr;
      isSuccess = resultStr.contains('successful');
    } else {
      final tradingRepo = context.read<TradingRepository>();
      userId = int.parse(_userIdController.text);
      final result = await tradingRepo.registerTradingAccount(
        userId: userId,
        password: _passwordController.text,
        server: _serverController.text,
        platformType: _platformType,
        accountName: _accountNameController.text,
      );
      message = result['message'];
      isSuccess = result['success'] == true;
      apiId = result['id'];
    }

    if (mounted) {
      setState(() => _isLoading = false);
      String snackMessage = message;
      if (isSuccess) {
        final prefs = await SharedPreferences.getInstance();
        if (_isLoginMode) {
          await prefs.setBool('isLoggedIn', true);
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          }
        } else if (userId != null) {
          // Use API ID if provided, fallback to userId
          final storedId = apiId ?? userId.toString();

          final List<String> savedIds = prefs.getStringList('registeredUserIds') ?? [];
          if (!savedIds.contains(storedId)) {
            savedIds.add(storedId);
            await prefs.setStringList('registeredUserIds', savedIds);
          }

          final String? metadataJson = prefs.getString('accountMetadata');
          Map<String, dynamic> metadata = {};
          if (metadataJson != null) {
            try { metadata = jsonDecode(metadataJson); } catch (e) {}
          }
          metadata[storedId] = {
            'id': storedId,
            'platform': _platformType,
            'accountType': 'Master',
            'accountNumber': userId.toString(),
            'accountName': _accountNameController.text.isNotEmpty ? _accountNameController.text : userId.toString(),
          };
          await prefs.setString('accountMetadata', jsonEncode(metadata));

          // Registration creates a trading account on the server, but does NOT
          // authenticate the user. Drop them back to the login form so /dashboard
          // is only reachable through a successful login.
          if (mounted) {
            setState(() {
              _isLoginMode = true;
              _passwordController.clear();
              _userIdController.clear();
              _serverController.clear();
              _accountNameController.clear();
            });
          }
          snackMessage = 'Account registered. Please log in to continue.';
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackMessage),
            backgroundColor: isSuccess ? Colors.green : Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'QuantumPips',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Super Admin Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (_isLoginMode) ...[
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      isDark: isDark,
                    ),
                  ] else ...[
                    _buildTextField(
                      controller: _accountNameController,
                      label: 'Account Name',
                      icon: Icons.label_outline,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _userIdController,
                      label: 'User ID',
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _serverController,
                      label: 'Server',
                      icon: Icons.dns_outlined,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(isDark),
                  ],
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _isLoginMode ? 'Login' : 'Register Account',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                  // Public Sign-Up toggle removed: this screen is super-admin
                  // login only. Admin/account onboarding will live inside the
                  // dashboard once the in-app admin flow is built.
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1), size: 20),
        filled: true,
        fillColor: isDark ? const Color(0xFF0F172A).withOpacity(0.5) : const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A).withOpacity(0.5) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _platformType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6366F1)),
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16),
          onChanged: (String? newValue) {
            if (newValue != null) setState(() => _platformType = newValue);
          },
          items: <String>['MT4', 'MT5'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}