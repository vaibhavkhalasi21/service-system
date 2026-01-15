class VendorApplicationItem {
  final int id;

  // 👤 WORKER
  final String workerName;
  final String workerEmail;

  // 🛠 SERVICE
  final String serviceName;
  final String category;

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
      category: json['category'] ?? "",
      status: json['status'] ?? "Pending",
      createdAt: DateTime.parse(json['createdAt']),
      workerLatitude: (json['workerLatitude'] as num?)?.toDouble(),
      workerLongitude: (json['workerLongitude'] as num?)?.toDouble(),
      serviceLatitude: (json['serviceLatitude'] as num?)?.toDouble(),
      serviceLongitude: (json['serviceLongitude'] as num?)?.toDouble(),
      serviceAddress: json['serviceAddress'],
    );
  }
}
