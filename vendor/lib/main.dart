import 'package:flutter/material.dart';
import 'package:vendor/Screens/vendor_home.dart';
import 'Screens/vendor_login.dart';

void main() {
  runApp(const VendorApp());
}

class VendorApp extends StatelessWidget {
  const VendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vendor App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      ),
      home: const VendorHomeScreen(),
    );
  }
}
