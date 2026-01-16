import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/job_model.dart';

class WorkerServiceApi {
  // ===============================
  // 🔥 SERVER CONFIG (SAFE)
  // ===============================
  static const String _host = "172.20.253.37:5244";
  static const String _basePath = "/api";

  static String? _token; // 🔥 cached token

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
    _token = prefs.getString("worker_token");

    if (_token == null) {
      throw Exception("Worker not logged in");
    }
  }

  // ===============================
  // PUBLIC SERVICES
  // ===============================
  static Future<List<ServiceModel>> getServices() async {
    final uri = Uri.http(_host, "$_basePath/service/public");

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Failed to load services");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => ServiceModel.fromJson(e)).toList();
  }

  // ===============================
  // APPLY FOR SERVICE (OLD)
  // ===============================
  static Future<bool> applyForService(int serviceId) async {
    await _loadToken();

    final uri =
    Uri.http(_host, "$_basePath/application/apply/$serviceId");

    final response = await http.post(uri, headers: _headers);

    return response.statusCode == 200;
  }

  // ===============================
  // 🔥 APPLY FOR SERVICE (WITH LOCATION)
  // ===============================
  static Future<bool> applyForServiceWithLocation({
    required int serviceId,
    required double serviceLatitude,
    required double serviceLongitude,
    required String serviceAddress,
    required double workerLatitude,
    required double workerLongitude,
  }) async {
    await _loadToken();

    final uri =
    Uri.http(_host, "$_basePath/application/apply/$serviceId");

    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({
        "serviceLatitude": serviceLatitude,
        "serviceLongitude": serviceLongitude,
        "serviceAddress": serviceAddress,
        "workerLatitude": workerLatitude,
        "workerLongitude": workerLongitude,
      }),
    );

    return response.statusCode == 200;
  }

  // ===============================
  // 🔥 UPDATE WORKER LOCATION
  // ===============================
  static Future<void> updateWorkerLocation({
    required double latitude,
    required double longitude,
  }) async {
    await _loadToken();

    final uri = Uri.http(_host, "$_basePath/worker/location");

    final response = await http.put(
      uri,
      headers: _headers,
      body: jsonEncode({
        "latitude": latitude,
        "longitude": longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update worker location");
    }
  }

  // ===============================
  // 🔥 NEARBY JOBS
  // ===============================
  static Future<List<MyJob>> getNearbyJobs() async {
    await _loadToken();

    final uri = Uri.http(_host, "$_basePath/worker/nearby-jobs");

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to load nearby jobs");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => MyJob.fromJson(e)).toList();
  }

  // ===============================
  // MARK JOB COMPLETED
  // ===============================
  static Future<bool> markJobCompleted(int applicationId) async {
    await _loadToken();

    final uri = Uri.http(
        _host, "$_basePath/application/$applicationId/complete");

    final response = await http.put(uri, headers: _headers);

    return response.statusCode == 200;
  }

  // ===============================
  // MY BOOKINGS
  // ===============================
  static Future<List<Booking>> getMyBookings() async {
    await _loadToken();

    final uri =
    Uri.http(_host, "$_basePath/application/worker");

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to load bookings");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => Booking.fromJson(e)).toList();
  }

  // ===============================
  // LOGOUT (OPTIONAL BUT GOOD)
  // ===============================
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("worker_token");
    _token = null;
  }
}
