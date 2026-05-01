import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/repositories/auth_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Trader sign-up screen.
///
/// Email + username + password + confirm password. Submits via
/// [AuthRepository.signUp]; success state depends on whether Supabase
/// auto-confirms or requires email verification:
///   - Auto-confirmed: trader is logged in; redirect to /app.
///   - Email required: show a "check your email" success state with
///     a link back to /login (where they can sign in once they've
///     clicked the confirmation link).
///
/// Other profile fields (name, address, etc) are collected later via
/// the trader's Settings page — keeps the sign-up form short.
class TraderSignUpScreen extends StatefulWidget {
  const TraderSignUpScreen({super.key});

  @override
  State<TraderSignUpScreen> createState() => _TraderSignUpScreenState();
}

class _TraderSignUpScreenState extends State<TraderSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _submitting = false;
  String? _error;
  bool _checkEmail = false;
  String? _confirmedEmail;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = context.read<AuthRepository>();
    final result = await repo.signUp(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      username: _usernameCtrl.text.trim(),
    );
    if (!mounted) return;
    switch (result.status) {
      case SignUpStatus.signedIn:
        Navigator.of(context).pushReplacementNamed('/app');
      case SignUpStatus.checkEmail:
        setState(() {
          _submitting = false;
          _checkEmail = true;
          _confirmedEmail = _emailCtrl.text.trim();
        });
      case SignUpStatus.error:
        setState(() {
          _submitting = false;
          _error = result.errorMessage ?? 'Sign-up failed.';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.08),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: _checkEmail
                  ? _CheckEmailState(email: _confirmedEmail ?? '')
                  : _Form(
                      formKey: _formKey,
                      emailCtrl: _emailCtrl,
                      usernameCtrl: _usernameCtrl,
                      passwordCtrl: _passwordCtrl,
                      confirmCtrl: _confirmCtrl,
                      error: _error,
                      submitting: _submitting,
                      onSubmit: _submit,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController usernameCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;
  final String? error;
  final bool submitting;
  final VoidCallback onSubmit;

  const _Form({
    required this.formKey,
    required this.emailCtrl,
    required this.usernameCtrl,
    required this.passwordCtrl,
    required this.confirmCtrl,
    required this.error,
    required this.submitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: _Wordmark()),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Create your trader account',
            style: AppTypography.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Free to start. Buy slots from Plans whenever you want to '
            'connect a broker account.',
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: _decoration(
              label: 'Email',
              icon: Icons.email_outlined,
            ),
            validator: (v) {
              final s = v?.trim() ?? '';
              if (s.isEmpty) return 'Email is required';
              if (!s.contains('@') || !s.contains('.')) {
                return "That doesn't look like a valid email";
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: usernameCtrl,
            autofillHints: const [AutofillHints.username],
            decoration: _decoration(
              label: 'Username',
              icon: Icons.person_outline,
            ),
            validator: (v) {
              final s = v?.trim() ?? '';
              if (s.isEmpty) return 'Username is required';
              if (s.length < 3) return 'Username must be at least 3 characters';
              if (s.length > 32) return 'Username must be at most 32 characters';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: passwordCtrl,
            obscureText: true,
            autofillHints: const [AutofillHints.newPassword],
            decoration: _decoration(
              label: 'Password',
              icon: Icons.lock_outline,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: confirmCtrl,
            obscureText: true,
            decoration: _decoration(
              label: 'Confirm password',
              icon: Icons.lock_outline,
            ),
            validator: (v) {
              if (v != passwordCtrl.text) return 'Passwords don\'t match';
              return null;
            },
            onFieldSubmitted: (_) => onSubmit(),
          ),
          if (error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              error!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.loss),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Create account',
            onPressed: submitting ? null : onSubmit,
            isLoading: submitting,
            large: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: AppTypography.bodySmall,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/login'),
                child: const Text('Log in'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckEmailState extends StatelessWidget {
  final String email;
  const _CheckEmailState({required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: _Wordmark()),
        const SizedBox(height: AppSpacing.xl),
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.profit.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_unread_outlined,
            color: AppColors.profit,
            size: 32,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Check your email',
          style: AppTypography.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'We sent a confirmation link to $email. Click it to activate '
          'your account, then come back here to log in.',
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: 'Back to log in',
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed('/login'),
          large: true,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          "Didn't get the email? Check your spam folder, or wait a few "
          'minutes and try logging in.',
          style: AppTypography.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Wordmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Q',
            style: TextStyle(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              fontFamily: AppTypography.fontFamily,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Text(
          'QuantumPips',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: -0.4,
            fontFamily: AppTypography.fontFamily,
          ),
        ),
      ],
    );
  }
}

InputDecoration _decoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: AppColors.primaryAccent, size: 20),
    filled: true,
    fillColor: AppColors.surfaceMuted,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: BorderSide.none,
    ),
    labelStyle: AppTypography.bodyMedium.copyWith(
      color: AppColors.textMuted,
    ),
  );
}
