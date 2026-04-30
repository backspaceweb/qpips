import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/repositories/signal_directory_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_theme.dart';
import 'package:qp_design/app_typography.dart';
import 'features/landing/presentation/landing_screen.dart';
import 'features/trader/presentation/trader_shell.dart';

/// QuantumPips trader app.
///
/// D.4 shipped the landing page; D.5 adds the trader surfaces (signal
/// discovery, provider profile, configure follow, my active follows).
/// Today the app runs on mock data — see [MockSignalDirectoryRepository]
/// in qp_core. Phase E swaps the repository for a Supabase-backed real
/// implementation; no UI code changes.
///
/// Supabase auth + the trading-API client are NOT wired here yet. The
/// landing CTAs route to a placeholder; Phase E adds the real sign-up
/// flow alongside the real repository.
void main() {
  runApp(const UserApp());
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SignalDirectoryRepository>(
          create: (_) => MockSignalDirectoryRepository(),
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
          '/app': (context) => const TraderShell(),
          '/registration': (context) => const _ComingSoonScreen(),
        },
      ),
    );
  }
}

/// Placeholder shown when landing-page CTAs route to `/registration`. The
/// real trader sign-up flow lands in D.5.
class _ComingSoonScreen extends StatelessWidget {
  const _ComingSoonScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.rocket_launch_outlined,
                color: AppColors.primaryAccent,
                size: 64,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Trader sign-up is on the way.',
                style: AppTypography.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Text(
                  'We are wiring up the discovery + follow flow next. '
                  'Want early access? Email us at hello@quantumpips.app '
                  'and we will reach out the moment it ships.',
                  style: AppTypography.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
