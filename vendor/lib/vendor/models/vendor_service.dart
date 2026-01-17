class VendorService {
  final int id;
  final String title;

  /// 🔥 MUST BE INT (enum value from backend)
  final int category;

  final int price;
  final double rating;
  final String imagePath;
  final String vendorName;
  final String status;
  final DateTime createdAt;
  final DateTime serviceDateTime;

  // 📍 LOCATION
  final String? address;
  final double latitude;
  final double longitude;

  VendorService({
    required this.id,
    required this.title,
    required this.category, // ✅ FIXED
    required this.price,
    this.rating = 0.0,
    required this.imagePath,
    required this.vendorName,
    required this.status,
    required this.createdAt,
    required this.serviceDateTime,
    this.address,
    required this.latitude,
    required this.longitude,
  });

  factory VendorService.fromJson(Map<String, dynamic> json) {
    return VendorService(
      id: json['id'],
      title: json['serviceName'],
      category: json['category'], // ✅ INT from backend
      price: json['price'],
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 0.0,
      imagePath: json['imageUrl'] ?? "",
      vendorName: json['vendorName'] ?? "",
      status: json['status'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      serviceDateTime: DateTime.parse(json['serviceDateTime']),
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
