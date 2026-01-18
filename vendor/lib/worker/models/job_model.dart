class MyJob {
  final int id;
  final String title;

  /// ✅ CATEGORY AS STRING (UI READY)
  final String category;

  final String description;
  final String date;
  final String location;
  final String imageUrl;
  final double price;
  final double rating;
  final String vendorName;
  final DateTime createdAt;
  final DateTime serviceDateTime;
  final String address;

  // 📍 LOCATION (MAP / DISTANCE)
  final double serviceLatitude;
  final double serviceLongitude;

  MyJob({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.vendorName,
    required this.createdAt,
    required this.address,
    required this.serviceDateTime,
    required this.serviceLatitude,
    required this.serviceLongitude,
  });

  // =============================
  // 🔥 CATEGORY ENUM → STRING
  // =============================
  static String _categoryFromInt(int value) {
    switch (value) {
      case 1:
        return "Cleaning";
      case 2:
        return "Plumber";
      case 3:
        return "Electrician";
      case 4:
        return "AC Repair";
      case 5:
        return "Painter";
      default:
        return "Unknown";
    }
  }

  factory MyJob.fromJson(Map<String, dynamic> json) {
    const baseUrl = "http://172.20.253.37:5244";

    // ✅ SAFE CATEGORY PARSE
    final int rawCategory = json['category'] is int
        ? json['category']
        : int.tryParse(json['category']?.toString() ?? '') ?? 0;

    // ✅ ADDRESS RESOLUTION
    final String resolvedAddress =
        json['address'] ??
            json['serviceAddress'] ??
            "Location not specified";

    // ✅ DATE RESOLUTION
    final DateTime resolvedServiceDate =
    json['serviceDateTime'] != null
        ? DateTime.parse(json['serviceDateTime']).toLocal()
        : DateTime.now();

    return MyJob(
      id: json['id'] ?? 0,
      title: json['serviceName'] ?? "",

      /// 🔥 FINAL CATEGORY (STRING)
      category: _categoryFromInt(rawCategory),

      description: json['description'] ?? "No description",

      /// 🔥 REQUIRED BY UI
      date: resolvedServiceDate.toIso8601String(),
      location: resolvedAddress,

      address: resolvedAddress,

      imageUrl: (json['imageUrl'] != null &&
          json['imageUrl'].toString().isNotEmpty)
          ? "$baseUrl${json['imageUrl']}"
          : "https://via.placeholder.com/150",

      price: json['price'] != null
          ? (json['price'] as num).toDouble()
          : 0.0,

      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 4.0,

      vendorName: json['vendorName'] ?? "Vendor",

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : DateTime.now(),

      serviceDateTime: resolvedServiceDate,

      // 🔥🔥🔥 MAIN FIX (BACKEND KEYS)
      serviceLatitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : 0.0,

      serviceLongitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : 0.0,
    );
  }
}
