class ServiceRequest {
  final int? id;
  final String serviceName;
  final String category;
  final double price;
  final String? description;

  // ✅ ADD THIS
  final String? imageUrl;

  ServiceRequest({
    this.id,
    required this.serviceName,
    required this.category,
    required this.price,
    this.description,
    this.imageUrl,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'],
      serviceName: json['serviceName'],
      category: json['category'] ?? "General",
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'], // ✅ NOW EXISTS
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "serviceName": serviceName,
      "category": category,
      "price": price,
      if (description != null) "description": description,
      // ❌ imageUrl is NOT sent from Flutter
      // Backend generates it after upload
    };
  }
}
