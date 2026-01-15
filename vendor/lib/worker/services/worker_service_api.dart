import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/job_model.dart';

class WorkerServiceApi {
  static const String baseUrl = "http://10.29.111.37:5244/api";

  // ===============================
  // PUBLIC SERVICES
  // ===============================
  static Future<List<ServiceModel>> getServices() async {
    final response =
    await http.get(Uri.parse("$baseUrl/service/public"));

    if (response.statusCode != 200) {
      throw Exception("Failed to load services");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => ServiceModel.fromJson(e)).toList();
  }

  // ===============================
  // APPLY FOR SERVICE (OLD - KEPT)
  // ===============================
  static Future<bool> applyForService(int serviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("worker_token");

    if (token == null) throw Exception("Worker not logged in");

    final response = await http.post(
      Uri.parse("$baseUrl/application/apply/$serviceId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }

  // ===============================
// 🔥 APPLY FOR SERVICE (WITH WORKER LOCATION)
// ===============================
  static Future<bool> applyForServiceWithLocation({
    required int serviceId,
    required double serviceLatitude,
    required double serviceLongitude,
    required String serviceAddress,

    // 🔥 NEW (REQUIRED)
    required double workerLatitude,
    required double workerLongitude,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("worker_token");

    if (token == null) throw Exception("Worker not logged in");

    final response = await http.post(
      Uri.parse("$baseUrl/application/apply/$serviceId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        // 📍 SERVICE LOCATION
        "serviceLatitude": serviceLatitude,
        "serviceLongitude": serviceLongitude,
        "serviceAddress": serviceAddress,

        // 📍 WORKER LOCATION (NEW)
        "workerLatitude": workerLatitude,
        "workerLongitude": workerLongitude,
      }),
    );

    return response.statusCode == 200;
  }


  // ===============================
  // 🔥 UPDATE WORKER LOCATION (NEW)
  // ===============================
  static Future<void> updateWorkerLocation({
    required double latitude,
    required double longitude,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("worker_token");

    if (token == null) {
      throw Exception("Worker not logged in");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/worker/location"), // ✅ MATCHES BACKEND
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
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
  // 🔥 NEARBY JOBS (LOCATION BASED)
  // ===============================
  static Future<List<MyJob>> getNearbyJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("worker_token");

    if (token == null) {
      throw Exception("Worker not logged in");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/worker/nearby-jobs"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("NEARBY JOBS STATUS: ${response.statusCode}");
    print("NEARBY JOBS BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => MyJob.fromJson(e)).toList();
  }

  // ===============================
  // MARK JOB COMPLETED
  // ===============================
  static Future<bool> markJobCompleted(int applicationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("worker_token");

    if (token == null) throw Exception("Worker not logged in");

    final response = await http.put(
      Uri.parse("$baseUrl/application/$applicationId/complete"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }

  // ===============================
  // MY APPLICATIONS
  // ===============================
  static Future<List<Booking>> getMyBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("worker_token");

    if (token == null) throw Exception("Worker not logged in");

    final response = await http.get(
      Uri.parse("$baseUrl/application/worker"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load bookings");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => Booking.fromJson(e)).toList();
  }
}
