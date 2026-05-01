import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/repositories/provider_listing_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import 'package:qp_design/widgets/primary_button.dart';

import '../provider_reviews_screen.dart' show EnrichedListing;

/// Approve dialog — operator sets the curated fields (tier, risk score,
/// performance snapshot, follower count). Calls the
/// approve_provider_listing RPC; row's status flips to 'approved'.
class ApproveDialog extends StatefulWidget {
  final EnrichedListing item;
  const ApproveDialog({super.key, required this.item});

  @override
  State<ApproveDialog> createState() => _ApproveDialogState();
}

class _ApproveDialogState extends State<ApproveDialog> {
  final _formKey = GlobalKey<FormState>();
  String _tier = 'silver';
  String _riskScore = 'medium';
  final _gainCtrl = TextEditingController();
  final _drawdownCtrl = TextEditingController();
  final _followersCtrl = TextEditingController(text: '0');
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _gainCtrl.dispose();
    _drawdownCtrl.dispose();
    _followersCtrl.dispose();
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
      // UI accepts percentage values (e.g. 5.32 for +5.32%); store as
      // fraction (0.0532) to match the domain convention used by the
      // Discover surface.
      final gainPct = (double.tryParse(_gainCtrl.text.trim()) ?? 0) / 100.0;
      final ddPct =
          (double.tryParse(_drawdownCtrl.text.trim()) ?? 0) / 100.0;
      final followers = int.tryParse(_followersCtrl.text.trim()) ?? 0;
      await repo.approve(
        listingId: widget.item.listing.id,
        tier: _tier,
        riskScore: _riskScore,
        gainPct: gainPct,
        drawdownPct: ddPct,
        followersCount: followers,
      );
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop(true);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Approved “${widget.item.listing.displayName}”.'),
          backgroundColor: AppColors.profit,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = 'Approval failed: $e';
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Approve listing', style: AppTypography.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.item.listing.displayName,
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xl),
                DropdownButtonFormField<String>(
                  value: _tier,
                  decoration: _decoration(label: 'Tier'),
                  items: const [
                    DropdownMenuItem(value: 'bronze', child: Text('Bronze')),
                    DropdownMenuItem(value: 'silver', child: Text('Silver')),
                    DropdownMenuItem(value: 'gold', child: Text('Gold')),
                    DropdownMenuItem(value: 'diamond', child: Text('Diamond')),
                  ],
                  onChanged: (v) => setState(() => _tier = v ?? _tier),
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _riskScore,
                  decoration: _decoration(label: 'Risk score'),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                  ],
                  onChanged: (v) =>
                      setState(() => _riskScore = v ?? _riskScore),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _gainCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: _decoration(label: 'Gain % (e.g. 5.32)'),
                        validator: _numericValidator,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _drawdownCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration:
                            _decoration(label: 'Drawdown % (e.g. -8.50)'),
                        validator: _numericValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _followersCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _decoration(label: 'Followers count'),
                  validator: (v) {
                    final s = v?.trim() ?? '';
                    if (s.isEmpty) return null;
                    final n = int.tryParse(s);
                    if (n == null || n < 0) return 'Whole number, ≥ 0';
                    return null;
                  },
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
                            : () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Approve',
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

  String? _numericValidator(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Required';
    if (double.tryParse(s) == null) return 'Must be numeric';
    return null;
  }

  InputDecoration _decoration({required String label}) {
    return InputDecoration(
      labelText: label,
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
