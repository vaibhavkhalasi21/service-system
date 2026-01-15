import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vendor_application_item.dart';
import '../models/vendor_booking_request.dart';

class VendorApplicationApi {
  static const String baseUrl =
      "http://10.29.111.37:5244/api/application";

  // =====================================================
  // 🔵 VENDOR APPLICATIONS LIST (INCOMING REQUESTS)
  // Uses VendorApplicationItem
  // =====================================================
  static Future<List<VendorApplicationItem>> getApplicationItems() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) {
      throw Exception("Vendor token missing");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/vendor"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("🟣 APPLICATION ITEMS STATUS: ${response.statusCode}");
    print("🟣 APPLICATION ITEMS BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load applications (${response.statusCode})",
      );
    }

    final List data = jsonDecode(response.body);
    return data
        .map((e) => VendorApplicationItem.fromJson(e))
        .toList();
  }

  // =====================================================
  // 🟢 VENDOR JOBS (ACCEPTED / COMPLETED / CANCELLED)
  // Uses VendorBookingRequest
  // =====================================================
  static Future<List<VendorBookingRequest>> getApplications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) {
      throw Exception("Vendor token missing");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/vendor"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("🟢 JOBS STATUS: ${response.statusCode}");
    print("🟢 JOBS BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load jobs (${response.statusCode})",
      );
    }

    final List data = jsonDecode(response.body);
    return data
        .map((e) => VendorBookingRequest.fromJson(e))
        .toList();
  }

  // =====================================================
  // ACCEPT / REJECT APPLICATION
  // =====================================================
  static Future<void> updateStatus(int id, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) {
      throw Exception("Vendor token missing");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/$id/status?status=$status"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update status");
    }
  }

  // =====================================================
  // MARK PAYMENT AS PAID
  // =====================================================
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
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to mark payment as paid");
    }
  }

  // =====================================================
  // MARK PAYMENT WITH METHOD
  // =====================================================
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
      Uri.parse("$baseUrl/$applicationId/pay?method=$method"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to mark payment as paid");
    }
  }

  // =====================================================
  // RATE WORKER
  // =====================================================
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
      Uri.parse("$baseUrl/$applicationId/rate-worker?rating=$rating"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to rate worker");
    }
  }
}
