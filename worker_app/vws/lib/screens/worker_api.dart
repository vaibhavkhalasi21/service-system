import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkerApi {
  static const String baseUrl = "http://10.141.25.233:5244/api/worker";

  // =====================
  // ✅ WORKER REGISTER
  // =====================
  static Future<String?> signupWorker({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String skill,
    String? address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
          "skill": skill,
          "address": address ?? "", // ✅ safe
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        return null; // ✅ SUCCESS
      } else {
        return response.body; // ❌ backend error
      }
    } catch (e) {
      return e.toString();
    }
  }

  // =====================
  // 🔐 WORKER LOGIN
  // =====================
  static Future<Map<String, dynamic>?> loginWorkerData({
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
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
