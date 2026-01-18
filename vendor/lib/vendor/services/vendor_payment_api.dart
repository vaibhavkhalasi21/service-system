import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vendor_payment.dart';

class VendorPaymentApi {
  static const String baseUrl =
      "http://172.20.253.37:5244/api/payments";

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
  // GET PAYMENTS (PAYMENTS TABLE)
  // ===============================
  static Future<List<VendorPayment>> getMyPayments() async {
    final headers = await _authHeader();

    final response = await http.get(
      Uri.parse("$baseUrl/my-payments"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load payments "
            "(${response.statusCode}) → ${response.body}",
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((e) => VendorPayment.fromJson(e))
        .toList();
  }

  // ===============================
  // CASH PAYMENT (APPLICATION BASED)
  // ===============================
  static Future<void> createCashPayment(int applicationId) async {
    final headers = await _authHeader();

    final response = await http.post(
      Uri.parse("$baseUrl/create-cash-payment/$applicationId"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Cash payment failed "
            "(${response.statusCode}) → ${response.body}",
      );
    }
  }

  // ===============================
  // ONLINE PAYMENT (DEMO)
  // ===============================
  static Future<void> createDemoOnlinePayment(int applicationId) async {
    final headers = await _authHeader();

    final response = await http.post(
      Uri.parse("$baseUrl/create-demo-payment/$applicationId"),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Online payment failed "
            "(${response.statusCode}) → ${response.body}",
      );
    }
  }
}
