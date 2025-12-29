import 'dart:convert';
import 'package:http/http.dart' as http;

class VendorApi {
  static const String baseUrl = "http://10.141.25.71:5244/api/vendor";

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
      final response = await http.post(
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
      );

      return {
        "status": response.statusCode,
        "body": response.body, // just a string from backend
      };
    } catch (e) {
      return {
        "status": 500,
        "body": "Network error: $e",
      };
    }
  }

  // LOGIN
  static Future<Map<String, dynamic>> loginVendor({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "status": 200,
          "body": data,
        };
      } else {
        return {
          "status": response.statusCode,
          "body": response.body, // string error
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
