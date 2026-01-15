class VendorBookingRequest {
  final int id;

  // 👤 WORKER
  final String workerName;
  final String workerEmail;

  // 📍 WORKER LOCATION (NEW)
  final double? workerLatitude;
  final double? workerLongitude;

  // 🛠 SERVICE
  final String serviceName;
  final int price;
  final DateTime serviceDateTime;

  // 📍 SERVICE LOCATION
  final String? serviceAddress;
  final double? serviceLatitude;
  final double? serviceLongitude;

  // 🔄 STATUS
  final String status;
  final String paymentStatus;

  // ⭐ RATINGS
  final bool vendorRated;
  final int? vendorRating;

  // 💳 PAYMENT
  final String? paymentMethod;

  VendorBookingRequest({
    required this.id,

    // 👤 WORKER
    required this.workerName,
    required this.workerEmail,

    // 📍 WORKER LOCATION
    this.workerLatitude,
    this.workerLongitude,

    // 🛠 SERVICE
    required this.serviceName,
    required this.price,
    required this.serviceDateTime,

    // 📍 SERVICE LOCATION
    this.serviceAddress,
    this.serviceLatitude,
    this.serviceLongitude,

    // 🔄 STATUS
    required this.status,
    required this.paymentStatus,

    // ⭐ RATINGS
    required this.vendorRated,
    this.vendorRating,

    // 💳 PAYMENT
    this.paymentMethod,
  });

  factory VendorBookingRequest.fromJson(Map<String, dynamic> json) {
    return VendorBookingRequest(
      id: json['id'],

      // 👤 WORKER
      workerName: json['workerName'] ?? "",
      workerEmail: json['workerEmail'] ?? "",

      // 📍 WORKER LOCATION (NEW)
      workerLatitude: json['workerLatitude'] != null
          ? (json['workerLatitude'] as num).toDouble()
          : null,
      workerLongitude: json['workerLongitude'] != null
          ? (json['workerLongitude'] as num).toDouble()
          : null,

      // 🛠 SERVICE
      serviceName: json['serviceName'] ?? "",
      price: (json['price'] as num).toInt(),
      serviceDateTime: DateTime.parse(json['serviceDateTime']),

      // 📍 SERVICE LOCATION
      serviceAddress: json['serviceAddress'],
      serviceLatitude: json['serviceLatitude'] != null
          ? (json['serviceLatitude'] as num).toDouble()
          : null,
      serviceLongitude: json['serviceLongitude'] != null
          ? (json['serviceLongitude'] as num).toDouble()
          : null,

      // 🔄 STATUS
      status: json['status'] ?? "Pending",
      paymentStatus: json['paymentStatus'] ?? "Pending",

      // ⭐ RATINGS
      vendorRated: json['vendorRated'] ?? false,
      vendorRating: json['vendorRating'],

      // 💳 PAYMENT
      paymentMethod: json['paymentMethod'],
    );
  }
}
