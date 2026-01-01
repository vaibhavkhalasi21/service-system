import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("vendor_token");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("vendor_token");
  }

  static Future<int?> getVendorId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendor_id");
  }
}
