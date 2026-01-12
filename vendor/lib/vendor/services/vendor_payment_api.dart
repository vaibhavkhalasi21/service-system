import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vendor_payment.dart';

class VendorPaymentApi {
  static const String baseUrl =
      "http://10.29.111.37:5244/api/application";

  // ===============================
  // VENDOR: GET COMPLETED PAYMENTS
  // ===============================
  static Future<List<VendorPayment>> getPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null || token.isEmpty) {
      throw Exception("Vendor token not found");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/vendor"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
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
  // VENDOR: MARK PAYMENT PAID
  // method = "Cash" | "Online"
  // ===============================
  static Future<void> markPaid(
      int applicationId,
      String method,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null || token.isEmpty) {
      throw Exception("Vendor token not found");
    }

    if (method != "Cash" && method != "Online") {
      throw Exception("Invalid payment method");
    }

    final response = await http.put(
      Uri.parse(
        "$baseUrl/$applicationId/pay?method=$method",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to mark payment as paid (${response.statusCode})",
      );
    }
  }
}
