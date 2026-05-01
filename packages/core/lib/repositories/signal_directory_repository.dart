import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/account.dart';
import '../domain/master_listing.dart';
import '../domain/provider_profile.dart';

/// Reads the public signal-provider directory.
///
/// Today (D.5, Option A) the only implementation is
/// [MockSignalDirectoryRepository] which serves deterministic generated
/// data. Phase E adds a `SupabaseSignalDirectoryRepository` that joins
/// `master_listings` (Supabase: public flag + display metadata) with
/// real performance data from `getOrderHistory` calls scoped to the
/// public master accounts.
///
/// The interface is intentionally narrow so the swap is mechanical: no
/// UI code needs to change when we move from mock to real.
abstract class SignalDirectoryRepository {
  /// Returns the discoverable masters, with performance metrics computed
  /// over [window]. [search] filters by display name (case-insensitive
  /// substring). [sort] orders the results.
  Future<List<MasterListing>> listMasters({
    TimeWindow window = TimeWindow.month,
    String? search,
    DirectorySort sort = DirectorySort.gainDesc,
  });

  /// Full profile data for a single provider. Throws
  /// [ProviderNotFoundException] if [id] is unknown.
  Future<ProviderProfile> getProvider(
    String id, {
    TimeWindow window = TimeWindow.month,
  });
}

enum DirectorySort {
  gainDesc('Top gain'),
  drawdownAsc('Lowest drawdown'),
  followersDesc('Most followed'),
  newest('Newest');

  final String label;
  const DirectorySort(this.label);
}

class ProviderNotFoundException implements Exception {
  final String id;
  ProviderNotFoundException(this.id);
  @override
  String toString() => 'ProviderNotFoundException(id=$id)';
}

/// Generates plausible-looking provider data with deterministic
/// randomness — same inputs always return the same output, so demos
/// stay consistent across reloads.
///
/// Built around 20 hand-named "providers" with seeded performance
/// trajectories. Performance numbers vary by [TimeWindow] but stay
/// internally consistent (the 90-day gain is roughly 3× the 30-day
/// gain, etc.).
class MockSignalDirectoryRepository implements SignalDirectoryRepository {
  static const _names = <String>[
    'Aurora Gold Trend',
    'Yoo Trader',
    'AxisTrader V1',
    'Pip Sniper Pro',
    'Equinox FX',
    'Manhattan Macro',
    'Velocity Scalper',
    'Steady State',
    'Onyx Capital',
    'Polaris Hedge',
    'Crimson Pips',
    'Zenith Quant',
    'Atlas Daytrade',
    'Lumen Forex',
    'Helix Trends',
    'Coral Reef FX',
    'Northwind Markets',
    'Vanta Trader',
    'Ember Strategy',
    'Solstice Capital',
  ];

  static const _taglines = <String>[
    'Disciplined trend-following on majors. Risk-first.',
    'Scalper, news-aware, breakout entries.',
    'Mean reversion on G10 pairs. Tight stops.',
    'London-session momentum, structured exits.',
    'Carry + macro overlay. Long-term holds.',
    'Range trader, intraday only. No overnight risk.',
    'Algorithmic, runs 24/5. Symmetric exposure.',
    'Discretionary swing trader. Emphasis on R:R.',
    'High-conviction directional bets. Small position count.',
    'Volatility breakouts on JPY crosses.',
  ];

  static const _brokers = <String>[
    'Exness',
    'IC Markets',
    'Pepperstone',
    'FP Markets',
    'Tickmill',
    'Vantage',
  ];

  static const _platforms = <Platform>[
    Platform.mt5,
    Platform.mt4,
    Platform.ctrader,
    Platform.dxtrade,
  ];

  static const _symbols = <String>[
    'EURUSD',
    'GBPUSD',
    'XAUUSD',
    'USDJPY',
    'AUDUSD',
    'NAS100',
    'BTCUSD',
    'US30',
  ];

  /// Cached generated listings. Lazily built on first access; later
  /// queries filter/sort this in-memory list.
  late final List<MasterListing> _allListings = _generateAll();

