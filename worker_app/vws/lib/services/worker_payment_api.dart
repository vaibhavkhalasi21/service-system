import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/worker_payment.dart';

class WorkerPaymentApi {
  static const String baseUrl =
      "http://10.29.111.37:5244/api/application";

  // ===============================
  // WORKER: GET COMPLETED PAYMENTS
  // ===============================
  static Future<List<WorkerPayment>> getPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("worker_token");

    if (token == null || token.isEmpty) {
      throw Exception("Worker token not found");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/worker"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load worker payments (${response.statusCode})",
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    // 🔥 Payments screen = ONLY completed jobs
    return data
        .where((e) => e['status'] == "Completed")
        .map((e) => WorkerPayment.fromJson(e))
        .toList();
  }
  static Future<void> rateVendor(int applicationId, int rating) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("worker_token");

    final response = await http.post(
      Uri.parse("$baseUrl/$applicationId/rate-vendor?rating=$rating"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to rate vendor");
    }
  }

}
