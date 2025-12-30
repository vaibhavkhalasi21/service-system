import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/service_request.dart';

class ServiceApi {
  static const String baseUrl =
      "http://10.141.25.71:5244/api/service";

  // =========================
  // GET ALL SERVICES
  // =========================
  static Future<List<ServiceRequest>> getServices() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map((e) => ServiceRequest.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load services");
    }
  }

  // =========================
  // ADD SERVICE
  // =========================
  static Future<bool> addService(ServiceRequest service) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(service.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // =========================
  // DELETE SERVICE
  // =========================
  static Future<bool> deleteService(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    return response.statusCode == 200;
  }
}
