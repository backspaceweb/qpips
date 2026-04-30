import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/api/api_client_provider.dart';
import 'design/app_theme.dart';
import 'features/landing/presentation/landing_screen.dart';
import 'features/registration/presentation/registration_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase using environment variables. Supabase Auth manages
  // its own session persistence (localStorage on web, secure storage on
  // mobile), so logged-in users survive a page refresh / app relaunch.
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  final isLoggedIn = Supabase.instance.client.auth.currentSession != null;

  runApp(
    MultiProvider(
      providers: ApiClientProvider.providers,
      child: MyApp(initialRoute: isLoggedIn ? '/dashboard' : '/'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuantumPips',
      theme: AppTheme.light(),
      // Force light mode for now — the landing page is designed light;
      // dark theme will be enabled per-route once the app surfaces also
      // support it.
      themeMode: ThemeMode.light,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const LandingScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
