import 'dart:convert';
import 'package:http/http.dart' as http;

class VendorApi {
  // 🔴 IMPORTANT:
  // Use the SAME IP + PORT where Swagger opens on your PHONE browser
  // Example: http://192.168.1.5:5000
  static const String _base =
      "http://10.141.25.37:5244"; // 🔁 CHANGE PORT IF NEEDED

  static const String baseUrl = "$_base/api/vendor";

  // ============================
  // ✅ REGISTER VENDOR
  // ============================
  static Future<Map<String, dynamic>> registerVendor({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String serviceType,
    required String address,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/register");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.trim(),
          "email": email.trim(),
          "phone": phone.trim(),
          "password": password.trim(),
          "serviceType": serviceType.trim(),
          "address": address.trim(),
        }),
      );

      print("REGISTER STATUS: ${response.statusCode}");
      print("REGISTER BODY: ${response.body}");

      return {
        "status": response.statusCode,
        "body": response.body,
      };
    } catch (e) {
      print("REGISTER ERROR: $e");
      return {
        "status": 500,
        "body": "Network error: $e",
      };
    }
  }

  // ============================
  // 🔐 LOGIN VENDOR
  // ============================
  static Future<Map<String, dynamic>> loginVendor({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/login");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
        }),
      );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "status": 200,
          "body": data, // JSON map
        };
      } else {
        return {
          "status": response.statusCode,
          "body": response.body, // error string
        };
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      return {
        "status": 500,
        "body": "Network error: $e",
      };
    }
  }
}