  List<MasterListing> _generateAll() {
    final result = <MasterListing>[];
    for (var i = 0; i < _names.length; i++) {
      final rng = Random(_seedFor('listing-$i'));
      final tier = ProviderTier.values[i % ProviderTier.values.length];
      // Risk increases roughly with tier inverse — lower-tier providers
      // tend to have wilder swings in the mock.
      final risk = i % 4 == 0
          ? RiskScore.high
          : (i % 3 == 0 ? RiskScore.medium : RiskScore.low);
      final gain = _gainFor(window: TimeWindow.month, providerIndex: i);
      result.add(
        MasterListing(
          id: 'mock-${i.toString().padLeft(3, '0')}',
          displayName: _names[i],
          tagline: _taglines[i % _taglines.length],
          platform: _platforms[i % _platforms.length],
          broker: _brokers[i % _brokers.length],
          followers: 12 + rng.nextInt(160),
          tier: tier,
          gainFraction: gain,
          drawdownFraction: -(0.04 + rng.nextDouble() * 0.18),
          riskScore: risk,
          sparkline: _sparklineFor(i, 16),
          currency: 'USD',
          minDeposit: [200.0, 500.0, 1000.0, 2500.0][i % 4],
          tradingSince: DateTime(2024, 1 + (i % 12), 1 + (i % 27)),
        ),
      );
    }
    return result;
  }

  @override
  Future<List<MasterListing>> listMasters({
    TimeWindow window = TimeWindow.month,
    String? search,
    DirectorySort sort = DirectorySort.gainDesc,
  }) async {
    // Simulate a small network delay so the loading state in the UI is
    // exercised in dev. ~300ms is realistic for a Supabase Edge Function.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Re-skin gain + sparkline for the requested window. Drawdown stays
    // because a worst-case figure should be window-bound but for the
    // mock we keep it constant.
    final scoped = <MasterListing>[];
    for (var i = 0; i < _allListings.length; i++) {
      final base = _allListings[i];
      scoped.add(
        MasterListing(
          id: base.id,
          displayName: base.displayName,
          avatarUrl: base.avatarUrl,
          tagline: base.tagline,
          platform: base.platform,
          broker: base.broker,
          followers: base.followers,
          tier: base.tier,
          gainFraction: _gainFor(window: window, providerIndex: i),
          drawdownFraction: base.drawdownFraction,
          riskScore: base.riskScore,
          sparkline: base.sparkline,
          currency: base.currency,
          minDeposit: base.minDeposit,
          tradingSince: base.tradingSince,
        ),
      );
    }

    final filtered = (search == null || search.trim().isEmpty)
        ? scoped
        : scoped
            .where(
              (m) => m.displayName
                  .toLowerCase()
                  .contains(search.trim().toLowerCase()),
            )
            .toList();

    filtered.sort((a, b) {
      switch (sort) {
        case DirectorySort.gainDesc:
          return b.gainFraction.compareTo(a.gainFraction);
        case DirectorySort.drawdownAsc:
          return b.drawdownFraction.compareTo(a.drawdownFraction);
        case DirectorySort.followersDesc:
          return b.followers.compareTo(a.followers);
        case DirectorySort.newest:
          return b.tradingSince.compareTo(a.tradingSince);
      }
    });
    return filtered;
  }

