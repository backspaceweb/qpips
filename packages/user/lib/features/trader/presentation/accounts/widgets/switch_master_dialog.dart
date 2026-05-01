import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account.dart';
import 'package:qp_core/domain/account_ownership.dart';
import 'package:qp_core/repositories/trading_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Switch a slave's master.
///
/// The trading API has no rebind endpoint, so this is delete +
/// re-register under the hood. We require password + server (we don't
/// persist them) and warn that open positions on the old master stay
/// open. If the register call fails after the delete succeeds, the
/// slave is unbound — the dialog shows a recovery message and stays
/// open so the trader can retry.
class SwitchMasterDialog extends StatefulWidget {
  final AccountOwnership slave;
  final List<AccountOwnership> ownedAccounts;
  final VoidCallback onSwitched;

  const SwitchMasterDialog({
    super.key,
    required this.slave,
    required this.ownedAccounts,
    required this.onSwitched,
  });

  @override
  State<SwitchMasterDialog> createState() => _SwitchMasterDialogState();
}

class _SwitchMasterDialogState extends State<SwitchMasterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _serverCtrl = TextEditingController();

  AccountOwnership? _newMaster;
  bool _submitting = false;
  String? _error;
  bool _registerStageFailed = false;

  late final List<AccountOwnership> _candidateMasters;

  @override
  void initState() {
    super.initState();
    // Other masters on the same platform — slaves can't follow a
    // master on a different platform.
    _candidateMasters = widget.ownedAccounts
        .where((a) =>
            a.accountType == AccountType.master &&
            a.platform == widget.slave.platform)
        .toList();
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _serverCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_newMaster == null) {
      setState(() => _error = 'Pick a new master.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = context.read<TradingRepository>();
    final result = await repo.switchSlaveMaster(
      slave: _slaveAccount(),
      newMaster: _masterAccount(_newMaster!),
      password: _passwordCtrl.text,
      server: _serverCtrl.text.trim(),
      comment: widget.slave.displayName,
    );
    if (!mounted) return;
    if (result.success) {
      Navigator.of(context).pop();
      widget.onSwitched();
      return;
    }
    setState(() {
      _submitting = false;
      _error = result.errorMessage ?? 'Switch failed.';
      _registerStageFailed =
          result.failedStage == SwitchMasterStage.register;
    });
  }

  Account _slaveAccount() {
    final s = widget.slave;
    return Account(
      serverId: s.tradingAccountId,
      loginNumber: s.loginNumber,
      accountName: s.effectiveLabel,
      accountType: s.accountType,
      platform: s.platform,
    );
  }

  Account _masterAccount(AccountOwnership m) {
    return Account(
      serverId: m.tradingAccountId,
      loginNumber: m.loginNumber,
      accountName: m.effectiveLabel,
      accountType: m.accountType,
      platform: m.platform,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasCandidates = _candidateMasters.isNotEmpty;
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Switch master', style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'For slave #${widget.slave.loginNumber} '
                  '(${widget.slave.platform.wireValue})',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                _WarningBanner(
                  text: 'Existing open positions on the current master will '
                      'remain open and won\'t auto-close. New trades will '
                      'mirror the new master.',
                ),
                const SizedBox(height: AppSpacing.lg),
                if (!hasCandidates)
                  _NoCandidatesNotice(slavePlatform: widget.slave.platform)
                else ...[
                  DropdownButtonFormField<AccountOwnership>(
                    value: _newMaster,
                    isExpanded: true,
                    decoration: _decoration(
                      label: 'New master',
                      icon: Icons.swap_horiz,
                    ),
                    items: [
                      for (final m in _candidateMasters)
                        DropdownMenuItem(
                          value: m,
                          child: Text(
                            '${m.effectiveLabel} (#${m.loginNumber})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (v) => setState(() => _newMaster = v),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    decoration: _decoration(
                      label: 'Slave password',
                      icon: Icons.lock_outline,
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Password is required'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _serverCtrl,
                    decoration: _decoration(
                      label: 'Slave server',
                      icon: Icons.dns_outlined,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Server name is required'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    "We don't store passwords — re-enter to authorize the "
                    'switch.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _registerStageFailed
                        ? 'Old master was unfollowed but the new master '
                            "couldn't be bound. Fix the password / server "
                            'and retry — your slot is still consumed.\n\n'
                            '$_error'
                        : _error!,
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
                        label: 'Switch master',
                        onPressed:
                            (!hasCandidates || _submitting) ? null : _submit,
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

class _WarningBanner extends StatelessWidget {
  final String text;
  const _WarningBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoCandidatesNotice extends StatelessWidget {
  final Platform slavePlatform;
  const _NoCandidatesNotice({required this.slavePlatform});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Text(
        'No other ${slavePlatform.wireValue} masters in your account list. '
        'Add another master on the same platform first, then come back to '
        'switch.',
        style: AppTypography.bodySmall,
      ),
    );
  }
}
