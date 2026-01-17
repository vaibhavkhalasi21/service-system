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
  final DateTime createdAt;        // posted time
  final DateTime serviceDateTime;  // scheduled time

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

      // ✅ MUST BE INT (ENUM)
      category: json['category'] is int
          ? json['category']
          : int.tryParse(json['category'].toString()) ?? 0,


      price: (json['price'] as num).toDouble(),

      imageUrl: json['imageUrl'],
      vendorName: json['vendorName'] ?? "You",

      status: json['status'] ?? "Active",

      // ✅ SAFE TIME PARSING
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : DateTime.now(),

      serviceDateTime: json['serviceDateTime'] != null
          ? DateTime.parse(json['serviceDateTime']).toLocal()
          : DateTime.now(),

      // ✅ LOCATION SAFE PARSE
      address: json['address'],

      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,

      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,

      // ✅ OPTIONAL RATING
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
    );
  }
}
