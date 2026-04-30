import 'package:flutter/material.dart';
import '../../../../design/app_colors.dart';
import '../../../../design/app_spacing.dart';
import '../../../../design/app_typography.dart';
import '../../../../design/widgets/eyebrow.dart';
import '../../../../design/widgets/fade_in_on_scroll.dart';
import '../../../../design/widgets/section_container.dart';

/// Frequently asked questions — accordion list.
///
/// Constrained to a narrow column; each item is collapsible. First item
/// open by default to invite interaction.
class LandingFaq extends StatelessWidget {
  const LandingFaq({super.key});

  static const _items = <_FaqItem>[
    _FaqItem(
      question: 'How does copy trading work on QuantumPips?',
      answer:
          'You connect a master account (the source of trades) and one or '
          'more slave accounts (which mirror them). When the master opens '
          'or closes a position, every slave following them executes the '
          'same trade automatically — scaled to your configured risk '
          'multiplier and within your stop-loss and order-control rules.',
    ),
    _FaqItem(
      question: 'Which brokers and platforms are supported?',
      answer:
          'MT4, MT5, cTrader, DxTrade, TradeLocker, and MatchTrade. '
          'Master and slaves can be on different platforms — '
          'QuantumPips translates symbols and handles the lot scaling '
          'so cross-broker copying just works.',
    ),
    _FaqItem(
      question: 'Do I need a VPS or to keep my computer on?',
      answer:
          'No. Trades are mirrored on our FIX-API backend, not from your '
          'browser. Once your accounts are linked, copying runs 24/7 '
          'whether your laptop is asleep or on the other side of the '
          'planet.',
    ),
    _FaqItem(
      question: 'How fast is the copy execution?',
      answer:
          'Average copy latency from master to slave is around 50ms via '
          'our FIX-API backend. Latency varies with broker connectivity '
          'but is well within the window required for scalping and '
          'short-term strategies.',
    ),
    _FaqItem(
      question: 'Is my broker password safe?',
      answer:
          'QuantumPips uses investor-style API credentials supplied by '
          'your broker, not your master trading password. We never see '
          'your withdrawal password, and authenticated sessions use '
          'Supabase JWT with row-level security — your data is isolated '
          'per user, no shared API keys in any client bundle.',
    ),
    _FaqItem(
      question: 'Can I cancel or change tiers?',
      answer:
          'Yes — tiers are month-to-month and switch immediately. '
          'Downgrading reduces the number of slave accounts and '
          'masters you can follow at the next billing cycle; nothing is '
          'closed for you automatically.',
    ),
    _FaqItem(
      question: 'Do I keep control of my trades?',
      answer:
          'Always. Each slave has its own settings: risk multiplier, '
          'copy SL/TP toggle, scalper mode, order filter, and per-account '
          'auto-close triggers. You can pause or unfollow a master '
          'instantly without affecting your existing positions.',
    ),
    _FaqItem(
      question: 'Where is the mobile app?',
      answer:
          'iOS and Android apps for traders are in active development and '
          'will land alongside the public launch. The web app works on '
          'mobile browsers today.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      backgroundColor: AppColors.surfaceMuted,
      maxWidth: 820,
      child: Column(
        children: [
          const FadeInOnScroll(child: Eyebrow('FAQ')),
          const SizedBox(height: AppSpacing.lg),
          FadeInOnScroll(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'Questions, answered.',
              style: AppTypography.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < _items.length; i++)
            FadeInOnScroll(
              delay: Duration(milliseconds: 120 + i * 60),
              child: _FaqTile(
                item: _items[i],
                initiallyOpen: i == 0,
              ),
            ),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}

class _FaqTile extends StatefulWidget {
  final _FaqItem item;
  final bool initiallyOpen;
  const _FaqTile({required this.item, required this.initiallyOpen});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile>
    with SingleTickerProviderStateMixin {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: InkWell(
          onTap: () => setState(() => _open = !_open),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.item.question,
                        style: AppTypography.titleLarge,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  child: _open
                      ? Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.md),
                          child: Text(
                            widget.item.answer,
                            style: AppTypography.bodyMedium,
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
