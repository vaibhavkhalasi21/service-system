import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_request.dart';

class VendorApplicationApi {
  static const String baseUrl =
      "http://10.29.111.37:5244/api/application";

  // ===============================
  // GET VENDOR APPLICATIONS
  // ===============================
  static Future<List<BookingRequest>> getRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) {
      throw Exception("Vendor token missing");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/vendor"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load applications (${response.statusCode})",
      );
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => BookingRequest.fromJson(e)).toList();
  }

  // ===============================
  // ACCEPT / REJECT APPLICATION
  // 🔥 UNCHANGED (IMPORTANT)
  // ===============================
  static Future<void> updateStatus(int id, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    final response = await http.put(
      Uri.parse("$baseUrl/$id/status?status=$status"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("🟥 UPDATE STATUS CODE: ${response.statusCode}");
    print("🟥 UPDATE STATUS BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to update status");
    }
  }


  // ===============================
  // MARK PAYMENT AS PAID
  // ✅ OLD CALL STILL WORKS
  // ===============================
  static Future<void> markPaymentPaid(int applicationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) {
      throw Exception("Vendor not logged in");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/$applicationId/pay"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to mark payment as paid");
    }
  }

  // ===============================
  // MARK PAYMENT WITH METHOD
  // 🔥 NEW (OPTIONAL)
  // ===============================
  static Future<void> markPaymentPaidWithMethod(
      int applicationId,
      String method, // Cash | Online
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) {
      throw Exception("Vendor not logged in");
    }

    final response = await http.put(
      Uri.parse(
        "$baseUrl/$applicationId/pay?method=$method",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to mark payment as paid");
    }
  }

  // ===============================
  // RATE WORKER
  // ===============================
  static Future<void> rateWorker(
      int applicationId,
      int rating,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) {
      throw Exception("Vendor token not found");
    }

    final response = await http.post(
      Uri.parse(
        "$baseUrl/$applicationId/rate-worker?rating=$rating",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to rate worker");
    }
  }
}
