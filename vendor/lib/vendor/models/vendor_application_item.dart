class VendorApplicationItem {
  final int id;

  // 👤 WORKER
  final String workerName;
  final String workerEmail;

  // 🛠 SERVICE
  final String serviceName;
  final String category; // ✅ STRING

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
      id: json['id'] ?? json['Id'],

      workerName: json['workerName'] ?? json['WorkerName'] ?? "",
      workerEmail: json['workerEmail'] ?? json['WorkerEmail'] ?? "",

      serviceName: json['serviceName'] ?? json['ServiceName'] ?? "",

      // ✅ FIXED
      category: (json['category'] ?? json['Category'])?.toString() ?? "Unknown",

      status: json['status'] ?? json['Status'] ?? "Pending",

      createdAt: DateTime.parse(
        json['createdAt'] ?? json['CreatedAt'],
      ).toLocal(),

      workerLatitude:
      (json['workerLatitude'] ?? json['WorkerLatitude'])?.toDouble(),
      workerLongitude:
      (json['workerLongitude'] ?? json['WorkerLongitude'])?.toDouble(),

      serviceLatitude:
      (json['serviceLatitude'] ?? json['ServiceLatitude'])?.toDouble(),
      serviceLongitude:
      (json['serviceLongitude'] ?? json['ServiceLongitude'])?.toDouble(),

      serviceAddress:
      json['serviceAddress'] ?? json['ServiceAddress'],
    );
  }
}
