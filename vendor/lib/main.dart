import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'auth/role_selection_screen.dart';
import 'vendor/screens/vendor_home.dart';
import 'worker/screens/worker_bottom_nav.dart';

void main() async {
  // ✅ REQUIRED for async before runApp
  final WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ KEEP native splash until we manually remove it
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

// ======================================================
// ROOT APP
// ======================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UrbanCare',

      // 🌞 LIGHT THEME (future-ready)
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF7B4DFF),
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      ),

      // 🌙 DARK THEME (current)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF7B4DFF),
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      ),

      // 🔥 FORCE DARK MODE FOR NOW
      themeMode: ThemeMode.dark,

      home: const StartupDecider(),
    );
  }
}

// ======================================================
// DECIDES WHERE TO GO AFTER SPLASH
// ======================================================
class StartupDecider extends StatefulWidget {
  const StartupDecider({super.key});

  @override
  State<StartupDecider> createState() => _StartupDeciderState();
}

class _StartupDeciderState extends State<StartupDecider> {
  @override
  void initState() {
    super.initState();
    _decideNavigation();
  }

  Future<void> _decideNavigation() async {
    final prefs = await SharedPreferences.getInstance();

    final vendorToken = prefs.getString("vendor_token");
    final workerToken = prefs.getString("worker_token");

    // ✅ REMOVE native splash ONCE decision is ready
    FlutterNativeSplash.remove();

    if (!mounted) return;

    Widget nextScreen;

    if (vendorToken != null && vendorToken.isNotEmpty) {
      nextScreen = const VendorHomeScreen();
    } else if (workerToken != null && workerToken.isNotEmpty) {
      nextScreen = const WorkerBottomNav();
    } else {
      nextScreen = const RoleSelectionScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ⚫ This UI is NEVER seen (native splash is on top)
    return const Scaffold(
      backgroundColor: Colors.black,
    );
  }
}
