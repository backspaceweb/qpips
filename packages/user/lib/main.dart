import 'package:flutter/material.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_spacing.dart';
import 'package:qp_design/app_theme.dart';
import 'package:qp_design/app_typography.dart';
import 'features/landing/presentation/landing_screen.dart';

/// QuantumPips trader app.
///
/// D.4 ships the landing page only. D.5 will add registration + sign-in,
/// signal discovery, provider profile, configure-follow, and my-active-
/// follows. At that point this main.dart will gain Supabase /
/// MultiProvider scaffolding (the admin app already has it).
void main() {
  runApp(const UserApp());
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuantumPips',
      theme: AppTheme.light(),
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/registration': (context) => const _ComingSoonScreen(),
      },
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
