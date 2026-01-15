class ServiceModel {
  final int id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final double price;
  final String vendorName;

  // 🔥 TIME
  final DateTime createdAt;
  final DateTime serviceDateTime;

  // 🔥 LOCATION (NEW)
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
    const baseUrl = "http://10.29.111.37:5244";

    return ServiceModel(
      id: json['id'] ?? 0,

      title: json['serviceName'] ?? json['title'] ?? "No Title",
      category: json['category'] ?? "General",
      description: json['description'] ?? "",

      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,

      imageUrl: (json['imageUrl'] != null && json['imageUrl'].toString().isNotEmpty)
          ? "$baseUrl${json['imageUrl']}"
          : "https://via.placeholder.com/150",

      vendorName: json['vendorName'] ?? "Vendor",

      // 🔥 TIME (SAFE PARSE)
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : DateTime.now(),

      serviceDateTime: json['serviceDateTime'] != null
          ? DateTime.parse(json['serviceDateTime']).toLocal()
          : DateTime.now(),

      // 🔥 LOCATION (VERY IMPORTANT)
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
}
