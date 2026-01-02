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
    final response = await http.get(
      Uri.parse("$baseUrl/public"),
    );

    if (response.statusCode != 200) {
      print("PUBLIC SERVICES ERROR: ${response.body}");
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

    print("VENDOR TOKEN (GET): $token");

    if (token == null) {
      throw Exception("Vendor token not found");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/vendor"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("GET SERVICES STATUS: ${response.statusCode}");
    print("GET SERVICES BODY: ${response.body}");

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

    print("VENDOR TOKEN (ADD): $token");

    if (token == null) return false;

    final request = http.MultipartRequest(
      "POST",
      Uri.parse(baseUrl),
    );

    request.headers["Authorization"] = "Bearer $token";

    request.fields["serviceName"] = service.serviceName;
    request.fields["category"] = service.category;
    request.fields["price"] = service.price.toString();

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", image.path),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print("ADD SERVICE STATUS: ${response.statusCode}");
    print("ADD SERVICE BODY: $body");

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

    print("VENDOR TOKEN (UPDATE): $token");

    if (token == null) return false;

    final request = http.MultipartRequest(
      "PUT",
      Uri.parse("$baseUrl/$serviceId"),
    );

    request.headers["Authorization"] = "Bearer $token";

    request.fields["serviceName"] = service.serviceName;
    request.fields["category"] = service.category;
    request.fields["price"] = service.price.toString();

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", image.path),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print("UPDATE SERVICE STATUS: ${response.statusCode}");
    print("UPDATE SERVICE BODY: $body");

    return response.statusCode == 200;
  }

  // =========================================
  // VENDOR: DELETE SERVICE
  // =========================================
  static Future<bool> deleteService(int serviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    print("VENDOR TOKEN (DELETE): $token");

    if (token == null) return false;

    final response = await http.delete(
      Uri.parse("$baseUrl/$serviceId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("DELETE SERVICE STATUS: ${response.statusCode}");
    print("DELETE SERVICE BODY: ${response.body}");

    return response.statusCode == 200;
  }
}
