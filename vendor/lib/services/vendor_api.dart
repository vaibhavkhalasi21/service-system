import 'dart:convert';
import 'package:http/http.dart' as http;

class VendorApi {
  // 🔹 Replace with your PC's local IP
  static const String baseUrl = "http://192.168.1.100:5244/api/vendor";

  // REGISTER
  static Future<Map<String, dynamic>> registerVendor({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String serviceType,
    required String address,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
          "serviceType": serviceType,
          "address": address,
        }),
      )
          .timeout(const Duration(seconds: 10));

      return {
        "status": response.statusCode,
        "body": jsonDecode(response.body),
      };
    } catch (e) {
      print("API Error: $e");
      return {
        "status": 500,
        "body": {"message": "Failed to connect to server. Check network."},
      };
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>> loginVendor({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      )
          .timeout(const Duration(seconds: 10));

      return {
        "status": response.statusCode,
        "body": jsonDecode(response.body),
      };
    } catch (e) {
      print("API Error: $e");
      return {
        "status": 500,
        "body": {"message": "Failed to connect to server. Check network."},
      };
    }
  }
}
