import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vendor_create_service_request.dart';
import '../models/vendor_service_request.dart';

class ServiceApi {
  static const String baseUrl = "http://172.20.253.37:5244/api/service";

  // =========================================
  // WORKER: GET PUBLIC SERVICES
  // =========================================
  static Future<List<VendorServiceRequest>> getPublicServices() async {
    final response = await http.get(Uri.parse("$baseUrl/public"));

    if (response.statusCode != 200) {
      throw Exception("Failed to load public services");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => VendorServiceRequest.fromJson(e)).toList();
  }

  // =========================================
  // VENDOR: GET MY SERVICES
  // =========================================
  static Future<List<VendorServiceRequest>> getVendorServices() async {
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
    return data.map((e) => VendorServiceRequest.fromJson(e)).toList();
  }

  // =========================================
  // VENDOR: ADD SERVICE (🔥 FIXED)
  // =========================================
  static Future<bool> addService(
      VendorCreateServiceRequest service,
      File? image,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) {
      throw Exception("Vendor token not found. Please login again.");
    }

    final request =
    http.MultipartRequest("POST", Uri.parse(baseUrl));

    request.headers["Authorization"] = "Bearer $token";

    // ✅ BASIC FIELDS (ALL STRINGS)
    request.fields["serviceName"] = service.serviceName;
    request.fields["category"] = service.category.toString(); // 🔥 FIX
    request.fields["price"] = service.price.toString();
    request.fields["serviceDateTime"] =
        service.serviceDateTime.toIso8601String();

    // 🔥 LOCATION
    request.fields["address"] = service.address;
    request.fields["latitude"] = service.latitude.toString();
    request.fields["longitude"] = service.longitude.toString();

    // OPTIONAL DESCRIPTION
    if (service.description != null &&
        service.description!.isNotEmpty) {
      request.fields["description"] = service.description!;
    }

    // IMAGE
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", image.path),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print("POST STATUS: ${response.statusCode}");
    print("POST BODY: $body");

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  // =========================================
  // VENDOR: UPDATE SERVICE (🔥 FIXED)
  // =========================================
  static Future<bool> updateService(
      int serviceId,
      VendorCreateServiceRequest service,
      File? image,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    if (token == null) return false;

    final request = http.MultipartRequest(
      "PUT",
      Uri.parse("$baseUrl/$serviceId"),
    );

    request.headers["Authorization"] = "Bearer $token";

    // ✅ BASIC FIELDS (ALL STRINGS)
    request.fields["serviceName"] = service.serviceName;
    request.fields["category"] = service.category.toString(); // 🔥 FIX
    request.fields["price"] = service.price.toString();
    request.fields["serviceDateTime"] =
        service.serviceDateTime.toIso8601String();

    // 🔥 LOCATION
    request.fields["address"] = service.address;
    request.fields["latitude"] = service.latitude.toString();
    request.fields["longitude"] = service.longitude.toString();

    if (service.description != null &&
        service.description!.isNotEmpty) {
      request.fields["description"] = service.description!;
    }

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", image.path),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print("UPDATE STATUS: ${response.statusCode}");
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
