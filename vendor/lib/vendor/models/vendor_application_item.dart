import '../constants/service_categories.dart';

class VendorApplicationItem {
  final int id;

  // 👤 WORKER
  final String workerName;
  final String workerEmail;

  // 🛠 SERVICE
  final String serviceName;
  final int category;

  // 📍 WORKER LOCATION
  final double? workerLatitude;
  final double? workerLongitude;

  // 📍 SERVICE LOCATION
  final String? serviceAddress;
  final double? serviceLatitude;
  final double? serviceLongitude;

  // 🔄 STATUS
  final String status;
  final DateTime createdAt;

  VendorApplicationItem({
    required this.id,
    required this.workerName,
    required this.workerEmail,
    required this.serviceName,
    required this.category,
    required this.status,
    required this.createdAt,
    this.workerLatitude,
    this.workerLongitude,
    this.serviceAddress,
    this.serviceLatitude,
    this.serviceLongitude,
  });

  factory VendorApplicationItem.fromJson(Map<String, dynamic> json) {
    return VendorApplicationItem(
      id: json['id'],

      workerName: json['workerName'] ?? "",
      workerEmail: json['workerEmail'] ?? "",

      serviceName: json['serviceName'] ?? "",

      /// 🔥 FIXED CATEGORY (STRING OR INT SAFE)
      category: json['category'] is int
          ? json['category']
          : mapCategoryToEnum(json['category']),

      status: json['status'] ?? "Pending",
      createdAt: DateTime.parse(json['createdAt']).toLocal(),

      workerLatitude: json['workerLatitude'] != null
          ? double.tryParse(json['workerLatitude'].toString())
          : null,

      workerLongitude: json['workerLongitude'] != null
          ? double.tryParse(json['workerLongitude'].toString())
          : null,

      serviceLatitude: json['serviceLatitude'] != null
          ? double.tryParse(json['serviceLatitude'].toString())
          : null,

      serviceLongitude: json['serviceLongitude'] != null
          ? double.tryParse(json['serviceLongitude'].toString())
          : null,

      serviceAddress: json['serviceAddress'],
    );
  }
}
