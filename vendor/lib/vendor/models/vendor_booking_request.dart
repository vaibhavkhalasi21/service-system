class VendorBookingRequest {
  final int id;

  // 👤 WORKER
  final String workerName;
  final String workerEmail;

  // 📍 WORKER LOCATION
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
    required this.workerName,
    required this.workerEmail,
    this.workerLatitude,
    this.workerLongitude,
    required this.serviceName,
    required this.price,
    required this.serviceDateTime,
    this.serviceAddress,
    this.serviceLatitude,
    this.serviceLongitude,
    required this.status,
    required this.paymentStatus,
    required this.vendorRated,
    this.vendorRating,
    this.paymentMethod,
  });

  factory VendorBookingRequest.fromJson(Map<String, dynamic> json) {
    return VendorBookingRequest(
      id: json['id'],

      // 👤 WORKER
      workerName: json['workerName'] ?? "",
      workerEmail: json['workerEmail'] ?? "",

      // 📍 WORKER LOCATION
      workerLatitude: (json['workerLatitude'] as num?)?.toDouble(),
      workerLongitude: (json['workerLongitude'] as num?)?.toDouble(),

      // 🛠 SERVICE
      serviceName: json['serviceName'] ?? "",
      price: json['price'] != null
          ? (json['price'] as num).toInt()
          : 0, // ✅ fallback

      serviceDateTime: json['serviceDateTime'] != null
          ? DateTime.parse(json['serviceDateTime'])
          : DateTime.now(), // ✅ fallback

      // 📍 SERVICE LOCATION
      serviceAddress: json['serviceAddress'],
      serviceLatitude: (json['serviceLatitude'] as num?)?.toDouble(),
      serviceLongitude: (json['serviceLongitude'] as num?)?.toDouble(),

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
