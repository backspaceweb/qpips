import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/plan_tier.dart';
import 'package:qp_core/repositories/subscription_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

import 'plans_screen.dart';

/// Admin Pricing tab — edit per-tier slot ranges + base prices, and
/// per-commitment discount percentages. Trader-facing total price is
/// computed live as `qty × base × months × (1 − discount/100)`.
class PricingTab extends StatefulWidget {
  const PricingTab({super.key});

  @override
  State<PricingTab> createState() => _PricingTabState();
}

class _PricingTabState extends State<PricingTab> {
  Future<_PricingData>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_PricingData> _load() async {
    final repo = context.read<SubscriptionRepository>();
    final tiers = await repo.listTierConfigs();
    final discounts = await repo.listCommitmentDiscounts();
    return _PricingData(tiers: tiers, discounts: discounts);
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryAccent,
      onRefresh: () async {
        _refresh();
        await _future;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: FutureBuilder<_PricingData>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 240,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryAccent,
                  ),
                ),
              );
            }
            if (snap.hasError) {
              return _ErrorBlock(
                message: snap.error.toString(),
                onRetry: _refresh,
              );
            }
            final data = snap.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PlansSectionCard(
                  title: 'Tier configuration',
                  subtitle:
                      'Slot ranges + base monthly price per slot. The '
                      'trader-facing tier is auto-derived from their '
                      'chosen quantity at purchase time.',
                  child: _TierTable(
                    configs: data.tiers,
                    onSaved: _refresh,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PlansSectionCard(
                  title: 'Commitment discounts',
                  subtitle:
                      'Discount percentage applied across all tiers per '
                      'commitment length. Set 0 for no discount.',
                  child: _DiscountTable(
                    discounts: data.discounts,
                    onSaved: _refresh,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PricingData {
  final List<PlanTierConfig> tiers;
  final List<CommitmentDiscount> discounts;
  const _PricingData({required this.tiers, required this.discounts});
}

// =============================================================================
//  Tier table
// =============================================================================

class _TierTable extends StatelessWidget {
  final List<PlanTierConfig> configs;
  final VoidCallback onSaved;

  const _TierTable({required this.configs, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TierTableHeader(),
        const Divider(height: 1, color: AppColors.surfaceBorder),
        for (var i = 0; i < configs.length; i++) ...[
          _TierRow(
            initial: configs[i],
            onSaved: onSaved,
          ),
          if (i != configs.length - 1)
            const Divider(height: 1, color: AppColors.surfaceBorder),
        ],
      ],
    );
  }
}

class _TierTableHeader extends StatelessWidget {
  const _TierTableHeader();

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.labelSmall.copyWith(
      color: AppColors.textMuted,
      fontSize: 10,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('TIER', style: style)),
          Expanded(flex: 2, child: Text('MIN SLOTS', style: style)),
          Expanded(flex: 2, child: Text('MAX SLOTS', style: style)),
          Expanded(flex: 3, child: Text('BASE PRICE / SLOT / MONTH', style: style)),
          const SizedBox(width: 110),
        ],
      ),
    );
  }
}

class _TierRow extends StatefulWidget {
  final PlanTierConfig initial;
  final VoidCallback onSaved;

  const _TierRow({required this.initial, required this.onSaved});

  @override
  State<_TierRow> createState() => _TierRowState();
}

