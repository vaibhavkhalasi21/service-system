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
      "body": jsonDecode(response.body),
    };
  }

  // LOGIN
  static Future<Map<String, dynamic>> loginVendor({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return {
      "status": response.statusCode,
      "body": jsonDecode(response.body),
    };
  }
}
