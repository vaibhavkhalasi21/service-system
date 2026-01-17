import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vendor_payment.dart';

class VendorPaymentApi {
  static const String baseUrl =
      "http://172.20.253.37:5244/api/application";

  // ===============================
  // AUTH HEADER
  // ===============================
  static Future<Map<String, String>> _authHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null || token.isEmpty) {
      throw Exception("Vendor token not found");
    }

    return {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    };
  }

  // ===============================
  // VENDOR: GET COMPLETED JOBS
  // ===============================
  static Future<List<VendorPayment>> getPayments() async {
    final headers = await _authHeader();

    final response = await http.get(
      Uri.parse("$baseUrl/vendor"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load vendor payments (${response.statusCode})",
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    // ✅ Only COMPLETED jobs appear in payment screen
    return data
        .where((e) => e['status'] == "Completed")
        .map((e) => VendorPayment.fromJson(e))
        .toList();
  }

  // ===============================
  // DEMO ONLINE PAYMENT
  // ===============================
  static Future<void> markPaidOnline(int applicationId) async {
    final headers = await _authHeader();

    final response = await http.put(
      Uri.parse("$baseUrl/$applicationId/pay?method=Online"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to mark online payment (${response.statusCode})",
      );
    }
  }

  // ===============================
  // CASH PAYMENT
  // ===============================
  static Future<void> markPaidCash(int applicationId) async {
    final headers = await _authHeader();

    final response = await http.put(
      Uri.parse("$baseUrl/$applicationId/pay?method=Cash"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to mark cash payment (${response.statusCode})",
      );
    }
  }
}
