class ServiceModel {
  final int id;
  final String title;

  /// 🔥 CATEGORY ENUM (INT ONLY)
  final int category;

  final String description;
  final String imageUrl;
  final double price;
  final String vendorName;

  // ⏰ TIME
  final DateTime createdAt;
  final DateTime serviceDateTime;

  // 📍 LOCATION
  final String address;
  final double latitude;
  final double longitude;

  ServiceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.vendorName,
    required this.createdAt,
    required this.serviceDateTime,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    const baseUrl = "http://172.20.253.37:5244";

    return ServiceModel(
      id: json['id'] ?? 0,

      title: json['serviceName'] ??
          json['title'] ??
          "No Title",

      // 🔥🔥🔥 MAIN FIX (ENUM SAFE)
      category: _parseCategory(json['category']),

      description: json['description'] ?? "",

      price: json['price'] != null
          ? (json['price'] as num).toDouble()
          : 0.0,

      imageUrl:
      (json['imageUrl'] != null &&
          json['imageUrl'].toString().isNotEmpty)
          ? "$baseUrl${json['imageUrl']}"
          : "https://via.placeholder.com/300",

      vendorName: json['vendorName'] ?? "Service Provider",

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : DateTime.now(),

      serviceDateTime: json['serviceDateTime'] != null
          ? DateTime.parse(json['serviceDateTime']).toLocal()
          : DateTime.now(),

      address: json['address'] ??
          json['serviceAddress'] ??
          "Location not specified",

      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString()) ?? 0.0
          : 0.0,

      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString()) ?? 0.0
          : 0.0,
    );
  }

  // =====================================================
  // 🔥 BACKEND ENUM STRING / INT → INT (CORE FIX)
  // =====================================================
  static int _parseCategory(dynamic value) {
    if (value == null) return 0;

    // ✅ backend already int
    if (value is int) return value;

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
