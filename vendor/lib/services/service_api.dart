import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/service_request.dart';
import '../models/create_service_request.dart';

class ServiceApi {
  static const String baseUrl = "http://10.141.25.37:5244/api/service";

  // =========================================
  // WORKER: GET PUBLIC SERVICES
  // =========================================
  static Future<List<ServiceRequest>> getPublicServices() async {
    final response = await http.get(Uri.parse("$baseUrl/public"));

    if (response.statusCode != 200) {
      throw Exception("Failed to load public services");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => ServiceRequest.fromJson(e)).toList();
  }

  // =========================================
  // VENDOR: GET MY SERVICES
  // =========================================
  static Future<List<ServiceRequest>> getVendorServices() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) {
      throw Exception("Vendor token not found");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/vendor"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load vendor services");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => ServiceRequest.fromJson(e)).toList();
  }

  // =========================================
  // VENDOR: ADD SERVICE
  // =========================================
  static Future<bool> addService(
      CreateServiceRequest service,
      File? image,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");
    if (token == null) return false;

    final request =
    http.MultipartRequest("POST", Uri.parse(baseUrl));

    request.headers["Authorization"] = "Bearer $token";

    request.fields["serviceName"] = service.serviceName;
    request.fields["category"] = service.category;
    request.fields["price"] = service.price.toString();

    // 🆕 scheduled date & time (UTC)
    request.fields["serviceDateTime"] =
        service.serviceDateTime.toUtc().toIso8601String();

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", image.path),
      );
    }

    final response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // =========================================
  // VENDOR: UPDATE SERVICE
  // =========================================
  static Future<bool> updateService(
      int serviceId,
      CreateServiceRequest service,
      File? image,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) return false;

    final request = http.MultipartRequest(
      "PUT", // ✅ MUST BE PUT
      Uri.parse("$baseUrl/$serviceId"),
    );

    request.headers["Authorization"] = "Bearer $token";

    // REQUIRED FIELDS
    request.fields["serviceName"] = service.serviceName;
    request.fields["category"] = service.category; // ✅ STRING
    request.fields["price"] = service.price.toString();
    request.fields["serviceDateTime"] =
        service.serviceDateTime.toUtc().toIso8601String();

    if (service.description != null) {
      request.fields["description"] = service.description!;
    }

    // IMAGE OPTIONAL
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", image.path),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    // 🔎 DEBUG (TEMP)
    // ignore: avoid_print
    print("UPDATE STATUS: ${response.statusCode}");
    // ignore: avoid_print
    print("UPDATE BODY: $body");

    return response.statusCode == 200;
  }


  // =========================================
  // VENDOR: DELETE SERVICE
  // =========================================
  static Future<bool> deleteService(int serviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");
    if (token == null) return false;

    final response = await http.delete(
      Uri.parse("$baseUrl/$serviceId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }
}
