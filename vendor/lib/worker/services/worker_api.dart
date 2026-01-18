import 'dart:convert';
import 'package:http/http.dart' as http;

import '../sessions/worker_session.dart';

class WorkerApi {
  static const String baseUrl = "http://172.20.253.37:5244/api/worker";

  // ================= REGISTER =================
  static Future<String?> signupWorker({
    required String name,
    required String email,
    required String password,
    required String phone,

    /// 🔥 CATEGORY ENUM VALUE (1–5)
    required int category,

    required String address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: const {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,

          // ✅ SEND ENUM INT
          "category": category,

          "address": address,
        }),
      );

      if (response.statusCode == 200) {
        return null; // success
      } else {
        final body = jsonDecode(response.body);
        return body["message"] ?? "Registration failed";
      }
    } catch (e) {
      return e.toString();
    }
  }

  // ================= LOGIN =================
  static Future<Map<String, dynamic>?> loginWorkerData({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: const {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        return {
          "id": jsonResponse["workerId"],
          "name": jsonResponse["workerName"],
          "email": email,
          "token": jsonResponse["token"],
          "role": jsonResponse["role"],
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ================= UPDATE LOCATION =================
  static Future<bool> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final token = await WorkerSession.getToken();

      final response = await http.put(
        Uri.parse("$baseUrl/location"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "latitude": latitude,
          "longitude": longitude,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ================= GET NEARBY JOBS =================
  static Future<List<dynamic>> getNearbyJobs() async {
    try {
      final token = await WorkerSession.getToken();

      final response = await http.get(
        Uri.parse("$baseUrl/nearby-jobs"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
