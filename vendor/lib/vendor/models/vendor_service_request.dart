class VendorServiceRequest {
  final int id;
  final String serviceName;

  // 🔥 CATEGORY ENUM (INT ONLY)
  final int category;

  final double price;

  // 🔹 OPTIONAL DISPLAY DATA
  final String? imageUrl;
  final String vendorName;

  // 🔥 SERVICE STATUS
  final String status;

  // 🔥 TIMESTAMPS
  final DateTime createdAt;
  final DateTime serviceDateTime;

  // 🔥 LOCATION
  final String? address;
  final double? latitude;
  final double? longitude;

  // 🔥 OPTIONAL RATING
  final double? rating;

  VendorServiceRequest({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.price,
    required this.vendorName,
    required this.status,
    required this.createdAt,
    required this.serviceDateTime,
    this.imageUrl,
    this.address,
    this.latitude,
    this.longitude,
    this.rating,
  });

  factory VendorServiceRequest.fromJson(Map<String, dynamic> json) {
    return VendorServiceRequest(
      id: json['id'] as int,

      serviceName: json['serviceName'] ?? "",

      // ✅ FINAL FIX
      category: _parseCategory(json['category']),

      price: (json['price'] as num).toDouble(),

      imageUrl: json['imageUrl'],
      vendorName: json['vendorName'] ?? "You",

      status: json['status'] ?? "Active",

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : DateTime.now(),

      serviceDateTime: json['serviceDateTime'] != null
          ? DateTime.parse(json['serviceDateTime']).toLocal()
          : DateTime.now(),

      address: json['address'],

      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,

      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,

      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
    );
  }

  // =====================================================
  // 🔥 BACKEND ENUM STRING / INT → INT (CORE FIX)
  // =====================================================
  static int _parseCategory(dynamic value) {
    if (value == null) return 0;

    // ✅ backend sent INT
    if (value is int) return value;

    // ✅ backend sent ENUM STRING
    final v = value.toString().toLowerCase();

    switch (v) {
      case "cleaning":
        return 1;
      case "plumber":
        return 2;
      case "electrician":
        return 3;
      case "acrepair":
      case "ac repair":
        return 4;
      case "painter":
        return 5;
      default:
        return 0; // Unknown (Old Data)
    }
  }
}
