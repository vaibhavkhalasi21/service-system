import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkerApi {
  static const String baseUrl =
      "http://10.141.25.71:5244/api/worker";

  /// 🔐 LOGIN
  static Future<bool> loginWorker({
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

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 📝 REGISTER (FIXED)
  static Future<bool> signupWorker({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String category,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"), // ✅ FIXED
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
          "category": category,
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> loginWorkerData(
      {required String email, required String password}) async {
    // Call your API and get JSON
    // return json if success, null if fail
  }
}

