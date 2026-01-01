import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/vendor_home.dart';
import 'Screens/vendor_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.containsKey("vendor_token");

  runApp(VendorApp(isLoggedIn: isLoggedIn));
}

class VendorApp extends StatelessWidget {
  final bool isLoggedIn;

  const VendorApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vendor App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      ),
      home: isLoggedIn
          ? const VendorHomeScreen()
          : const VendorLoginScreen(),
    );
  }
}