  @override
  Future<ProviderProfile> getProvider(
    String id, {
    TimeWindow window = TimeWindow.month,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final all = await listMasters(window: window);
    final summary = all.firstWhere(
      (m) => m.id == id,
      orElse: () => throw ProviderNotFoundException(id),
    );
    final providerIndex = int.parse(id.split('-').last);
    final rng = Random(_seedFor('profile-$providerIndex'));

    return ProviderProfile(
      summary: summary,
      equityHistory: _equityHistoryFor(providerIndex, window),
      stats: _statsFor(providerIndex, rng),
      symbolDistribution: _symbolDistFor(providerIndex, rng),
      recentActivity: _activityFor(providerIndex, rng),
    );
  }

  // ===========================================================================
  //  Generators
  // ===========================================================================

  /// Stable per-key seed so calls for the same key always return the
  /// same data. Hash code is platform-stable for ASCII strings.
  int _seedFor(String key) => key.hashCode & 0x7fffffff;

  /// Provider-relative gain over a [window]. A small constant per-window
  /// scaler combined with the per-provider seed keeps gains internally
  /// proportional (3M ≈ 3× 1M, etc.).
  double _gainFor({required TimeWindow window, required int providerIndex}) {
    final rng = Random(_seedFor('gain-$providerIndex'));
    final monthly = (rng.nextDouble() * 0.20) - 0.03; // -3% .. +17% monthly
    switch (window) {
      case TimeWindow.week:
        return monthly / 4;
      case TimeWindow.month:
        return monthly;
      case TimeWindow.quarter:
        return monthly * 3 * (0.85 + rng.nextDouble() * 0.3);
      case TimeWindow.year:
        return monthly * 12 * (0.7 + rng.nextDouble() * 0.6);
    }
  }

  /// Random-walk sparkline biased by the provider's monthly gain.
  /// Returns [length] normalised values in 0..1.
  List<double> _sparklineFor(int providerIndex, int length) {
    final rng = Random(_seedFor('spark-$providerIndex'));
    final gain = _gainFor(
      window: TimeWindow.month,
      providerIndex: providerIndex,
    );
    final drift = gain / length; // per-step drift
    final values = <double>[];
    var cur = 0.5;
    for (var i = 0; i < length; i++) {
      cur += drift + (rng.nextDouble() - 0.5) * 0.04;
      values.add(cur);
    }
    final lo = values.reduce(min);
    final hi = values.reduce(max);
    final span = (hi - lo).abs() < 1e-6 ? 1.0 : (hi - lo);
    return values.map((v) => (v - lo) / span).toList();
  }

  /// Daily equity + balance points spanning the requested [window].
  /// Equity tracks balance closely except during open positions, which
  /// the mock fakes by drifting equity ±2% off balance for short
  /// stretches.
  List<EquityPoint> _equityHistoryFor(int providerIndex, TimeWindow window) {
    final rng = Random(_seedFor('eq-$providerIndex-${window.label}'));
    final days = window.duration.inDays.clamp(7, 365);
    final endDate = DateTime.now();
    final startEquity = 10000.0;
    final targetGain = _gainFor(
      window: window,
      providerIndex: providerIndex,
    );
    final perDayDrift = targetGain / days;

    final points = <EquityPoint>[];
    var balance = startEquity;
    var equity = startEquity;
    for (var i = 0; i <= days; i++) {
      final date = endDate.subtract(Duration(days: days - i));
      // Balance moves by realised P&L per day (plus drift).
      final realised = balance *
          (perDayDrift + (rng.nextDouble() - 0.5) * 0.012);
      balance += realised;
      // Equity wanders around balance (open positions).
      equity = balance + balance * (rng.nextDouble() - 0.5) * 0.02;

      // Inject a couple of deposit events for visual interest.
      double? deposit;
      if (i == (days ~/ 3) || i == (days * 2 ~/ 3)) {
        deposit = startEquity * 0.5;
        balance += deposit;
        equity += deposit;
      }

      points.add(
        EquityPoint(
          date: date,
          equity: equity,
          balance: balance,
          depositChange: deposit,
        ),
      );
    }
    return points;
  }

  ProviderStats _statsFor(int providerIndex, Random rng) {
    final winRate = 0.45 + rng.nextDouble() * 0.30; // 45–75%
    final avgWin = 18.0 + rng.nextDouble() * 60.0;
    final avgLoss = -(12.0 + rng.nextDouble() * 40.0);
    final pf = (winRate * avgWin) / ((1 - winRate) * avgLoss.abs());
    return ProviderStats(
      totalTrades: 80 + rng.nextInt(420),
      winRate: winRate,
      profitFactor: pf,
      avgWin: avgWin,
      avgLoss: avgLoss,
      avgHoldTime: Duration(minutes: 30 + rng.nextInt(60 * 18)),
      maxWinStreak: 3 + rng.nextInt(8),
      maxLossStreak: 2 + rng.nextInt(5),
    );
  }

  Map<String, double> _symbolDistFor(int providerIndex, Random rng) {
    final picked = <String>[];
    final pool = List<String>.from(_symbols)..shuffle(rng);
    final n = 3 + rng.nextInt(3); // 3–5 symbols
    picked.addAll(pool.take(n));
    final weights = List<double>.generate(n, (_) => rng.nextDouble() + 0.1);
    final total = weights.reduce((a, b) => a + b);
    final out = <String, double>{};
    for (var i = 0; i < n; i++) {
      out[picked[i]] = weights[i] / total;
    }
    return out;
  }

  List<TradingActivity> _activityFor(int providerIndex, Random rng) {
    final result = <TradingActivity>[];
    final now = DateTime.now();
    final symbolsForProvider = _symbolDistFor(providerIndex, Random(providerIndex)).keys.toList();
    for (var i = 0; i < 12; i++) {
      final isOpen = i < 2;
      final sym = symbolsForProvider[i % symbolsForProvider.length];
      final dir = rng.nextBool() ? TradeDirection.buy : TradeDirection.sell;
      final lots = 0.05 + (rng.nextInt(20) * 0.05);
      final openedAt = now.subtract(
        Duration(hours: i * 8 + rng.nextInt(8)),
      );
      final closedAt =
          isOpen ? null : openedAt.add(Duration(hours: 1 + rng.nextInt(20)));
      final pnl = isOpen ? null : (rng.nextDouble() * 200 - 80);
      result.add(
        TradingActivity(
          symbol: sym,
          direction: dir,
          lots: lots,
          openTime: openedAt,
          closeTime: closedAt,
          pnl: pnl,
        ),
      );
    }
    return result;
  }
}

/// Real Supabase-backed directory.
///
/// Joins `provider_listings` (status='approved') with `account_ownership`
/// for platform + registered_at + login_number. Listing summary fields
/// (gain%, drawdown%, tier, risk score, follower count, bio) come from
/// the operator-set values on the listing — the trader's application
/// flow plus admin approval populates them.
///
/// While the real provider population ramps, the directory also returns
/// the seeded mock cards alongside real ones so the Discover surface
/// looks populated. Real cards always sort on top within the active
/// sort. To disable the mock-merge, construct with
/// `mergeMockCards: false`.
///
/// What's NOT real yet:
///   * Sparkline — deterministic mock per listing id.
///   * Equity history, win rate, profit factor, recent trade activity,
///     symbol distribution — all generated by the same mock generators
///     used by [MockSignalDirectoryRepository] keyed off the listing id.
///   * `broker` field on [MasterListing] — we don't store the broker
///     server name; defaulting to the uppercase platform code.
///
/// These follow-up surfaces wait on a separate slice that pulls real
/// trade history from the trading API (per-master `getOrderHistory`) +
/// aggregates server-side. That's an intentionally larger piece of work
/// and not blocking the directory rollout.
class SupabaseSignalDirectoryRepository implements SignalDirectoryRepository {
  final SupabaseClient _supabase;
  final bool mergeMockCards;

