import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/repositories/auth_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Trader sign-in screen.
///
/// 1A scope: log-in only. Sign-up flow ships in a later slice; for now
/// Susanto creates trader accounts manually via Supabase Dashboard
/// (Authentication → Users → Add user). The trigger auto-creates a
/// profile + wallet for each new auth.users row.
///
/// On success, replaces route with `/app` (TraderShell).
class TraderLoginScreen extends StatefulWidget {
  const TraderLoginScreen({super.key});

  @override
  State<TraderLoginScreen> createState() => _TraderLoginScreenState();
}

class _TraderLoginScreenState extends State<TraderLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = context.read<AuthRepository>();
    final message = await repo.login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );
    if (!mounted) return;
    if (message.contains('successful')) {
      Navigator.of(context).pushReplacementNamed('/app');
      return;
    }
    setState(() {
      _submitting = false;
      _error = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: _Wordmark()),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Sign in to continue',
                      style: AppTypography.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      "We'll route you to your dashboard.",
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: _inputDecoration(
                        label: 'Email',
                        icon: Icons.email_outlined,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Email is required'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      decoration: _inputDecoration(
                        label: 'Password',
                        icon: Icons.lock_outline,
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Password is required'
                          : null,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        _error!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.loss,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      label: 'Sign in',
                      onPressed: _submitting ? null : _submit,
                      isLoading: _submitting,
                      large: true,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed('/'),
                      child: Text(
                        'Back to landing',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
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
