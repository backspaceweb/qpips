import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/account_ownership.dart';
import 'package:qp_core/domain/provider_listing.dart';
import 'package:qp_core/repositories/provider_listing_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

/// Apply / edit / resubmit a master account for the public Discover
/// directory. The dialog adapts to the listing's current status:
///
///   - no listing yet: blank application form, button "Submit application"
///   - pending: edit form, button "Update application", helper banner
///   - approved: edit form, helper banner ("Your changes are visible
///     immediately on Discover" — operator-set fields are read-only)
///   - rejected: edit form + rejection reason banner, button "Resubmit"
///
/// Trader-controlled fields (display_name, bio, min_deposit, currency)
/// are always editable; operator-controlled fields (tier, risk_score,
/// gain_pct, drawdown_pct) are display-only because they're set via
/// the admin approval RPC.
class ProviderApplicationDialog extends StatefulWidget {
  final AccountOwnership master;
  final ProviderListing? existing;
  final VoidCallback onSaved;

  const ProviderApplicationDialog({
    super.key,
    required this.master,
    required this.existing,
    required this.onSaved,
  });

  @override
  State<ProviderApplicationDialog> createState() =>
      _ProviderApplicationDialogState();
}

class _ProviderApplicationDialogState
    extends State<ProviderApplicationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _minDepositCtrl;
  late final TextEditingController _currencyCtrl;

  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final ex = widget.existing;
    _nameCtrl = TextEditingController(
      text: ex?.displayName ??
          widget.master.displayName ??
          widget.master.loginNumber,
    );
    _bioCtrl = TextEditingController(text: ex?.bio ?? '');
    _minDepositCtrl = TextEditingController(
      text: ex?.minDeposit?.toStringAsFixed(0) ?? '',
    );
    _currencyCtrl = TextEditingController(text: ex?.currency ?? 'USD');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _minDepositCtrl.dispose();
    _currencyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final repo = context.read<ProviderListingRepository>();
      final ex = widget.existing;
      final minDeposit = _minDepositCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(_minDepositCtrl.text.trim());
      final currency = _currencyCtrl.text.trim().isEmpty
          ? 'USD'
          : _currencyCtrl.text.trim().toUpperCase();
      final bio = _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim();

      if (ex == null) {
        await repo.apply(
          masterAccountId: widget.master.tradingAccountId,
          displayName: _nameCtrl.text.trim(),
          bio: bio,
          minDeposit: minDeposit,
          currency: currency,
        );
      } else {
        await repo.update(
          listingId: ex.id,
          displayName: _nameCtrl.text.trim(),
          bio: bio,
          minDeposit: minDeposit,
          currency: currency,
        );
        if (ex.status == ProviderListingStatus.rejected) {
          await repo.resubmit(ex.id);
        }
      }
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = 'Could not save application: $e';
      });
    }
  }

  String get _title {
    final ex = widget.existing;
    if (ex == null) return 'Apply as Provider';
    return switch (ex.status) {
      ProviderListingStatus.pending => 'Edit pending application',
      ProviderListingStatus.approved => 'Edit listing',
      ProviderListingStatus.rejected => 'Resubmit application',
    };
  }

  String get _ctaLabel {
    final ex = widget.existing;
    if (ex == null) return 'Submit application';
    return switch (ex.status) {
      ProviderListingStatus.pending => 'Update application',
      ProviderListingStatus.approved => 'Save changes',
      ProviderListingStatus.rejected => 'Resubmit',
    };
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.existing;
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_title, style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Master #${widget.master.loginNumber} · '
                  '${widget.master.platform.wireValue}',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (ex != null) _StatusBanner(listing: ex),
                if (ex != null) const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: _decoration(
                    label: 'Display name',
                    icon: Icons.storefront_outlined,
                  ),
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return 'Display name is required';
                    if (s.length < 3) return 'At least 3 characters';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _bioCtrl,
                  maxLines: 4,
                  maxLength: 500,
                  decoration: _decoration(
                    label: 'Bio (visible on your provider profile)',
                    icon: Icons.notes_outlined,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minDepositCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _decoration(
                          label: 'Min deposit',
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                        validator: (v) {
                          final s = v?.trim() ?? '';
                          if (s.isEmpty) return null;
                          final n = double.tryParse(s);
                          if (n == null || n < 0) return 'Invalid number';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        controller: _currencyCtrl,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 3,
                        decoration: _decoration(
                          label: 'Currency',
                          icon: Icons.attach_money,
                        ),
                      ),
                    ),
                  ],
                ),
                if (ex?.status == ProviderListingStatus.approved)
                  _OperatorReadOnly(listing: ex!),
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
                        label: _ctaLabel,
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

class _StatusBanner extends StatelessWidget {
  final ProviderListing listing;
  const _StatusBanner({required this.listing});

  @override
  Widget build(BuildContext context) {
    final (color, icon, headline, body) = switch (listing.status) {
      ProviderListingStatus.pending => (
          AppColors.warning,
          Icons.hourglass_empty,
          'Pending review',
          'Operator team is reviewing your application. You can edit '
              'the details below in the meantime.',
        ),
      ProviderListingStatus.approved => (
          AppColors.profit,
          Icons.verified,
          'Approved',
          'Your provider listing is live on Discover. Edits to display '
              'name and bio are visible immediately; tier and stats are '
              'set by the operator.',
        ),
      ProviderListingStatus.rejected => (
          AppColors.loss,
          Icons.cancel_outlined,
          'Rejected',
          listing.rejectionReason?.isNotEmpty == true
              ? listing.rejectionReason!
              : 'Your application was rejected. Update the details and '
                  'resubmit.',
        ),
    };
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: AppTypography.titleMedium.copyWith(
                    color: color,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OperatorReadOnly extends StatelessWidget {
  final ProviderListing listing;
  const _OperatorReadOnly({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operator-set details',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _row('Tier', listing.tier?.name.toUpperCase() ?? '—'),
            _row('Risk', listing.riskScore?.name.toUpperCase() ?? '—'),
            _row(
              'Gain',
              listing.gainPct == null
                  ? '—'
                  : '${(listing.gainPct! * 100).toStringAsFixed(2)}%',
            ),
            _row(
              'Drawdown',
              listing.drawdownPct == null
                  ? '—'
                  : '${(listing.drawdownPct! * 100).toStringAsFixed(2)}%',
            ),
            _row('Followers', listing.followersCount.toString()),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
