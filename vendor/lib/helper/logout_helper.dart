import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/role_selection_screen.dart';

class LogoutHelper {
  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // 🔥 Clear ALL auth-related data
    await prefs.remove("vendor_token");
    await prefs.remove("vendor_id");
    await prefs.remove("vendor_name");

    await prefs.remove("worker_token");
    await prefs.remove("worker_id");
    await prefs.remove("worker_name");

    // 🔁 Reset navigation stack
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const RoleSelectionScreen(),
      ),
          (route) => false, // ❌ remove all previous routes
    );
  }
}
