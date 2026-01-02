import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/service_model.dart';

class WorkerServiceApi {
  // Worker should hit the PUBLIC service endpoint
  static const String baseUrl = "http://10.141.25.37:5244/api/service";

  // GET PUBLIC SERVICES
  static Future<List<ServiceModel>> getServices() async {
    final response = await http.get(Uri.parse("$baseUrl/public"));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map((e) => ServiceModel.fromJson(e)).toList();
      } else {
        throw Exception("Unexpected API response");
      }
    } else {
      throw Exception("Failed to load services");
    }
  }

  // APPLY FOR SERVICE
  static Future<bool> applyForService(int serviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("worker_token");

    if (token == null) throw Exception("Worker not logged in");

    final response = await http.post(
      Uri.parse("http://10.141.25.37:5244/api/booking/apply/$serviceId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return response.statusCode == 200;
  }
}
