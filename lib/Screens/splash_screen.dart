import 'dart:async';
import 'package:flutter/material.dart';
import 'vendor_login.dart'; // Make sure this path is correct

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to login screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VendorLoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6A11CB), Color(0xff2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash image
            Image.asset(
              'assets/images/splash1.png', // make sure this matches pubspec.yaml and your assets folder
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            // App title
            const Text(
              "Vendor App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
