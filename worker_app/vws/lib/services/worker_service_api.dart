import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/booking_model.dart';
import '../model/service_model.dart';

class WorkerServiceApi {
  static const String baseUrl = "http://10.141.25.37:5244/api";

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
  // APPLY FOR SERVICE ✅ FIXED
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