import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account.dart';
import 'package:qp_core/domain/account_ownership.dart';
import 'package:qp_core/domain/broker.dart';
import 'package:qp_core/repositories/trading_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Add Account dialog — registers a master/slave with a broker.
///
/// Form fields:
///   - Account type (Master / Slave radio)
///   - Platform (MT4 / MT5 dropdown — V1 supports these only; other
///     platforms surface in later slices)
///   - Broker (typeahead picker; alphabetical filter; "Other" allows
///     unknown brokers)
///   - Server (autocomplete from broker's known servers, or manual)
///   - Login number (broker login = trading_account_id)
///   - Password (investor password for slave; master password for master)
///   - Master ID (slave only — the master's trading_account_id to follow)
///   - Display name (optional, becomes the comment query param which
///     the trading-proxy stores as account_ownership.display_name)
///
/// On submit calls `TradingRepository.registerTradingAccount`. The
/// trading-proxy Edge Function gates the call on slot quota and writes
/// the ownership row atomically when the trading API succeeds.
class AddAccountDialog extends StatefulWidget {
  final SlotUsage usage;

  /// Trader's existing master accounts. Drives the "Master to follow"
  /// dropdown when type=Slave: zero masters → "None" only; one master
  /// → auto-selected; multiple → user picks. The trading API receives
  /// the picked masterId verbatim, so 0 means "register unbound".
  final List<AccountOwnership> existingMasters;

  const AddAccountDialog({
    super.key,
    required this.usage,
    required this.existingMasters,
  });

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  AccountType _type = AccountType.master;
  Platform _platform = Platform.mt5;

  late final TextEditingController _brokerCtrl;
  late final TextEditingController _serverCtrl;
  late final TextEditingController _loginCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _displayNameCtrl;

