import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qp_core/api/api_client_provider.dart';
import 'package:qp_core/repositories/auth_repository.dart';
import 'package:qp_design/app_colors.dart';
import 'package:qp_design/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/registration/presentation/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (kDebugMode) {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      debugPrint(
        'WARNING: Supabase credentials are missing. Login + cloud features '
        'will fail. Build with --dart-define-from-file=secrets.json (or '
        'pass --dart-define=SUPABASE_URL=... and SUPABASE_ANON_KEY=...).',
      );
    } else {
      debugPrint('Supabase credentials detected — connecting to cloud.');
    }
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  final isLoggedIn = Supabase.instance.client.auth.currentSession != null;

  runApp(
    MultiProvider(
      providers: ApiClientProvider.providers,
      child: AdminApp(initialRoute: isLoggedIn ? '/dashboard' : '/'),
    ),
  );
}

class AdminApp extends StatelessWidget {
  final String initialRoute;
  const AdminApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuantumPips Admin',
      theme: AppTheme.light(),
      themeMode: ThemeMode.light,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const RegistrationScreen(),
        '/dashboard': (context) => const _AdminGate(child: DashboardScreen()),
      },
    );
  }
}

/// Wraps the dashboard route. Verifies the current Supabase session
/// belongs to a profile with `role = 'admin'`. Catches the case where a
/// stale trader session was persisted (from before the login-time
/// admin-role check landed) and bounces them back to the login screen.
class _AdminGate extends StatefulWidget {
  final Widget child;
  const _AdminGate({required this.child});

  @override
  State<_AdminGate> createState() => _AdminGateState();
}

class _AdminGateState extends State<_AdminGate> {
  Future<bool>? _check;

  @override
  void initState() {
    super.initState();
    _check = _verify();
  }

  Future<bool> _verify() async {
    final repo = context.read<AuthRepository>();
    if (!repo.isLoggedIn) return false;
    final isAdmin = await repo.isCurrentUserAdmin();
    if (!isAdmin) {
      await repo.signOut();
    }
    return isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _check,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: AppColors.surfaceMuted,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryAccent,
              ),
            ),
          );
        }
        if (snap.data != true) {
          // Trader-role session or no session — bounce to login.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/',
              (_) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Signed out — that account is not authorised for the admin panel.',
                ),
                backgroundColor: AppColors.loss,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 4),
              ),
            );
          });
          return const Scaffold(
            backgroundColor: AppColors.surfaceMuted,
            body: SizedBox.shrink(),
          );
        }
        return widget.child;
      },
    );
  }
}
