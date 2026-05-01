import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';

/// Bottom sheet with manual deposit instructions. Used by both the
/// Wallet tab's "Top up" button and the Plans tab's wallet-balance row.
///
/// Stripe-funded auto-confirmation lands later; today the operator
/// confirms deposits manually via the admin Wallets screen.
Future<void> showTopUpSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
    ),
    builder: (_) => const _TopUpInstructions(),
  );
}

class _TopUpInstructions extends StatelessWidget {
  const _TopUpInstructions();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Top up your wallet',
                    style: AppTypography.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Send any amount via the channels below. Once we receive '
              "your payment, we'll credit your wallet within one business "
              "day. You'll see the deposit appear here as a transaction.",
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bank transfer', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Bank: [Operator to fill in]\n'
                    'Account name: [Operator to fill in]\n'
                    'Account number: [Operator to fill in]\n'
                    'Reference: your registered email',
                    style: AppTypography.bodySmall.copyWith(
                      fontFamily: AppTypography.monoFontFamily,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Stripe Checkout for instant top-up lands soon. For now, '
              'send a message to support@quantumpips.app with your '
              "transfer reference and we'll confirm within a few hours.",
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
