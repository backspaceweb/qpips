import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account.dart';
import 'package:qp_core/domain/follow_config.dart';
import 'package:qp_core/domain/master_listing.dart';
import 'package:qp_core/domain/trader_slave.dart';
import 'package:qp_core/repositories/trader_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Configure Follow — modal flow that wires a trader's slave account to
/// a chosen master.
///
/// Composition (vertically scrolling):
///   1. Master summary banner (avatar + display name + min deposit)
///   2. Slave picker — radio cards of the trader's slaves; greys-out
///      under-deposited ones, warns if a slave is already following.
///   3. Risk + copy form — risk mode + multiplier (with mode-aware
///      tooltip); Copy SL/TP toggle; Scalper mode dropdown; Order
///      filter dropdown.
///   4. Advanced — collapsed-by-default block with auto-close limits
///      (profit-all / loss-all / equity-high / equity-low).
///   5. Submit / Cancel footer (sticky on mobile).
///
/// On submit, calls [TraderRepository.submitFollow], shows a success
/// state, then dismisses. The success step doesn't navigate to "My
/// Follows" yet (that screen lands in D.5.4).
///
/// Presentation: dialog on desktop (>= tabletMin), full-height bottom
/// sheet on mobile. Use [showConfigureFollowSheet] to present from a
/// caller — it picks the right form factor automatically.
class ConfigureFollowSheet extends StatefulWidget {
  final MasterListing master;

  const ConfigureFollowSheet({super.key, required this.master});

  @override
  State<ConfigureFollowSheet> createState() => _ConfigureFollowSheetState();
}

Future<void> showConfigureFollowSheet(
  BuildContext context, {
  required MasterListing master,
}) async {
  final width = MediaQuery.of(context).size.width;
  final isDesktop = width >= AppSpacing.tabletMin;
  if (isDesktop) {
    await showDialog<void>(
      context: context,
      barrierColor: AppColors.overlay,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        insetPadding: const EdgeInsets.all(AppSpacing.xl),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 640,
            maxHeight: 720,
          ),
          child: ConfigureFollowSheet(master: master),
        ),
      ),
    );
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: AppColors.overlay,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
    ),
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.92,
      child: ConfigureFollowSheet(master: master),
    ),
  );
}

class _ConfigureFollowSheetState extends State<ConfigureFollowSheet> {
  late Future<List<TraderSlaveAccount>> _slavesFuture;

  String? _slaveId;
  RiskMode _riskMode = RiskMode.equityScaled;
  double _riskMultiplier = 1.0;
  bool _copySlTp = true;
  ScalperMode _scalperMode = ScalperMode.off;
  int _scalperPoints = 0;
  OrderFilter _orderFilter = OrderFilter.buyAndSell;
  bool _advancedOpen = false;
  int _profitAll = 0;
  int _lossAll = 0;
  int _equityHigh = 0;
  int _equityLow = 0;

  bool _submitting = false;
  bool _completed = false;

  late final TextEditingController _multCtrl;
  late final TextEditingController _scalperCtrl;
  late final Map<String, TextEditingController> _limitCtrls;

  @override
  void initState() {
    super.initState();
    _slavesFuture = context.read<TraderRepository>().listMySlaves();
    _multCtrl = TextEditingController(text: '1.0');
    _scalperCtrl = TextEditingController(text: '0');
    _limitCtrls = {
      'profitAll': TextEditingController(text: '0'),
      'lossAll': TextEditingController(text: '0'),
      'equityHigh': TextEditingController(text: '0'),
      'equityLow': TextEditingController(text: '0'),
    };
  }

