import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qp_core/api/api_client_provider.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6366F1),
      ),
      themeMode: ThemeMode.light,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const RegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
