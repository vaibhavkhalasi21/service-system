import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/service_request.dart';

class ServiceApi {
  static const String baseUrl =
      "http://10.141.25.233:5244/api/service";

  // =========================
  // GET SERVICES (PUBLIC)
  // =========================
  static Future<List<ServiceRequest>> getServices() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ServiceRequest.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load services");
    }
  }

  // =========================
  // ADD SERVICE (JWT + IMAGE)
  // =========================
  static Future<bool> addService(
      ServiceRequest service,
      File? image,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("vendor_token");

    final request = http.MultipartRequest(
      "POST",
      Uri.parse(baseUrl),
    );

    // 🔐 JWT HEADER
    request.headers["Authorization"] = "Bearer $token";

    // FORM FIELDS
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

    print("STATUS: ${response.statusCode}");
    print(await response.stream.bytesToString());

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }
}
