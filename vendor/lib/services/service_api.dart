import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/service_request.dart';
import '../Models/create_service_request.dart';

class ServiceApi {
  static const String apiUrl = "http://10.141.25.37:5244/api/service";

  // =========================
  // GET SERVICES (PUBLIC)
  // =========================
  static Future<List<ServiceRequest>> getServices() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ServiceRequest.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load services");
    }
  }

  // =========================
  // ADD SERVICE (POST + IMAGE)
  // =========================
  static Future<bool> addService(
      CreateServiceRequest service,
      File? image,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    final request = http.MultipartRequest(
      "POST",
      Uri.parse(apiUrl),
    );

    // 🔐 JWT HEADER
    request.headers["Authorization"] = "Bearer $token";

    // FORM DATA
    request.fields["serviceName"] = service.serviceName;
    request.fields["category"] = service.category;
    request.fields["price"] = service.price.toString();

    if (service.description != null) {
      request.fields["description"] = service.description!;
    }

    // IMAGE
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", image.path),
      );
    }

    final response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // =========================
  // UPDATE SERVICE (PUT + IMAGE)
  // =========================
  static Future<bool> updateService(
      int serviceId,
      ServiceRequest service,
      File? image,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    final request = http.MultipartRequest(
      "PUT",
      Uri.parse("$apiUrl/$serviceId"),
    );

    // 🔐 JWT HEADER
    request.headers["Authorization"] = "Bearer $token";

    // FORM DATA
    request.fields["serviceName"] = service.serviceName;
    request.fields["category"] = service.category;
    request.fields["price"] = service.price.toString();

    // IMAGE (OPTIONAL)
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", image.path),
      );
    }

    final response = await request.send();
    return response.statusCode == 200;
  }

  // =========================
  // DELETE SERVICE (OPTIONAL)
  // =========================
  static Future<bool> deleteService(int serviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    final response = await http.delete(
      Uri.parse("$apiUrl/$serviceId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }
}
