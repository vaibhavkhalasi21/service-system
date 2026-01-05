import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_request.dart';

class VendorApplicationApi {
  static const String baseUrl =
      "http://10.141.25.37:5244/api/application";

  static Future<List<BookingRequest>> getRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) {
      throw Exception("Vendor token missing");
    }

    print("🔐 Vendor Token: $token");

    final response = await http.get(
      Uri.parse("$baseUrl/vendor"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("📡 STATUS CODE: ${response.statusCode}");
    print("📦 RESPONSE BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load applications (${response.statusCode})",
      );
    }

    final List data = jsonDecode(response.body);
    return data
        .map((e) => BookingRequest.fromJson(e))
        .toList();
  }

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
      },
    );

    print("🔁 UPDATE STATUS: ${response.statusCode}");
    print("🔁 UPDATE BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to update status");
    }
  }
}
