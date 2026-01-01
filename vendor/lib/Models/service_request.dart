class ServiceRequest {
  final int id; // 🔥 NON-NULLABLE
  final String serviceName;
  final String category;
  final double price;
  final String? description;
  final String? imageUrl;

  ServiceRequest({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.price,
    this.description,
    this.imageUrl,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json["id"], // 🔥 backend always provides this
      serviceName: json["serviceName"],
      category: json["category"],
      price: (json["price"] as num).toDouble(),
      description: json["description"],
      imageUrl: json["imageUrl"],
    );
  }
}
