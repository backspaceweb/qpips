import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/plan_tier.dart';
import 'package:qp_core/domain/user_subscription.dart';
import 'package:qp_core/domain/wallet.dart';
import 'package:qp_core/repositories/subscription_repository.dart';
import 'package:qp_core/repositories/wallet_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

import '../wallet/widgets/top_up_sheet.dart';

/// Plans tab — three pricing cards side-by-side (Start / Pro / Premium).
///
/// Renders as a tab body inside [TraderShell] (no AppBar of its own —
/// the shell owns navigation chrome). Each tier card is self-contained:
/// its own qty stepper (clamped to the tier's slot range), commitment
/// selector, live total, and Buy button.
///
/// On successful book_slots: re-fetch wallet + tiers (so the inline
/// wallet header reflects the new balance) and show a snackbar. The
/// trader's Wallet tab has the active-subscriptions list + transaction
/// history; we don't auto-navigate there.
///
/// Tier feature lists are hardcoded marketing copy — gating is
/// marketing-only today, so every tier behaves identically server-side.
class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  Future<_PlansData>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_PlansData> _load() async {
    final subs = context.read<SubscriptionRepository>();
    final walletRepo = context.read<WalletRepository>();
    final results = await Future.wait([
      subs.listTierConfigs(),
      subs.listCommitmentDiscounts(),
      walletRepo.getMyWallet(),
    ]);
    return _PlansData(
      tiers: results[0] as List<PlanTierConfig>,
      discounts: results[1] as List<CommitmentDiscount>,
      wallet: results[2] as Wallet?,
    );
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  void _onBooked(BookSlotsResult result) {
    _refresh();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Slots booked. New wallet balance: USD '
          '${result.newWalletBalance.toStringAsFixed(2)}.',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryAccent,
      onRefresh: () async {
        _refresh();
        await _future;
      },
      child: FutureBuilder<_PlansData>(
        future: _future,
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
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  "Couldn't load pricing: ${snap.error}",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.loss,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final data = snap.data!;
          return _Body(data: data, onBooked: _onBooked);
        },
      ),
    );
  }
}

class _PlansData {
  final List<PlanTierConfig> tiers;
  final List<CommitmentDiscount> discounts;
  final Wallet? wallet;
  const _PlansData({
    required this.tiers,
    required this.discounts,
    required this.wallet,
  });
}

class _Body extends StatelessWidget {
  final _PlansData data;
  final ValueChanged<BookSlotsResult> onBooked;

  const _Body({required this.data, required this.onBooked});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= AppSpacing.desktopMin;
    final hPad = isWide
        ? AppSpacing.x3
        : (width >= AppSpacing.tabletMin ? AppSpacing.xxl : AppSpacing.lg);

    final tiersInOrder = [...data.tiers]
      ..sort((a, b) => a.minSlots.compareTo(b.minSlots));

    final cards = [
      for (final t in tiersInOrder)
        _TierCard(
          config: t,
          discounts: data.discounts,
          wallet: data.wallet,
          features: _featuresFor(t.tier),
          onBooked: onBooked,
        ),
    ];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plans', style: AppTypography.headlineLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Buy slot subscriptions from your wallet. Each slot lets you '
            'connect one master or slave account; tier is auto-derived '
            'from the quantity you pick.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          if (data.wallet != null) ...[
            _WalletHeader(wallet: data.wallet!),
            const SizedBox(height: AppSpacing.xl),
          ],
          if (isWide)
            // IntrinsicHeight bounds the Row's vertical extent to the
            // tallest card; without it, stretch + SingleChildScrollView
            // gives infinite height and the page renders blank.
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    Expanded(child: cards[i]),
                    if (i != cards.length - 1)
                      const SizedBox(width: AppSpacing.lg),
                  ],
                ],
              ),
            )
          else
            Column(
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  cards[i],
                  if (i != cards.length - 1)
                    const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
          const SizedBox(height: AppSpacing.xl),
          _LegalBlurb(),
        ],
      ),
    );
  }

  List<String> _featuresFor(PlanTier tier) {
    const baseline = [
      'Partial close (MT4/MT5)',
      'Copy pending orders',
      'SL/TP copy updates',
      'Global settings',
      'Symbol mapping',
      'Prefix/suffix mapping',
    ];
    switch (tier) {
      case PlanTier.start:
        return baseline;
      case PlanTier.pro:
        return [...baseline, 'Scalper mode'];
      case PlanTier.premium:
        return [...baseline, 'Scalper mode', 'Split order'];
    }
  }
}

