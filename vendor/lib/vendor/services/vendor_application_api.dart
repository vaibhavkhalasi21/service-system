import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vendor_application_item.dart';
import '../models/vendor_booking_request.dart';

class VendorApplicationApi {
  // ===============================
  // 🔥 SERVER CONFIG
  // ===============================
  static const String _host = "172.20.253.37:5244";
  static const String _basePath = "/api/application";

  static String? _token; // cached vendor token

  // ===============================
  // 🔥 COMMON HEADERS
  // ===============================
  static Map<String, String> get _headers => {
    "Authorization": "Bearer $_token",
    "Content-Type": "application/json",
  };

  // ===============================
  // 🔥 LOAD TOKEN ONCE
  // ===============================
  static Future<void> _loadToken() async {
    if (_token != null) return;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("vendor_token");

    if (_token == null) {
      throw Exception("Vendor token missing");
    }
  }

  // =====================================================
// 🔵 VENDOR APPLICATIONS (INCOMING REQUESTS)
// =====================================================
  static Future<List<VendorApplicationItem>> getApplicationItems() async {
    await _loadToken();

    final uri = Uri.http(
      _host,
      "$_basePath/vendor/applications",
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to load applications (${response.statusCode})");
    }

    final List data = jsonDecode(response.body);
    return data
        .map((e) => VendorApplicationItem.fromJson(e))
        .toList();
  }



  // =====================================================
  // 🟢 VENDOR JOBS (ACCEPTED / COMPLETED / CANCELLED)
  // =====================================================
  static Future<List<VendorBookingRequest>> getApplications() async {
    await _loadToken();

    final uri = Uri.http(_host, "$_basePath/vendor");

    final response = await http.get(uri, headers: _headers);

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
    await _loadToken();

    final uri = Uri.http(
      _host,
      "$_basePath/$id/status",
      {"status": status},
    );

    final response = await http.put(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to update status");
    }
  }

  // =====================================================
  // MARK PAYMENT AS PAID
  // =====================================================
  static Future<void> markPaymentPaid(int applicationId) async {
    await _loadToken();

    final uri =
    Uri.http(_host, "$_basePath/$applicationId/pay");

    final response = await http.put(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to mark payment as paid");
    }
  }

  // =====================================================
  // MARK PAYMENT WITH METHOD (Cash | Online)
  // =====================================================
  static Future<void> markPaymentPaidWithMethod(
      int applicationId,
      String method,
      ) async {
    await _loadToken();

    final uri = Uri.http(
      _host,
      "$_basePath/$applicationId/pay",
      {"method": method},
    );

    final response = await http.put(uri, headers: _headers);

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
    await _loadToken();

    final uri = Uri.http(
      _host,
      "$_basePath/$applicationId/rate-worker",
      {"rating": rating.toString()},
    );

    final response = await http.post(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to rate worker");
    }
  }

  // =====================================================
  // LOGOUT / CLEAR SESSION (OPTIONAL)
  // =====================================================
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("vendor_token");
    _token = null;
  }
}
