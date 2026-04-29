import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/api/api_client_provider.dart';
import 'features/registration/presentation/registration_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
    print('DEBUG WARNING: Supabase credentials are MISSING. Cloud features will not work.');
    print('Use --dart-define=SUPABASE_URL=... and --dart-define=SUPABASE_ANON_KEY=... when running.');
  } else {
    print('DEBUG: Supabase credentials detected. Connecting to cloud...');
  }

  // Initialize Supabase using environment variables
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: ApiClientProvider.providers,
      child: MyApp(initialRoute: isLoggedIn ? '/dashboard' : '/registration'),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      routes: {
        '/registration': (context) => const RegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
