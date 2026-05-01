import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/active_follow.dart';
import 'package:qp_core/domain/master_listing.dart';
import 'package:qp_core/domain/provider_profile.dart';
import 'package:qp_core/repositories/signal_directory_repository.dart';
import 'package:qp_core/repositories/trader_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import '../follow/configure_follow_sheet.dart';
import 'widgets/activity_table.dart';
import 'widgets/equity_chart.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_window_tabs.dart';
import 'widgets/stats_table.dart';
import 'widgets/symbol_distribution.dart';

/// Provider Profile — full performance picture for a single signal
/// provider.
///
/// Layout, top to bottom:
///   1. Page header (back button + breadcrumb)
///   2. Profile header card — avatar, identity, tagline, Follow CTA,
///      min deposit, tradingSince
///   3. Window tabs (1W / 1M / 3M / 1Y) — selecting a window re-fetches
///      the equity history + recomputes the gain on the header
///   4. Equity vs Balance line chart (centerpiece)
///   5. Side-by-side: Stats table + Symbol distribution donut
///   6. Trading activity table
///   7. Legal disclaimer footer
///
/// Pulls everything from [SignalDirectoryRepository.getProvider]; under
/// D.5 this is the mock repo. Phase E swaps in a Supabase-backed real
/// implementation without changing this widget.
class ProviderProfileScreen extends StatefulWidget {
  final String providerId;

  const ProviderProfileScreen({super.key, required this.providerId});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  TimeWindow _window = TimeWindow.month;
  late Future<_ProfileLoad> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  /// Loads the profile + counts how many of the trader's slaves are
  /// currently following this master. The count drives the
  /// "Following with N slave(s)" chip below the Follow CTA.
  Future<_ProfileLoad> _load() async {
    final dir = context.read<SignalDirectoryRepository>();
    final trader = context.read<TraderRepository>();
    final results = await Future.wait([
      dir.getProvider(widget.providerId, window: _window),
      trader.listActiveFollows(),
    ]);
    final profile = results[0] as ProviderProfile;
    final follows = results[1] as List<ActiveFollow>;
    final masterId = profile.summary.masterAccountId;
    final existing = masterId == null
        ? 0
        : follows.where((f) => f.masterAccountId == masterId).length;
    return _ProfileLoad(profile: profile, existingFollowsCount: existing);
  }

  void _changeWindow(TimeWindow w) {
    if (w == _window) return;
    setState(() {
      _window = w;
      _future = _load();
    });
  }

  void _openFollow(MasterListing master) {
    showConfigureFollowSheet(context, master: master);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      body: FutureBuilder<_ProfileLoad>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const _Loading();
          }
          if (snap.hasError) {
            return _ErrorState(
              message: snap.error.toString(),
              onBack: () => Navigator.of(context).pop(),
            );
          }
          final load = snap.data!;
          return _ProfileBody(
            profile: load.profile,
            existingFollowsCount: load.existingFollowsCount,
            window: _window,
            onWindowChanged: _changeWindow,
            onFollow: () => _openFollow(load.profile.summary),
            onBack: () => Navigator.of(context).pop(),
          );
        },
      ),
    );
  }
}

class _ProfileLoad {
  final ProviderProfile profile;
  final int existingFollowsCount;
  const _ProfileLoad({
    required this.profile,
    required this.existingFollowsCount,
  });
}

class _ProfileBody extends StatelessWidget {
  final ProviderProfile profile;
  final int existingFollowsCount;
  final TimeWindow window;
  final ValueChanged<TimeWindow> onWindowChanged;
  final VoidCallback onFollow;
  final VoidCallback onBack;

  const _ProfileBody({
    required this.profile,
    required this.existingFollowsCount,
    required this.window,
    required this.onWindowChanged,
    required this.onFollow,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= AppSpacing.desktopMin;
    final hPad = isDesktop
        ? AppSpacing.x3
        : (width >= AppSpacing.tabletMin ? AppSpacing.xxl : AppSpacing.lg);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        hPad,
        AppSpacing.xl,
        hPad,
        AppSpacing.x3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Breadcrumb(
            displayName: profile.summary.displayName,
            onBack: onBack,
          ),
          const SizedBox(height: AppSpacing.lg),
          ProfileHeader(
            listing: profile.summary,
            existingFollowsCount: existingFollowsCount,
            onFollow: onFollow,
          ),
          const SizedBox(height: AppSpacing.xxl),
          ProfileWindowTabs(
            window: window,
            onChanged: onWindowChanged,
          ),
          const SizedBox(height: AppSpacing.lg),
          _Section(
            title: 'Equity vs Balance',
            subtitle: 'Equity tracks live P&L; balance is realised only. '
                'Markers show deposits / withdrawals.',
            child: EquityChart(
              points: profile.equityHistory,
              currency: profile.summary.currency,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _StatsAndSymbols(
            stats: profile.stats,
            distribution: profile.symbolDistribution,
            isDesktop: isDesktop,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _Section(
            title: 'Recent activity',
            subtitle: 'Last 12 trades. Open positions are listed first.',
            child: ActivityTable(activity: profile.recentActivity),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _Disclaimer(),
        ],
      ),
    );
  }
}

class _StatsAndSymbols extends StatelessWidget {
  final ProviderStats stats;
  final Map<String, double> distribution;
  final bool isDesktop;

  const _StatsAndSymbols({
    required this.stats,
    required this.distribution,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final statsCard = _Section(
      title: 'Performance stats',
      subtitle: 'Computed across the selected window.',
      child: StatsTable(stats: stats),
    );
    final symbolsCard = _Section(
      title: 'Symbol distribution',
      subtitle: 'Share of total volume traded by symbol.',
      child: SymbolDistribution(distribution: distribution),
    );
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: statsCard),
          const SizedBox(width: AppSpacing.lg),
          Expanded(flex: 2, child: symbolsCard),
        ],
      );
    }
    return Column(
      children: [
        statsCard,
        const SizedBox(height: AppSpacing.lg),
        symbolsCard,
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final String displayName;
  final VoidCallback onBack;

  const _Breadcrumb({required this.displayName, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppSpacing.tabletMin;
    // 44dp on mobile to clear the Material touch-target floor; pointer
    // precision is high on desktop so we keep the breadcrumb compact
    // there for visual rhythm.
    final hPad = isMobile ? AppSpacing.md : AppSpacing.sm;
    final vPad = isMobile ? AppSpacing.md : 4.0;
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad,
              vertical: vPad,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Discover',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        const Text(
          '/',
          style: TextStyle(color: AppColors.textMuted),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            displayName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _Section({
    required this.title,
    required this.child,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleLarge),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle!, style: AppTypography.bodySmall),
          ],
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
            size: 18,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Past performance is not indicative of future results. '
              'Copy-trading carries risk including possible loss of '
              'principal. QuantumPips does not provide investment advice; '
              'all trades are executed at your discretion via the slave '
              'account you bind to a provider.',
              style: AppTypography.bodySmall.copyWith(height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryAccent),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onBack;

  const _ErrorState({required this.message, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.loss,
            ),
            const SizedBox(height: AppSpacing.md),
            Text("Couldn't load this provider", style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(message, style: AppTypography.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            TextButton(
              onPressed: onBack,
              child: const Text('Back to Discover'),
            ),
          ],
        ),
      ),
    );
  }
}
