import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/domain/master_listing.dart';
import 'package:qp_core/repositories/signal_directory_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_typography.dart';
import '../follow/configure_follow_sheet.dart';
import '../profile/provider_profile_screen.dart';
import 'widgets/filter_strip.dart';
import 'widgets/provider_card.dart';

/// Signal Discovery — main entry to the trader app.
///
/// Top section: page header + FilterStrip (search / window / sort).
/// Below: responsive grid of ProviderCard tiles populated from
/// SignalDirectoryRepository. Loading shows a centered spinner;
/// empty results render an empty-state card.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  TimeWindow _window = TimeWindow.month;
  String _search = '';
  DirectorySort _sort = DirectorySort.gainDesc;

  late Future<List<MasterListing>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<MasterListing>> _load() {
    final repo = context.read<SignalDirectoryRepository>();
    return repo.listMasters(
      window: _window,
      search: _search,
      sort: _sort,
    );
  }

  void _refilter() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1400
        ? 4
        : width >= AppSpacing.desktopMin
            ? 3
            : width >= AppSpacing.tabletMin
                ? 2
                : 1;
    // Multi-column grids need an explicit aspect ratio so all tiles
    // line up. Single-column mobile stacks as a Column (below) — cards
    // size to intrinsic content there, no rigid ratio.
    const aspectRatio = 0.78;

    final hPad = width >= AppSpacing.desktopMin
        ? AppSpacing.x3
        : width >= AppSpacing.tabletMin
            ? AppSpacing.xxl
            : AppSpacing.lg;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover signal providers',
            style: AppTypography.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Browse providers by performance window. Tap a card to see '
            'the full profile.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilterStrip(
            window: _window,
            onWindowChanged: (w) {
              setState(() => _window = w);
              _refilter();
            },
            search: _search,
            onSearchChanged: (s) {
              _search = s;
              _refilter();
            },
            sort: _sort,
            onSortChanged: (s) {
              setState(() => _sort = s);
              _refilter();
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          FutureBuilder<List<MasterListing>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.x3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryAccent,
                    ),
                  ),
                );
              }
              if (snap.hasError) {
                return _Empty(
                  icon: Icons.error_outline,
                  title: 'Couldn\'t load providers',
                  body: snap.error.toString(),
                );
              }
              final items = snap.data ?? const [];
              if (items.isEmpty) {
                return const _Empty(
                  icon: Icons.search_off,
                  title: 'No providers match',
                  body:
                      'Try a different time window or clear the search.',
                );
              }
              if (crossAxisCount == 1) {
                // SizedBox forces full viewport width — without it the
                // outer SingleChildScrollView's Column hands out
                // unbounded width and `stretch` shrink-wraps to card
                // content (~200px) instead of filling the row.
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        if (i > 0) const SizedBox(height: AppSpacing.lg),
                        ProviderCard(
                          listing: items[i],
                          onTap: () => _openProfile(context, items[i].id),
                          onFollow: () => showConfigureFollowSheet(
                            context,
                            master: items[i],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                  crossAxisSpacing: AppSpacing.lg,
                  mainAxisSpacing: AppSpacing.lg,
                ),
                itemBuilder: (_, i) => ProviderCard(
                  listing: items[i],
                  onTap: () => _openProfile(context, items[i].id),
                  onFollow: () => showConfigureFollowSheet(
                    context,
                    master: items[i],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openProfile(BuildContext context, String providerId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProviderProfileScreen(providerId: providerId),
      ),
    );
  }

}

class _Empty extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _Empty({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textMuted, size: 32),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