  // Reuses the mock generators for the deeper profile surfaces and the
  // (optional) merged mock cards on listMasters.
  final MockSignalDirectoryRepository _mockGen =
      MockSignalDirectoryRepository();

  SupabaseSignalDirectoryRepository(
    this._supabase, {
    this.mergeMockCards = true,
  });

  @override
  Future<List<MasterListing>> listMasters({
    TimeWindow window = TimeWindow.month,
    String? search,
    DirectorySort sort = DirectorySort.gainDesc,
  }) async {
    var query = _supabase
        .from('provider_listings')
        .select(
          'id, master_account_id, display_name, bio, currency, '
          'min_deposit, tier, risk_score, gain_pct, drawdown_pct, '
          'followers_count, account_ownership!inner('
          'platform, registered_at, login_number)',
        )
        .eq('status', 'approved');
    if (search != null && search.trim().isNotEmpty) {
      query = query.ilike('display_name', '%${search.trim()}%');
    }
    final rows = await query;

    final real = (rows as List)
        .map((r) => _toMasterListing(r as Map<String, dynamic>))
        .toList();
    real.sort((a, b) => _compare(a, b, sort));

    if (!mergeMockCards) return real;

    // Merge mock cards behind the real ones. They go through the mock
    // repo's own search + sort so behavior matches the legacy view.
    final mock = await _mockGen.listMasters(
      window: window,
      search: search,
      sort: sort,
    );
    return [...real, ...mock];
  }

