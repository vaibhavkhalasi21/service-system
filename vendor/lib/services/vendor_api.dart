import 'dart:convert';
import 'package:http/http.dart' as http;

class VendorApi {
  // 🔴 IMPORTANT
  // This MUST be the same IP + PORT where Swagger opens
  // on your PHONE browser
  static const String _baseUrl = "http://10.141.25.37:5244";

  static const String vendorBase = "$_baseUrl/api/vendor";

  // ===========================
  // ✅ REGISTER VENDOR
  // ===========================
  static Future<Map<String, dynamic>> registerVendor({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String serviceType,
    required String address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$vendorBase/register"),
        headers: const {
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

  // ===========================
  // 🔐 LOGIN VENDOR
  // ===========================
  static Future<Map<String, dynamic>> loginVendor({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$vendorBase/login"),
        headers: const {
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
        final Map<String, dynamic> data = jsonDecode(response.body);

        return {
          "status": 200,
          "body": data, // ✅ JSON MAP
        };
      } else {
        return {
          "status": response.statusCode,
          "body": response.body, // ❌ string error
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

  // ===========================
  // 🔒 GET VENDOR PROFILE
  // ===========================
  static Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$vendorBase/profile"),
        headers: {
          "Authorization": "Bearer $token", // ✅ SINGLE SPACE
          "Accept": "application/json",
        },
      );

      print("PROFILE STATUS: ${response.statusCode}");
      print("PROFILE BODY: ${response.body}");

      if (response.statusCode == 200) {
        return {
          "status": 200,
          "body": jsonDecode(response.body),
        };
      } else {
        return {
          "status": response.statusCode,
          "body": response.body,
        };
      }
    } catch (e) {
      return {
        "status": 500,
        "body": "Network error: $e",
      };
    }
  }
}
