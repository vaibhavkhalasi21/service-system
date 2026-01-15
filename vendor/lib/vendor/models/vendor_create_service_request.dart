class VendorCreateServiceRequest {
  final String serviceName;
  final String category;
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
    required this.category,
    required this.price,
    required this.serviceDateTime,
    this.description,

    // 🔥 LOCATION
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  /// ✅ Convert to JSON (USED IN API CALL)
  Map<String, dynamic> toJson() {
    return {
      "serviceName": serviceName,
      "category": category,
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
