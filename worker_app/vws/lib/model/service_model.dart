class ServiceModel {
  final int id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final double price;
  final String vendorName;
  final DateTime createdAt;
  final DateTime serviceDateTime;

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
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    const baseUrl = "http://10.141.25.37:5244";

    return ServiceModel(
      id: json['id'] ?? 0,
      title: json['serviceName'] ?? "No Title",
      category: json['category'] ?? "General",
      description: json['description'] ?? "",
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0
          : 0,
      imageUrl: (json['imageUrl'] != null && json['imageUrl'] != "")
          ? "$baseUrl${json['imageUrl']}"
          : "https://via.placeholder.com/150",

      // 🔥 missing fields fixed
      vendorName: json['VendorName'] ?? json['vendorName'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      serviceDateTime: json['serviceDateTime'] != null
          ? DateTime.parse(json['serviceDateTime'])
          : DateTime.now(),
    );
  }
}
