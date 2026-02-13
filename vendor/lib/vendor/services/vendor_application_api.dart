import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vendor_application_item.dart';
import '../models/vendor_booking_request.dart';

class VendorApplicationApi {
  // ===============================
  // 🔥 SERVER CONFIG
  // ===============================
  static const String _host = "10.113.136.37:5244";
  static const String _basePath = "/api/application";

  static String? _token;

  // ===============================
  // 🔥 COMMON HEADERS
  // ===============================
  static Map<String, String> get _headers => {
    "Authorization": "Bearer $_token",
    "Content-Type": "application/json",
  };

  // ===============================
  // 🔥 LOAD TOKEN
  // ===============================
  static Future<void> _loadToken() async {
    if (_token != null) return;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("vendor_token");

    if (_token == null || _token!.isEmpty) {
      throw Exception("Vendor not logged in");
    }
  }

  // =====================================================
  // 🔵 PENDING APPLICATION REQUESTS
  // =====================================================
  // =====================================================
// 🔵 PENDING APPLICATIONS (Vendor requests)
// =====================================================
  static Future<List<VendorApplicationItem>> getApplicationItems() async {
    await _loadToken();

    final response = await http.get(
      Uri.http(_host, "$_basePath/vendor"),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load applications (${response.statusCode})",
      );
    }

    final List data = jsonDecode(response.body);

    return data
        .where((e) => e['status'] == "Pending")
        .map((e) => VendorApplicationItem.fromJson(e))
        .toList();
  }


  // =====================================================
  // 🟢 VENDOR JOBS (Accepted / Completed / Paid)
  // =====================================================
  static Future<List<VendorBookingRequest>> getVendorJobs() async {
    await _loadToken();

    final response = await http.get(
      Uri.http(_host, "$_basePath/vendor"),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load jobs (${response.statusCode})",
      );
    }

    final List data = jsonDecode(response.body);

    return data
        .where((e) => e['status'] != "Pending")
        .map((e) => VendorBookingRequest.fromJson(e))
        .toList();
  }

  // =====================================================
  // ✅ ACCEPT / ❌ REJECT APPLICATION
  // =====================================================
  static Future<void> updateStatus(int id, String status) async {
    await _loadToken();

    final response = await http.put(
      Uri.http(
        _host,
        "$_basePath/$id/status",
        {"status": status},
      ),
      headers: _headers,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Failed to update status");
    }
  }

  // =====================================================
  // 💰 MARK PAYMENT (Cash | Online)
  // =====================================================
  static Future<void> markPaymentPaid(
      int applicationId,
      String method,
      ) async {
    await _loadToken();

    final response = await http.put(
      Uri.http(
        _host,
        "$_basePath/$applicationId/pay",
        {"method": method},
      ),
      headers: _headers,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Failed to mark payment");
    }
  }

  // =====================================================
  // ⭐ RATE WORKER
  // =====================================================
  static Future<void> rateWorker(
      int applicationId,
      int rating,
      ) async {
    await _loadToken();

    final response = await http.post(
      Uri.http(
        _host,
        "$_basePath/$applicationId/rate-worker",
        {"rating": rating.toString()},
      ),
      headers: _headers,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Failed to rate worker");
    }
  }

  // =====================================================
  // 🔒 LOGOUT
  // =====================================================
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("vendor_token");
    _token = null;
  }
}
