import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account.dart';
import 'package:qp_core/domain/account_ownership.dart';
import 'package:qp_core/repositories/trading_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Edit dialog for an existing master/slave account.
///
/// Calls the trading API's `update_*` endpoint with a fresh
/// password + server every time — neither is persisted locally for
/// security reasons. The Edge Function mirrors the new `comment`
/// (display name) into `account_ownership.display_name` after a
/// successful update.
class AccountEditDialog extends StatefulWidget {
  final AccountOwnership account;
  final VoidCallback onUpdated;

  const AccountEditDialog({
    super.key,
    required this.account,
    required this.onUpdated,
  });

  @override
  State<AccountEditDialog> createState() => _AccountEditDialogState();
}

class _AccountEditDialogState extends State<AccountEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameCtrl;
  final _passwordCtrl = TextEditingController();
  final _serverCtrl = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _displayNameCtrl = TextEditingController(
      text: widget.account.displayName ?? '',
    );
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _passwordCtrl.dispose();
    _serverCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = context.read<TradingRepository>();
    final acc = widget.account;
    final ok = await repo.updateTradingAccount(
      account: Account(
        serverId: acc.tradingAccountId,
        loginNumber: acc.loginNumber,
        accountName: acc.effectiveLabel,
        accountType: acc.accountType,
        platform: acc.platform,
      ),
      password: _passwordCtrl.text,
      server: _serverCtrl.text.trim(),
      comment: _displayNameCtrl.text.trim().isEmpty
          ? null
          : _displayNameCtrl.text.trim(),
    );
    if (!mounted) return;
    if (!ok) {
      setState(() {
        _submitting = false;
        _error =
            "Couldn't update account — check the password + server name.";
      });
      return;
    }
    Navigator.of(context).pop();
    widget.onUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit account', style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Login #${widget.account.loginNumber} · '
                  '${widget.account.platform.wireValue} · '
                  '${widget.account.accountType.name.toUpperCase()}',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: _displayNameCtrl,
                  decoration: _decoration(
                    label: 'Display name (optional)',
                    icon: Icons.label_outline,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: _decoration(
                    label: 'Password',
                    icon: Icons.lock_outline,
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Password is required' : null,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "We don't store passwords — re-enter to confirm changes.",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _serverCtrl,
                  decoration: _decoration(
                    label: 'Server',
                    icon: Icons.dns_outlined,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Server name is required'
                      : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _error!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.loss,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _submitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Save',
                        onPressed: _submitting ? null : _submit,
                        isLoading: _submitting,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
}
