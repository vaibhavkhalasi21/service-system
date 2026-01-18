class VendorCreateServiceRequest {
  final String serviceName;

  /// 🔥 ENUM INT (backend)
  /// Cleaning = 1
  /// Plumber = 2
  /// Electrician = 3
  /// ACRepair = 4
  /// Painter = 5
  final int category;

  final double price;

  /// 🔴 REQUIRED
  final DateTime serviceDateTime;

  final String? description;

  /// 📍 LOCATION (REQUIRED)
  final double latitude;
  final double longitude;
  final String address;

  VendorCreateServiceRequest({
    required this.serviceName,
    required this.category,
    required this.price,
    required this.serviceDateTime,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  /// JSON (used only if needed, NOT for image)
  Map<String, dynamic> toJson() {
    return {
      "serviceName": serviceName,
      "category": category,
      "price": price,
      "serviceDateTime": serviceDateTime.toIso8601String(),
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
    };
  }
}