  int _compare(MasterListing a, MasterListing b, DirectorySort sort) {
    switch (sort) {
      case DirectorySort.gainDesc:
        return b.gainFraction.compareTo(a.gainFraction);
      case DirectorySort.drawdownAsc:
        return b.drawdownFraction.compareTo(a.drawdownFraction);
      case DirectorySort.followersDesc:
        return b.followers.compareTo(a.followers);
      case DirectorySort.newest:
        return b.tradingSince.compareTo(a.tradingSince);
    }
  }

  @override
  Future<ProviderProfile> getProvider(
    String id, {
    TimeWindow window = TimeWindow.month,
  }) async {
    // Mock-card ids look like 'mock-001'; real ones are uuid v4. Hand
    // mock-prefixed ids straight to the mock repo so its profile data
    // is internally consistent with the card the trader saw.
    if (id.startsWith('mock-')) {
      return _mockGen.getProvider(id, window: window);
    }

    final rows = await _supabase
        .from('provider_listings')
        .select(
          'id, master_account_id, display_name, bio, currency, '
          'min_deposit, tier, risk_score, gain_pct, drawdown_pct, '
          'followers_count, account_ownership!inner('
          'platform, registered_at, login_number)',
        )
        .eq('id', id)
        .eq('status', 'approved')
        .limit(1);
    final list = rows as List;
    if (list.isEmpty) throw ProviderNotFoundException(id);

    final summary =
        _toMasterListing(list.first as Map<String, dynamic>);

    // Deeper surfaces still mocked — see class doc.
    final providerIndexSeed = id.hashCode & 0x7fffffff;
    return ProviderProfile(
      summary: summary,
      equityHistory:
          _mockGen._equityHistoryFor(providerIndexSeed, window),
      stats: _mockGen._statsFor(providerIndexSeed,
          Random(_mockGen._seedFor('stats-$id'))),
      symbolDistribution: _mockGen._symbolDistFor(
        providerIndexSeed,
        Random(_mockGen._seedFor('sym-$id')),
      ),
      recentActivity: _mockGen._activityFor(
        providerIndexSeed,
        Random(_mockGen._seedFor('act-$id')),
      ),
    );
  }

  MasterListing _toMasterListing(Map<String, dynamic> row) {
    final ao = row['account_ownership'] as Map<String, dynamic>;
    final platform = Platform.parse(ao['platform']);
    final tradingSince = DateTime.parse(ao['registered_at'] as String);
    final id = row['id'] as String;
    return MasterListing(
      id: id,
      displayName: row['display_name'] as String? ?? 'Unnamed',
      tagline: (row['bio'] as String?)?.trim().isNotEmpty == true
          ? (row['bio'] as String)
          : 'Verified provider on QuantumPips.',
      platform: platform,
      // We don't track the broker server name; surface the platform
      // code as a stand-in. Replace once we model brokers explicitly.
      broker: platform.wireValue.toUpperCase(),
      followers: (row['followers_count'] as num?)?.toInt() ?? 0,
      tier: _parseTier(row['tier'] as String?),
      gainFraction: (row['gain_pct'] as num?)?.toDouble() ?? 0,
      drawdownFraction: (row['drawdown_pct'] as num?)?.toDouble() ?? 0,
      riskScore: _parseRisk(row['risk_score'] as String?),
      // Sparkline still seeded — derived from real trade history in a
      // later slice.
      sparkline: _mockGen._sparklineFor(id.hashCode & 0x7fffffff, 16),
      currency: row['currency'] as String? ?? 'USD',
      minDeposit: (row['min_deposit'] as num?)?.toDouble() ?? 0,
      tradingSince: tradingSince,
    );
  }

  ProviderTier _parseTier(String? raw) {
    if (raw == null) return ProviderTier.bronze;
    return ProviderTier.values.firstWhere(
      (t) => t.name == raw,
      orElse: () => ProviderTier.bronze,
    );
  }

  RiskScore _parseRisk(String? raw) {
    if (raw == null) return RiskScore.medium;
    return RiskScore.values.firstWhere(
      (r) => r.name == raw,
      orElse: () => RiskScore.medium,
    );
  }
}
