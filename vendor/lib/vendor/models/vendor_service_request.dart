class VendorServiceRequest {
  final int id;
  final String serviceName;
  final String category;
  final double price;

  final String? imageUrl;
  final String? vendorName;

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
      id: json['id'],
      serviceName: json['serviceName'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),

      imageUrl: json['imageUrl'],
      vendorName: json['vendorName'] ?? "You",

      // 🔥 STATUS
      status: json['status'] ?? "Active",

      // ⏰ TIME (KEEP YOUR LOGIC)
      createdAt: DateTime.parse(json['createdAt'] + 'Z').toLocal(),
      serviceDateTime: DateTime.parse(json['serviceDateTime']).toUtc(),

      // 🔥 LOCATION (SAFE)
      address: json['address'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,

      // 🔥 RATING
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
    );
  }
}
