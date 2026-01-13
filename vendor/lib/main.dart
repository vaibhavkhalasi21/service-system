import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/role_selection_screen.dart';
import 'vendor/screens/vendor_home.dart';
import 'worker/screens/worker_bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final vendorToken = prefs.getString("vendor_token");
  final workerToken = prefs.getString("worker_token");

  Widget startScreen;

  if (vendorToken != null) {
    startScreen = const VendorHomeScreen();
  } else if (workerToken != null) {
    startScreen = const WorkerBottomNav();
  } else {
    startScreen = const RoleSelectionScreen();
  }

  runApp(MyApp(startScreen: startScreen));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service System',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      ),
      home: startScreen,
    );
  }
}
