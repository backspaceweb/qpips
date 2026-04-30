import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qp_core/api/api_client_provider.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/registration/presentation/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

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
