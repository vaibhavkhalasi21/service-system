import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // ✅ REQUIRED for debugPrint

import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/job_model.dart';

class WorkerServiceApi {
  static const String _host = "10.113.136.37:5244";
  static const String _basePath = "/api";

  static String? _token;

  // ================= HEADERS =================
  static Map<String, String> get _headers => {
    "Authorization": "Bearer $_token",
    "Content-Type": "application/json",
  };

  // ================= TOKEN =================
  static Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("worker_token");

    if (_token == null || _token!.isEmpty) {
      throw Exception("Worker not logged in");
    }
  }

  // ================= PUBLIC SERVICES =================
  static Future<List<ServiceModel>> getServices() async {
    final res = await http.get(
      Uri.http(_host, "$_basePath/service/public"),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to load services");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => ServiceModel.fromJson(e)).toList();
  }

  // ================= APPLY FOR SERVICE =================
  static Future<bool> applyForServiceWithLocation({
    required int serviceId,
    required double workerLatitude,
    required double workerLongitude,
  }) async {
    await _loadToken();

    final res = await http.post(
      Uri.http(_host, "$_basePath/application/apply/$serviceId"),
      headers: _headers,
      body: jsonEncode({
        "workerLatitude": workerLatitude,
        "workerLongitude": workerLongitude,
      }),
    );

    if (res.statusCode == 409) return false;
    if (res.statusCode >= 200 && res.statusCode < 300) return true;

    throw Exception("Apply failed (${res.statusCode})");
  }

  // ================= WORKER BOOKINGS =================
  static Future<List<Booking>> getMyBookings() async {
    await _loadToken();

    final res = await http.get(
      Uri.http(_host, "$_basePath/application/worker"),
      headers: _headers,
    );

    debugPrint("WORKER BOOKINGS RAW: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Failed to load bookings");
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => Booking.fromJson(e)).toList();
  }

  // ================= MARK JOB COMPLETED =================
  static Future<bool> markJobCompleted(int applicationId) async {
    await _loadToken();

    final res = await http.put(
      Uri.http(_host, "$_basePath/application/$applicationId/complete"),
      headers: _headers,
    );

    return res.statusCode >= 200 && res.statusCode < 300;
  }

  // ================= UPDATE WORKER LOCATION =================
  static Future<void> updateWorkerLocation({
    required double latitude,
    required double longitude,
  }) async {
    await _loadToken();

    final res = await http.put(
      Uri.http(_host, "$_basePath/worker/location"),
      headers: _headers,
      body: jsonEncode({
        "latitude": latitude,
        "longitude": longitude,
      }),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Failed to update worker location");
    }
  }

  // ================= NEARBY JOBS (DASHBOARD) =================
  static Future<List<MyJob>> getNearbyJobs() async {
    await _loadToken();

    final res = await http.get(
      Uri.http(_host, "$_basePath/worker/nearby-jobs"),
      headers: _headers,
    );

    if (res.statusCode != 200 || res.body.isEmpty) {
      return [];
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => MyJob.fromJson(e)).toList();
  }

  // ================= LOGOUT =================
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("worker_token");
    _token = null;
  }
}
