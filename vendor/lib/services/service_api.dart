import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Models/service_request.dart';

class ServiceApi {
  static const String baseUrl =
      "http://10.141.25.37:5244/api/service";

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
  // ADD SERVICE (MULTIPART)
  // =========================
  static Future<bool> addService(
      ServiceRequest service,
      File? image,
      ) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(baseUrl),
    );

    request.fields["serviceName"] = service.serviceName;
    request.fields["category"] = service.category;
    request.fields["price"] = service.price.toString();

    if (service.description != null) {
      request.fields["description"] = service.description!;
    }

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          image.path,
        ),
      );
    }

    final response = await request.send();
    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  // =========================
  // DELETE SERVICE
  // =========================
  static Future<bool> deleteService(int id) async {
    final response =
    await http.delete(Uri.parse("$baseUrl/$id"));
    return response.statusCode == 200;
  }
}
