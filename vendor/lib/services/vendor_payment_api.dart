import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vendor_payment.dart';

class VendorPaymentApi {
  static const String baseUrl = "http://10.29.111.37:5244/api/application";

  // 🔹 Get completed jobs
  static Future<List<VendorPayment>> getPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    final response = await http.get(
      Uri.parse("$baseUrl/vendor"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load payments");
    }

    final List data = jsonDecode(response.body);

    // ✅ ONLY COMPLETED JOBS
    return data
        .where((e) => e['status'] == "Completed")
        .map((e) => VendorPayment.fromJson(e))
        .toList();
  }

  // 🔹 Mark payment as paid
  static Future<void> markPaid(int applicationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    await http.put(
      Uri.parse("$baseUrl/$applicationId/pay"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}
