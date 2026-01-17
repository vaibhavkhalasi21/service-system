import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/worker_payment.dart';

class WorkerPaymentApi {
  static const String baseUrl =
      "http://172.20.253.37:5244/api/application";

  // ===============================
  // AUTH HEADER
  // ===============================
  static Future<Map<String, String>> _authHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("worker_token");

    if (token == null || token.isEmpty) {
      throw Exception("Worker token not found");
    }

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  // ===============================
  // GET WORKER PAYMENTS
  // ===============================
  static Future<List<WorkerPayment>> getPayments() async {
    final headers = await _authHeader();

    final response = await http.get(
      Uri.parse("$baseUrl/worker"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load payments (${response.statusCode})",
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    // 🔥 Worker sees ONLY completed jobs
    return data
        .where((e) => e['status'] == "Completed")
        .map((e) => WorkerPayment.fromJson(e))
        .toList();
  }

  // ===============================
  // RATE VENDOR
  // ===============================
  static Future<void> rateVendor(
      int applicationId,
      int rating,
      ) async {
    final headers = await _authHeader();

    final response = await http.post(
      Uri.parse(
        "$baseUrl/$applicationId/rate-vendor?rating=$rating",
      ),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to rate vendor");
    }
  }
}
