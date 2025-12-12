import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/onboarding/onboarding_flow.dart';
import 'screens/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
      url: 'https://xlqbybfhkmgntrxkuhxt.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhscWJ5YmZoa21nbnRyeGt1aHh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0NjUwMzUsImV4cCI6MjA4MTA0MTAzNX0.WwhG2o_mvEdk1wro60Twl42ex2zri-_uyzse5zlsv5o',
    );
    runApp(const MaaApp());
  } catch (e, stack) {
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    const Text("Startup Failed", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(
                      "Error: $e\n\nPossible fix: Ensure 'android.permission.INTERNET' is in your AndroidManifest.xml",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MaaApp extends StatelessWidget {
  const MaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
      ],
      child: MaterialApp(
        title: 'Maa Financial',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF9F7F2), // Cream/Off-white
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE07A5F), // Terracotta (Maa)
            primary: const Color(0xFFE07A5F),
            secondary: const Color(0xFF2A9D8F), // Teal (Money)
            surface: const Color(0xFFFFFFFF),
            onSurface: const Color(0xFF264653), // Dark Slate
            error: const Color(0xFFE63946),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE07A5F), width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            labelStyle: const TextStyle(color: Color(0xFF264653)),
          ),
        ),
        home: const ConsumerWrapper(),
      ),
    );
  }
}

class ConsumerWrapper extends StatelessWidget {
  const ConsumerWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isLoggedIn) {
      return const AuthScreen();
    }
    return auth.hasOnboarded ? const HomePage() : const OnboardingFlow();
  }
}