  /// Selected master to bind a new slave to. 0 = no binding ("None").
  /// Auto-set to the trader's only master when they have exactly one.
  int _selectedMasterId = 0;

  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _brokerCtrl = TextEditingController();
    _serverCtrl = TextEditingController();
    _loginCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _displayNameCtrl = TextEditingController();
    // Pre-select the trader's only master when they have exactly one.
    if (widget.existingMasters.length == 1) {
      _selectedMasterId = widget.existingMasters.first.tradingAccountId;
    }
  }

  @override
  void dispose() {
    _brokerCtrl.dispose();
    _serverCtrl.dispose();
    _loginCtrl.dispose();
    _passwordCtrl.dispose();
    _displayNameCtrl.dispose();
    super.dispose();
  }

  /// Pulls the inner `message` out of the trading API team's error
  /// envelope when present. Their failure responses look like
  /// `Registration failed: {"status":500,"message":"...","success":false}`
  /// — we strip the wrapper for a less hostile UX. Falls back to the
  /// raw string when the body isn't a parseable JSON object.
  String _humanizeError(String? raw) {
    final s = raw?.trim();
    if (s == null || s.isEmpty) return 'Registration failed.';
    final braceIdx = s.indexOf('{');
    if (braceIdx < 0) return s;
    try {
      final json = jsonDecode(s.substring(braceIdx)) as Map<String, dynamic>;
      final msg = json['message']?.toString();
      final status = json['status']?.toString();
      if (msg != null && msg.isNotEmpty) {
        return status != null ? '$msg (HTTP $status)' : msg;
      }
    } catch (_) {
      // Fall through to raw string.
    }
    return s;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final server = _serverCtrl.text.trim();
    if (server.isEmpty) {
      setState(() => _error = 'Server name is required.');
      return;
    }
    final loginInt = int.tryParse(_loginCtrl.text.trim());
    if (loginInt == null) {
      setState(() => _error = 'Login must be a number.');
      return;
    }
    final masterIdInt =
        _type == AccountType.slave ? _selectedMasterId : null;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final repo = context.read<TradingRepository>();
      final result = await repo.registerTradingAccount(
        userId: loginInt,
        platformType: _platform.wireValue,
        password: _passwordCtrl.text,
        server: server,
        accountName: _displayNameCtrl.text.trim().isEmpty
            ? null
            : _displayNameCtrl.text.trim(),
        isMaster: _type == AccountType.master,
        masterId: masterIdInt,
        copyOrderType: _type == AccountType.slave ? 1 : null,
      );
      if (!mounted) return;
      final success = result['success'] == true;
      if (!success) {
        setState(() {
          _submitting = false;
          _error = _humanizeError(result['message']?.toString());
        });
        return;
      }
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 700),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DialogHeader(
                onClose: () => Navigator.of(context).pop(false),
              ),
              const Divider(height: 1, color: AppColors.surfaceBorder),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SlotChip(usage: widget.usage),
                      const SizedBox(height: AppSpacing.lg),
                      _Field(
                        label: 'Account type',
                        child: _TypeRadios(
                          value: _type,
                          onChanged: (v) => setState(() => _type = v),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _Field(
                        label: 'Platform',
                        child: DropdownButtonFormField<Platform>(
                          value: _platform,
                          decoration: _decoration(),
                          items: const [
                            DropdownMenuItem(
                              value: Platform.mt5,
                              child: Text('MT5'),
                            ),
                            DropdownMenuItem(
                              value: Platform.mt4,
                              child: Text('MT4'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _platform = v);
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _Field(
                        label: 'Broker',
                        hint:
                            'Pick from the list or type your own broker '
                            'name. Alphabetical filter as you type.',
                        child: _BrokerTypeahead(controller: _brokerCtrl),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _Field(
                        label: 'Server',
                        hint:
                            'Type the server name your broker assigned, '
                            "exactly as it appears in your broker's "
                            'platform (e.g. Exness-MT5Real6).',
                        child: TextFormField(
                          controller: _serverCtrl,
                          decoration: _decoration().copyWith(
                            hintText: 'Server name',
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _Field(
                        label: 'Login number',
                        hint: 'Your broker account number.',
                        child: TextFormField(
                          controller: _loginCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: _decoration(),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _Field(
                        label: _type == AccountType.master
                            ? 'Master password'
                            : 'Investor password',
                        hint: _type == AccountType.master
                            ? 'Used to send orders from this account.'
                            : "Read + trade access only — never give out your account's main password.",
                        child: TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          decoration: _decoration(),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      if (_type == AccountType.slave) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _Field(
                          label: 'Master to follow',
                          hint: widget.existingMasters.isEmpty
                              ? "You don't have any master accounts yet. "
                                  "The slave will register without a "
                                  "master binding — add a master first if "
                                  "you want internal copy-trading."
                              : (widget.existingMasters.length == 1
                                  ? "Auto-selected — your only master "
                                      "account."
                                  : 'Pick which of your master accounts '
                                      'this slave should mirror.'),
                          child: DropdownButtonFormField<int>(
                            value: _selectedMasterId,
                            decoration: _decoration(),
                            items: [
                              const DropdownMenuItem<int>(
                                value: 0,
                                child: Text('None — register without binding'),
                              ),
                              for (final m in widget.existingMasters)
                                DropdownMenuItem<int>(
                                  value: m.tradingAccountId,
                                  child: Text(
                                    '${m.effectiveLabel} '
                                    '(#${m.loginNumber} · '
                                    '${m.platform.wireValue})',
                                  ),
                                ),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _selectedMasterId = v);
                              }
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      _Field(
                        label: 'Display name (optional)',
                        hint:
                            'Trader-facing label. Leave blank to use the '
                            'login number.',
                        child: TextFormField(
                          controller: _displayNameCtrl,
                          decoration: _decoration(),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        _ErrorBanner(message: _error!),
                      ],
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.surfaceBorder),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _submitting
                          ? null
                          : () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    PrimaryButton(
                      label: _submitting
                          ? 'Registering…'
                          : 'Register account',
                      onPressed: _submitting ? null : _submit,
                      isLoading: _submitting,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  Header / slot chip / field chrome
// =============================================================================

class _DialogHeader extends StatelessWidget {
  final VoidCallback onClose;
  const _DialogHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          Expanded(child: Text('Add Account', style: AppTypography.titleLarge)),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textMuted),
            onPressed: onClose,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  final SlotUsage usage;
  const _SlotChip({required this.usage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.confirmation_number_outlined,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Slots used: ${usage.used} of ${usage.quota}'
              '${usage.exhausted && usage.quota > 0
                  ? ' — buy more from Plans'
                  : ''}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String? hint;
  final Widget child;
  const _Field({required this.label, this.hint, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 12,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 6),
        child,
        if (hint != null) ...[
          const SizedBox(height: 4),
          Text(hint!, style: AppTypography.bodySmall),
        ],
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.loss.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.loss, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(color: AppColors.loss),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Type radios
// =============================================================================

class _TypeRadios extends StatelessWidget {
  final AccountType value;
  final ValueChanged<AccountType> onChanged;
  const _TypeRadios({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final t in AccountType.values)
          Expanded(
            child: _TypeRadio(
              type: t,
              active: value == t,
              onTap: () => onChanged(t),
            ),
          ),
      ],
    );
  }
}

class _TypeRadio extends StatelessWidget {
  final AccountType type;
  final bool active;
  final VoidCallback onTap;
  const _TypeRadio({
    required this.type,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = type == AccountType.master ? 'Master' : 'Slave';
    final desc = type == AccountType.master
        ? 'Source of trades'
        : 'Mirrors a master';
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Material(
        color: active ? AppColors.primarySoft : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(
                color: active
                    ? AppColors.primaryAccent
                    : AppColors.surfaceBorder,
                width: active ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTypography.titleMedium.copyWith(
                    fontSize: 14,
                    color: active
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  Broker typeahead
// =============================================================================

/// Broker text field with a click-down list of supported brokers that
/// filters alphabetically as the trader types. The trader can either
/// pick a suggestion (controller text gets set) or type any custom name
/// — both flow through the same controller value.
class _BrokerTypeahead extends StatefulWidget {
  final TextEditingController controller;

  const _BrokerTypeahead({required this.controller});

  @override
  State<_BrokerTypeahead> createState() => _BrokerTypeaheadState();
}

class _BrokerTypeaheadState extends State<_BrokerTypeahead> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final filtered = filterBrokers(widget.controller.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: _decoration().copyWith(
            hintText: 'Type a broker name…',
            suffixIcon: IconButton(
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.textMuted,
              ),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
          onTap: () => setState(() => _expanded = true),
          onChanged: (_) => setState(() => _expanded = true),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        if (_expanded && filtered.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.surfaceBorder),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.10),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final b in filtered)
                  _BrokerOption(
                    label: b.displayName,
                    onTap: () {
                      widget.controller.text = b.displayName;
                      setState(() => _expanded = false);
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _BrokerOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _BrokerOption({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  Shared decoration
// =============================================================================

InputDecoration _decoration() {
  return InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: const BorderSide(color: AppColors.surfaceBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: const BorderSide(color: AppColors.surfaceBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: const BorderSide(
        color: AppColors.primaryAccent,
        width: 1.5,
      ),
    ),
  );
}
