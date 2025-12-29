import 'package:flutter/material.dart';
import 'package:vws/screens/auth/login_screen.dart';
import 'package:vws/screens/auth/signup_screen.dart';
import 'package:vws/screens/splash_screen.dart';
import 'package:vws/screens/worker_bottom_nav.dart';
import 'package:vws/screens/worker_bottom_nav.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vendor Worker System',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xffF2F3F7),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),

      // First screen
      home: const WorkerBottomNav(),

      // Named routes (for future use)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const WorkerRegisterScreen(),
      },
    );
  }
}
