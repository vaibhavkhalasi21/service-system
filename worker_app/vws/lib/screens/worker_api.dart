import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkerApi {
  static const String baseUrl = "http://10.141.25.37:5244/api/worker";

  // ======== REGISTER ========
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
          "address": address ?? "",
        }),
      );

      if (response.statusCode == 200) return null;
      return jsonDecode(response.body)['message'] ?? response.body;
    } catch (e) {
      return e.toString();
    }
  }

  // ======== LOGIN ========
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
        final jsonResponse = jsonDecode(response.body);

        // Map backend JSON to Worker model keys
        final worker = {
          "id": jsonResponse["workerId"],
          "name": jsonResponse["workerName"],
          "email": email,
          "phone": "",
          "skill": "",
          "address": "",
          "token": jsonResponse["token"],
        };

        return worker;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
