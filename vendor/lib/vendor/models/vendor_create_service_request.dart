class VendorCreateServiceRequest {
  final String serviceName;

  /// 🔥 MUST BE INT (matches backend enum)
  /// Cleaning = 1
  /// Plumber = 2
  /// Electrician = 3
  /// ACRepair = 4
  /// Painter = 5
  final int category;

  final double price;

  // 🔴 REQUIRED
  final DateTime serviceDateTime;

  final String? description;

  // 🔥 LOCATION (REQUIRED)
  final double latitude;
  final double longitude;
  final String address;

  VendorCreateServiceRequest({
    required this.serviceName,
    required this.category, // ✅ int
    required this.price,
    required this.serviceDateTime,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  /// ✅ Convert to JSON (USED IN API CALL)
  Map<String, dynamic> toJson() {
    return {
      "serviceName": serviceName,
      "category": category, // ✅ INT SENT TO BACKEND
      "price": price,
      "serviceDateTime": serviceDateTime.toIso8601String(),
      "description": description,

      // 🔥 LOCATION
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
    };
  }
}