class _TierRowState extends State<_TierRow> {
  late final TextEditingController _minCtrl;
  late final TextEditingController _maxCtrl;
  late final TextEditingController _priceCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _minCtrl = TextEditingController(text: widget.initial.minSlots.toString());
    _maxCtrl = TextEditingController(
      text: widget.initial.maxSlots?.toString() ?? '',
    );
    _priceCtrl = TextEditingController(
      text: widget.initial.basePricePerSlot.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final minSlots = int.tryParse(_minCtrl.text.trim());
    final maxText = _maxCtrl.text.trim();
    final maxSlots = maxText.isEmpty ? null : int.tryParse(maxText);
    final price = double.tryParse(_priceCtrl.text.trim());
    if (minSlots == null || price == null) {
      _toast('Min slots and base price are required.');
      return;
    }
    if (maxText.isNotEmpty && maxSlots == null) {
      _toast('Max slots must be a number or blank.');
      return;
    }
    setState(() => _saving = true);
    try {
      await context.read<SubscriptionRepository>().updateTierConfig(
            tier: widget.initial.tier,
            minSlots: minSlots,
            maxSlots: maxSlots,
            basePricePerSlot: price,
          );
      if (!mounted) return;
      _toast('${widget.initial.tier.displayLabel} saved.');
      widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      _toast('Save failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              widget.initial.tier.displayLabel,
              style: AppTypography.titleMedium.copyWith(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: _IntField(controller: _minCtrl),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 2,
            child: _IntField(
              controller: _maxCtrl,
              hint: 'unlimited',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 3,
            child: _DecimalField(controller: _priceCtrl, prefix: '\$'),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.textOnDark,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textOnDark,
                      ),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Discount table
// =============================================================================

class _DiscountTable extends StatelessWidget {
  final List<CommitmentDiscount> discounts;
  final VoidCallback onSaved;

  const _DiscountTable({required this.discounts, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DiscountTableHeader(),
        const Divider(height: 1, color: AppColors.surfaceBorder),
        for (var i = 0; i < discounts.length; i++) ...[
          _DiscountRow(initial: discounts[i], onSaved: onSaved),
          if (i != discounts.length - 1)
            const Divider(height: 1, color: AppColors.surfaceBorder),
        ],
      ],
    );
  }
}

class _DiscountTableHeader extends StatelessWidget {
  const _DiscountTableHeader();

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.labelSmall.copyWith(
      color: AppColors.textMuted,
      fontSize: 10,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('COMMITMENT', style: style)),
          Expanded(flex: 4, child: Text('DISCOUNT %', style: style)),
          const SizedBox(width: 110),
        ],
      ),
    );
  }
}

class _DiscountRow extends StatefulWidget {
  final CommitmentDiscount initial;
  final VoidCallback onSaved;

  const _DiscountRow({required this.initial, required this.onSaved});

  @override
  State<_DiscountRow> createState() => _DiscountRowState();
}

class _DiscountRowState extends State<_DiscountRow> {
  late final TextEditingController _ctrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: widget.initial.discountPercent.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final pct = double.tryParse(_ctrl.text.trim());
    if (pct == null || pct < 0 || pct > 100) {
      _toast('Discount must be a number between 0 and 100.');
      return;
    }
    setState(() => _saving = true);
    try {
      await context.read<SubscriptionRepository>().updateCommitmentDiscount(
            commitmentMonths: widget.initial.commitmentMonths,
            discountPercent: pct,
          );
      if (!mounted) return;
      _toast('${_label(widget.initial.commitmentMonths)} discount saved.');
      widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      _toast('Save failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              _label(widget.initial.commitmentMonths),
              style: AppTypography.titleMedium.copyWith(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 4,
            child: _DecimalField(controller: _ctrl, suffix: '%'),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.textOnDark,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textOnDark,
                      ),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  String _label(int months) {
    switch (months) {
      case 1:
        return 'Monthly';
      case 3:
        return '3 Months';
      case 6:
        return '6 Months';
      case 12:
        return 'Yearly';
      default:
        return '$months Months';
    }
  }
}

// =============================================================================
//  Shared field widgets
// =============================================================================

class _IntField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  const _IntField({required this.controller, this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: _decoration(hint: hint),
    );
  }
}

class _DecimalField extends StatelessWidget {
  final TextEditingController controller;
  final String? prefix;
  final String? suffix;
  const _DecimalField({
    required this.controller,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      decoration: _decoration(prefix: prefix, suffix: suffix),
    );
  }
}

InputDecoration _decoration({String? hint, String? prefix, String? suffix}) {
  return InputDecoration(
    isDense: true,
    hintText: hint,
    prefixText: prefix,
    suffixText: suffix,
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

class _ErrorBlock extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBlock({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.loss, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text("Couldn't load pricing config", style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