  @override
  void dispose() {
    _multCtrl.dispose();
    _scalperCtrl.dispose();
    for (final c in _limitCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _canSubmit => _slaveId != null && !_submitting && !_completed;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _submitting = true);
    final config = FollowConfig(
      masterId: widget.master.id,
      slaveAccountId: _slaveId!,
      riskMode: _riskMode,
      riskMultiplier: _riskMultiplier,
      copySlTp: _copySlTp,
      scalperMode: _scalperMode,
      scalperValuePoints: _scalperPoints,
      orderFilter: _orderFilter,
      limits: _advancedOpen
          ? FollowLimits(
              profitForAllOrder: _profitAll,
              lossForAllOrder: _lossAll,
              equityUnderHigh: _equityHigh,
              equityUnderLow: _equityLow,
            )
          : null,
    );
    try {
      await context.read<TraderRepository>().submitFollow(config);
      if (!mounted) return;
      setState(() {
        _completed = true;
        _submitting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't submit follow: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) {
      return _SuccessState(
        master: widget.master,
        onDone: () => Navigator.of(context).pop(),
      );
    }
    return Column(
      children: [
        _Header(
          master: widget.master,
          onClose: () => Navigator.of(context).pop(),
        ),
        Expanded(
          child: FutureBuilder<List<TraderSlaveAccount>>(
            future: _slavesFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryAccent,
                  ),
                );
              }
              if (snap.hasError) {
                return Center(
                  child: Text(
                    "Couldn't load your slave accounts: ${snap.error}",
                    style: AppTypography.bodySmall,
                  ),
                );
              }
              final slaves = snap.data ?? const <TraderSlaveAccount>[];
              return _Body(
                slaves: slaves,
                master: widget.master,
                slaveId: _slaveId,
                onSlaveChanged: (id) => setState(() => _slaveId = id),
                riskMode: _riskMode,
                onRiskMode: (m) => setState(() => _riskMode = m),
                riskMultiplier: _riskMultiplier,
                multCtrl: _multCtrl,
                onMultiplierChanged: (v) => _riskMultiplier = v,
                copySlTp: _copySlTp,
                onCopySlTp: (v) => setState(() => _copySlTp = v),
                scalperMode: _scalperMode,
                onScalperMode: (m) => setState(() => _scalperMode = m),
                scalperPoints: _scalperPoints,
                scalperCtrl: _scalperCtrl,
                onScalperPoints: (v) => _scalperPoints = v,
                orderFilter: _orderFilter,
                onOrderFilter: (f) => setState(() => _orderFilter = f),
                advancedOpen: _advancedOpen,
                onAdvancedToggle: () =>
                    setState(() => _advancedOpen = !_advancedOpen),
                limitCtrls: _limitCtrls,
                onProfitAll: (v) => _profitAll = v,
                onLossAll: (v) => _lossAll = v,
                onEquityHigh: (v) => _equityHigh = v,
                onEquityLow: (v) => _equityLow = v,
              );
            },
          ),
        ),
        _Footer(
          canSubmit: _canSubmit,
          submitting: _submitting,
          onSubmit: _submit,
          onCancel: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

// =============================================================================
//  Header
// =============================================================================

class _Header extends StatelessWidget {
  final MasterListing master;
  final VoidCallback onClose;
  const _Header({required this.master, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceBorder),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Configure follow', style: AppTypography.titleLarge),
                const SizedBox(height: 2),
                Text(
                  'Following ${master.displayName} · '
                  'min deposit ${master.currency} '
                  '${master.minDeposit.toStringAsFixed(0)}',
                  style: AppTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
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

// =============================================================================
//  Body
// =============================================================================

class _Body extends StatelessWidget {
  final List<TraderSlaveAccount> slaves;
  final MasterListing master;
  final String? slaveId;
  final ValueChanged<String?> onSlaveChanged;
  final RiskMode riskMode;
  final ValueChanged<RiskMode> onRiskMode;
  final double riskMultiplier;
  final TextEditingController multCtrl;
  final ValueChanged<double> onMultiplierChanged;
  final bool copySlTp;
  final ValueChanged<bool> onCopySlTp;
  final ScalperMode scalperMode;
  final ValueChanged<ScalperMode> onScalperMode;
  final int scalperPoints;
  final TextEditingController scalperCtrl;
  final ValueChanged<int> onScalperPoints;
  final OrderFilter orderFilter;
  final ValueChanged<OrderFilter> onOrderFilter;
  final bool advancedOpen;
  final VoidCallback onAdvancedToggle;
  final Map<String, TextEditingController> limitCtrls;
  final ValueChanged<int> onProfitAll;
  final ValueChanged<int> onLossAll;
  final ValueChanged<int> onEquityHigh;
  final ValueChanged<int> onEquityLow;

  const _Body({
    required this.slaves,
    required this.master,
    required this.slaveId,
    required this.onSlaveChanged,
    required this.riskMode,
    required this.onRiskMode,
    required this.riskMultiplier,
    required this.multCtrl,
    required this.onMultiplierChanged,
    required this.copySlTp,
    required this.onCopySlTp,
    required this.scalperMode,
    required this.onScalperMode,
    required this.scalperPoints,
    required this.scalperCtrl,
    required this.onScalperPoints,
    required this.orderFilter,
    required this.onOrderFilter,
    required this.advancedOpen,
    required this.onAdvancedToggle,
    required this.limitCtrls,
    required this.onProfitAll,
    required this.onLossAll,
    required this.onEquityHigh,
    required this.onEquityLow,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        const _SectionTitle(
          number: 1,
          title: 'Pick a slave account',
          subtitle:
              'The slave account that will mirror this provider. You '
              "can re-bind a slave that's already following someone.",
        ),
        const SizedBox(height: AppSpacing.md),
        if (slaves.isEmpty)
          const _Empty(
            title: 'No slave accounts linked yet',
            body:
                "Link a broker account first — Phase E adds the linking "
                'flow. For now this demo seed is empty.',
          )
        else
          for (final s in slaves)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _SlaveCard(
                slave: s,
                master: master,
                selected: s.id == slaveId,
                onTap: () => onSlaveChanged(s.id),
              ),
            ),
        const SizedBox(height: AppSpacing.xxl),
        const _SectionTitle(
          number: 2,
          title: 'Risk & copy',
          subtitle:
              "How aggressively to size your trades and which of the "
              "master's order types to mirror.",
        ),
        const SizedBox(height: AppSpacing.md),
        _RiskModePicker(value: riskMode, onChanged: onRiskMode),
        const SizedBox(height: AppSpacing.md),
        _MultiplierField(
          mode: riskMode,
          ctrl: multCtrl,
          onChanged: onMultiplierChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        _CopySlTpRow(value: copySlTp, onChanged: onCopySlTp),
        const SizedBox(height: AppSpacing.lg),
        _ScalperRow(
          mode: scalperMode,
          onMode: onScalperMode,
          points: scalperPoints,
          ctrl: scalperCtrl,
          onPoints: onScalperPoints,
        ),
        const SizedBox(height: AppSpacing.lg),
        _OrderFilterPicker(value: orderFilter, onChanged: onOrderFilter),
        const SizedBox(height: AppSpacing.xxl),
        _AdvancedSection(
          open: advancedOpen,
          onToggle: onAdvancedToggle,
          ctrls: limitCtrls,
          onProfitAll: onProfitAll,
          onLossAll: onLossAll,
          onEquityHigh: onEquityHigh,
          onEquityLow: onEquityLow,
        ),
      ],
    );
  }
}

// =============================================================================
//  Slave picker
// =============================================================================

class _SlaveCard extends StatelessWidget {
  final TraderSlaveAccount slave;
  final MasterListing master;
  final bool selected;
  final VoidCallback onTap;

  const _SlaveCard({
    required this.slave,
    required this.master,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final under = slave.balance < master.minDeposit;
    final borderColor =
        selected ? AppColors.primaryAccent : AppColors.surfaceBorder;
    return Material(
      color: selected ? AppColors.primarySoft : AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              _RadioDot(selected: selected),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            slave.displayName,
                            style: AppTypography.titleMedium
                                .copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _PlatformChip(platform: slave.platform),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${slave.broker} · #${slave.loginNumber}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontFamily: AppTypography.monoFontFamily,
                        fontSize: 11,
                      ),
                    ),
                    if (slave.hasExistingBinding) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Currently following ${slave.followingMasterDisplayName}'
                        ' — re-binding replaces this.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.warning,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    if (under) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Balance below provider min '
                        '(${master.currency} '
                        '${master.minDeposit.toStringAsFixed(0)}).',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.loss,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${slave.currency} ${slave.balance.toStringAsFixed(2)}',
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 13,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'balance',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primaryAccent : AppColors.surfaceBorder,
          width: selected ? 5 : 1.5,
        ),
        color: AppColors.surface,
      ),
    );
  }
}

class _PlatformChip extends StatelessWidget {
  final Platform platform;
  const _PlatformChip({required this.platform});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Text(
        platform.name.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textSecondary,
          fontSize: 9,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// =============================================================================
//  Risk + copy form
// =============================================================================

class _RiskModePicker extends StatelessWidget {
  final RiskMode value;
  final ValueChanged<RiskMode> onChanged;
  const _RiskModePicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _Field(
      label: 'Risk mode',
      child: DropdownButtonFormField<RiskMode>(
        value: value,
        decoration: _inputDecoration(),
        items: [
          for (final m in RiskMode.values)
            DropdownMenuItem(value: m, child: Text(m.label)),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

class _MultiplierField extends StatelessWidget {
  final RiskMode mode;
  final TextEditingController ctrl;
  final ValueChanged<double> onChanged;
  const _MultiplierField({
    required this.mode,
    required this.ctrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = mode == RiskMode.autoRisk;
    final hint = switch (mode) {
      RiskMode.equityScaled =>
        '1.0 = match risk; 0.5 = half; 2.0 = double exposure.',
      RiskMode.lotMultiplier =>
        "1.0 = master's lot size; 0.5 = half; 2.0 = double.",
      RiskMode.fixedLot => 'Lots per trade. e.g. 0.10.',
      RiskMode.autoRisk => 'Server tunes risk automatically — disabled.',
    };
    return _Field(
      label: 'Multiplier',
      hint: hint,
      child: TextField(
        controller: ctrl,
        enabled: !disabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        ],
        decoration: _inputDecoration(),
        onChanged: (v) {
          final parsed = double.tryParse(v);
          if (parsed != null) onChanged(parsed);
        },
      ),
    );
  }
}

class _CopySlTpRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _CopySlTpRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _ToggleRow(
      title: 'Copy SL / TP',
      subtitle: "Mirror the master's stop-loss and take-profit levels.",
      value: value,
      onChanged: onChanged,
    );
  }
}

class _ScalperRow extends StatelessWidget {
  final ScalperMode mode;
  final ValueChanged<ScalperMode> onMode;
  final int points;
  final TextEditingController ctrl;
  final ValueChanged<int> onPoints;

  const _ScalperRow({
    required this.mode,
    required this.onMode,
    required this.points,
    required this.ctrl,
    required this.onPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Field(
          label: 'Scalper mode',
          hint: 'How the slave handles fast-rotating positions.',
          child: DropdownButtonFormField<ScalperMode>(
            value: mode,
            decoration: _inputDecoration(),
            items: [
              for (final m in ScalperMode.values)
                DropdownMenuItem(value: m, child: Text(m.label)),
            ],
            onChanged: (v) {
              if (v != null) onMode(v);
            },
          ),
        ),
        if (mode != ScalperMode.off) ...[
          const SizedBox(height: AppSpacing.md),
          _Field(
            label: 'Trigger threshold (points)',
            hint:
                'Threshold past which scalper rules apply. 0 = always.',
            child: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration(),
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null) onPoints(parsed);
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _OrderFilterPicker extends StatelessWidget {
  final OrderFilter value;
  final ValueChanged<OrderFilter> onChanged;
  const _OrderFilterPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _Field(
      label: 'Order filter',
      hint: "Restrict which of the master's order types you mirror.",
      child: DropdownButtonFormField<OrderFilter>(
        value: value,
        decoration: _inputDecoration(),
        items: [
          for (final f in OrderFilter.values)
            DropdownMenuItem(value: f, child: Text(f.label)),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

// =============================================================================
//  Advanced — auto-close limits
// =============================================================================

class _AdvancedSection extends StatelessWidget {
  final bool open;
  final VoidCallback onToggle;
  final Map<String, TextEditingController> ctrls;
  final ValueChanged<int> onProfitAll;
  final ValueChanged<int> onLossAll;
  final ValueChanged<int> onEquityHigh;
  final ValueChanged<int> onEquityLow;

  const _AdvancedSection({
    required this.open,
    required this.onToggle,
    required this.ctrls,
    required this.onProfitAll,
    required this.onLossAll,
    required this.onEquityHigh,
    required this.onEquityLow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.surfaceBorder),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Advanced — auto-close limits',
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Optional. Force-close all orders when these '
                          'thresholds are hit. Leave blank to use server '
                          'defaults.',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    open ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (open) ...[
            const Divider(height: 1, color: AppColors.surfaceBorder),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _LimitField(
                    label: 'Close all if total profit ≥',
                    suffix: 'amount',
                    ctrl: ctrls['profitAll']!,
                    onChanged: onProfitAll,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _LimitField(
                    label: 'Close all if total loss ≥',
                    suffix: 'amount',
                    ctrl: ctrls['lossAll']!,
                    onChanged: onLossAll,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _LimitField(
                    label: 'Close all if equity rises above',
                    suffix: 'equity',
                    ctrl: ctrls['equityHigh']!,
                    onChanged: onEquityHigh,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _LimitField(
                    label: 'Close all if equity drops below',
                    suffix: 'equity',
                    ctrl: ctrls['equityLow']!,
                    onChanged: onEquityLow,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LimitField extends StatelessWidget {
  final String label;
  final String suffix;
  final TextEditingController ctrl;
  final ValueChanged<int> onChanged;

  const _LimitField({
    required this.label,
    required this.suffix,
    required this.ctrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _Field(
      label: label,
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: _inputDecoration().copyWith(suffixText: suffix),
        onChanged: (v) {
          final parsed = int.tryParse(v);
          if (parsed != null) onChanged(parsed);
        },
      ),
    );
  }
}

// =============================================================================
//  Footer + success
// =============================================================================

class _Footer extends StatelessWidget {
  final bool canSubmit;
  final bool submitting;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const _Footer({
    required this.canSubmit,
    required this.submitting,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
        color: AppColors.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: onCancel, child: const Text('Cancel')),
          const SizedBox(width: AppSpacing.md),
          PrimaryButton(
            label: submitting ? 'Submitting…' : 'Confirm follow',
            onPressed: canSubmit ? onSubmit : null,
            isLoading: submitting,
          ),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final MasterListing master;
  final VoidCallback onDone;
  const _SuccessState({required this.master, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.profit.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.check,
              color: AppColors.profit,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            "You're now following ${master.displayName}.",
            style: AppTypography.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'New trades from this provider will mirror to your slave '
            'account on its next signal. You can pause or change settings '
            'at any time from My Follows (lands in D.5.4).',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(label: 'Done', onPressed: onDone),
        ],
      ),
    );
  }
}

// =============================================================================
//  Shared form chrome
// =============================================================================

class _SectionTitle extends StatelessWidget {
  final int number;
  final String title;
  final String? subtitle;

  const _SectionTitle({
    required this.number,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
              fontSize: 11,
              letterSpacing: 0,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: AppTypography.bodySmall),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String? hint;
  final Widget child;
  const _Field({required this.label, required this.child, this.hint});

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

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String title;
  final String body;
  const _Empty({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
          const SizedBox(height: 4),
          Text(body, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration() {
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
