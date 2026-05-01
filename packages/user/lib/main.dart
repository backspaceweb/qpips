import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/api/api_client_provider.dart';
import 'package:qp_core/repositories/signal_directory_repository.dart';
import 'package:qp_core/repositories/trader_repository.dart';
import 'package:qp_core/repositories/trading_repository.dart';
import 'package:qp_design/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/presentation/trader_login_screen.dart';
import 'features/auth/presentation/trader_sign_up_screen.dart';
import 'features/landing/presentation/landing_screen.dart';
import 'features/trader/presentation/trader_shell.dart';

/// QuantumPips trader app.
///
/// Auth + Wallet + Subscriptions + Accounts run against real Supabase
/// today. Phase E E.1.3 wired the Discover surface to a real
/// SupabaseSignalDirectoryRepository; E.2.1 wired the My Follows /
/// Configure Follow / Provider Profile path to a real
/// SupabaseTraderRepository that joins account_ownership with
/// provider_listings. Live P&L and trade-history aggregation still
/// pending — that's the live-performance follow-up slice.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (kDebugMode && (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty)) {
    debugPrint(
      'WARNING: Supabase credentials are missing. Login + wallet will '
      'fail. Build with --dart-define-from-file=secrets.json.',
    );
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const UserApp());
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Real repositories shared with the admin app: Api (Chopper),
        // TradingRepository, AuthRepository, WalletRepository,
        // SubscriptionRepository, AccountRepository.
        ...ApiClientProvider.providers,
        // Discover surface: real provider_listings join (E.1.3).
        Provider<SignalDirectoryRepository>(
          create: (_) =>
              SupabaseSignalDirectoryRepository(Supabase.instance.client),
        ),
        // My Follows / Configure Follow / Profile: real Supabase reads
        // (E.2.1). Live P&L / openTrades stay zero until the live-perf
        // slice ships.
        ProxyProvider<TradingRepository, TraderRepository>(
          update: (_, trading, __) => SupabaseTraderRepository(
            Supabase.instance.client,
            trading,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuantumPips',
        theme: AppTheme.light(),
        themeMode: ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const LandingScreen(),
          '/login': (context) => const TraderLoginScreen(),
          '/signup': (context) => const TraderSignUpScreen(),
          // Back-compat: landing-page links that still point at
          // /registration land on sign-up rather than login (the
          // original placeholder semantics).
          '/registration': (context) => const TraderSignUpScreen(),
          '/app': (context) => const _AuthGate(child: TraderShell()),
        },
      ),
    );
  }
}

/// Gate around `/app`. Renders the login screen when there's no active
/// Supabase session; otherwise hands off to the wrapped child.
class _AuthGate extends StatelessWidget {
  final Widget child;
  const _AuthGate({required this.child});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return const TraderLoginScreen();
    }
    return child;
  }
}
