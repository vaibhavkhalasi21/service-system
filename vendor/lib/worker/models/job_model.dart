class MyJob {
  final int id;
  final String title;
  final String category; // ✅ STRING for UI
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

    // 🔥 backend sends category as int
    final int rawCategory =
    json['category'] is int ? json['category'] : 0;

    return MyJob(
      id: json['id'] ?? 0,

      // 🔹 Backend: serviceName
      title: json['serviceName'] ?? "",

      // ✅ ENUM → STRING
      category: _categoryFromInt(rawCategory),

      // 🔹 Nearby jobs don’t have description
      description: json['description'] ?? "No description",

      // 🔹 Friendly date (string used elsewhere)
      date: json['serviceDateTime'] != null
          ? json['serviceDateTime'].toString()
          : "",

      // 🔹 Address
      address: json['serviceAddress'] ??
          json['address'] ??
          "Location not specified",

      // 🔹 Location label
      location: json['serviceAddress'] ?? "Location not specified",

      // 🔹 Image
      imageUrl: (json['imageUrl'] != null &&
          json['imageUrl'].toString().isNotEmpty)
          ? "$baseUrl${json['imageUrl']}"
          : "https://via.placeholder.com/150",

      // 🔹 Price
      price: json['price'] != null
          ? (json['price'] as num).toDouble()
          : 0.0,

      // 🔹 Rating (not returned by nearby API)
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 4.0,

      vendorName: json['vendorName'] ?? "Vendor",

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),

      serviceDateTime: json['serviceDateTime'] != null
          ? DateTime.parse(json['serviceDateTime'])
          : DateTime.now(),

      // 📍 COORDINATES
      serviceLatitude: json['serviceLatitude'] != null
          ? (json['serviceLatitude'] as num).toDouble()
          : 0.0,

      serviceLongitude: json['serviceLongitude'] != null
          ? (json['serviceLongitude'] as num).toDouble()
          : 0.0,
    );
  }
}