// =============================================================================
//  Wallet header
// =============================================================================

class _WalletHeader extends StatelessWidget {
  final Wallet wallet;
  const _WalletHeader({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Wallet balance',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          Text(
            '${wallet.currency} ${wallet.balance.toStringAsFixed(2)}',
            style: AppTypography.titleLarge.copyWith(
              fontSize: 18,
              color: AppColors.primary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () => showTopUpSheet(context),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Top up'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnDark,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              textStyle: AppTypography.labelLarge.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
//  Tier card — self-contained per-tier pricing UI
// =============================================================================

class _TierCard extends StatefulWidget {
  final PlanTierConfig config;
  final List<CommitmentDiscount> discounts;
  final Wallet? wallet;
  final List<String> features;
  final ValueChanged<BookSlotsResult> onBooked;

  const _TierCard({
    required this.config,
    required this.discounts,
    required this.wallet,
    required this.features,
    required this.onBooked,
  });

  @override
  State<_TierCard> createState() => _TierCardState();
}

class _TierCardState extends State<_TierCard> {
  late int _qty;
  int _commitmentMonths = 1;
  bool _submitting = false;
  late final TextEditingController _qtyCtrl;

  @override
  void initState() {
    super.initState();
    _qty = widget.config.minSlots;
    _qtyCtrl = TextEditingController(text: _qty.toString());
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  int get _maxAllowed => widget.config.maxSlots ?? 100000;

  void _setQty(int next) {
    final clamped = next.clamp(widget.config.minSlots, _maxAllowed);
    setState(() => _qty = clamped);
    if (_qtyCtrl.text != clamped.toString()) {
      _qtyCtrl.text = clamped.toString();
    }
  }

  double? _computeTotal() => computeSubscriptionCost(
        slotCount: _qty,
        commitmentMonths: _commitmentMonths,
        tierConfigs: [widget.config],
        discounts: widget.discounts,
      );

  Future<void> _confirm() async {
    final total = _computeTotal();
    if (total == null) return;
    final wallet = widget.wallet;
    if (wallet == null || wallet.balance < total) {
      _toast('Insufficient wallet balance for this purchase.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: Text(
          'Confirm ${widget.config.tier.displayLabel} purchase',
          style: AppTypography.titleLarge,
        ),
        content: Text(
          '$_qty slots × ${_commitmentLabel(_commitmentMonths)}'
          '\n\nTotal: ${wallet.currency} '
          '${total.toStringAsFixed(2)} from wallet.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryAccent,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _submitting = true);
    try {
      final result =
          await context.read<SubscriptionRepository>().bookSlots(
                slotCount: _qty,
                commitmentMonths: _commitmentMonths,
              );
      if (!mounted) return;
      setState(() => _submitting = false);
      widget.onBooked(result);
    } catch (e) {
      if (!mounted) return;
      _toast('Booking failed: $e');
      setState(() => _submitting = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    final total = _computeTotal();
    final balance = widget.wallet?.balance ?? 0;
    final canBuy = total != null && balance >= total && !_submitting;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(cfg.tier.displayLabel, style: AppTypography.titleLarge),
          const SizedBox(height: 4),
          Text(
            '${cfg.minSlots}'
            '${cfg.maxSlots == null ? '+ accounts' : '–${cfg.maxSlots} accounts'}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${cfg.basePricePerSlot.toStringAsFixed(2)}',
                style: AppTypography.numericMedium.copyWith(
                  fontSize: 30,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'per slot · monthly',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final f in widget.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.primaryAccent,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      f,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1, color: AppColors.surfaceBorder),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'SLOTS',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              _StepperButton(
                icon: Icons.remove,
                onTap: _qty > cfg.minSlots ? () => _setQty(_qty - 1) : null,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _qtyCtrl,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: AppTypography.titleLarge.copyWith(fontSize: 18),
                  decoration: _decoration(),
                  onSubmitted: (s) {
                    final v = int.tryParse(s);
                    if (v != null) _setQty(v);
                  },
                  onChanged: (s) {
                    final v = int.tryParse(s);
                    if (v != null && v >= cfg.minSlots && v <= _maxAllowed) {
                      setState(() => _qty = v);
                    }
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StepperButton(
                icon: Icons.add,
                onTap: _qty < _maxAllowed ? () => _setQty(_qty + 1) : null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'COMMITMENT',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _CommitmentGrid(
            value: _commitmentMonths,
            discounts: widget.discounts,
            onChanged: (v) => setState(() => _commitmentMonths = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1, color: AppColors.surfaceBorder),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text('Total', style: AppTypography.bodyMedium),
              ),
              Text(
                total == null
                    ? '—'
                    : '${widget.wallet?.currency ?? 'USD'} '
                        '${total.toStringAsFixed(2)}',
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 20,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canBuy ? _confirm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.textOnDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textOnDark,
                      ),
                    )
                  : Text(
                      total == null || balance >= total
                          ? 'Buy ${cfg.tier.displayLabel}'
                          : 'Top up wallet first',
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _commitmentLabel(int months) {
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
//  Commitment grid
// =============================================================================

class _CommitmentGrid extends StatelessWidget {
  final int value;
  final List<CommitmentDiscount> discounts;
  final ValueChanged<int> onChanged;

  const _CommitmentGrid({
    required this.value,
    required this.discounts,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...discounts]
      ..sort((a, b) => a.commitmentMonths.compareTo(b.commitmentMonths));

    return Column(
      children: [
        for (var i = 0; i < sorted.length; i += 2)
          Padding(
            padding: EdgeInsets.only(
              bottom: i + 2 < sorted.length ? AppSpacing.sm : 0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _CommitmentChoice(
                    label: _label(sorted[i].commitmentMonths),
                    discount: sorted[i].discountPercent,
                    active: value == sorted[i].commitmentMonths,
                    onTap: () => onChanged(sorted[i].commitmentMonths),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: i + 1 < sorted.length
                      ? _CommitmentChoice(
                          label: _label(sorted[i + 1].commitmentMonths),
                          discount: sorted[i + 1].discountPercent,
                          active: value == sorted[i + 1].commitmentMonths,
                          onTap: () =>
                              onChanged(sorted[i + 1].commitmentMonths),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
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

class _CommitmentChoice extends StatelessWidget {
  final String label;
  final double discount;
  final bool active;
  final VoidCallback onTap;

  const _CommitmentChoice({
    required this.label,
    required this.discount,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = active ? AppColors.primary : AppColors.surface;
    final fg = active ? AppColors.textOnDark : AppColors.textPrimary;
    final borderColor =
        active ? AppColors.primary : AppColors.surfaceBorder;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: fg,
                  fontSize: 12,
                  letterSpacing: 0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (discount > 0)
                Text(
                  '-${_fmtDiscount(discount)}%',
                  style: AppTypography.labelSmall.copyWith(
                    color: active
                        ? AppColors.textOnDarkMuted
                        : AppColors.profit,
                    fontSize: 10,
                    letterSpacing: 0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDiscount(double v) {
    if (v == v.truncateToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(2);
  }
}

// =============================================================================
//  Stepper button + decoration helper
// =============================================================================

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Material(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          width: 36,
          height: 44,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: disabled ? AppColors.textMuted : AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
    );
  }
}

InputDecoration _decoration() {
  return InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
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

// =============================================================================
//  Legal blurb
// =============================================================================

class _LegalBlurb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.textMuted,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Each slot lets you connect one master or slave account. '
              'Auto-renew is on by default — toggle off any subscription '
              'from My Follows to let it expire. Slots that expire stop '
              'mirroring; existing positions stay open until you close '
              'them on the broker side.',
              style: AppTypography.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
