class ServiceRequest {
  final int id;
  final String serviceName;
  final String category;
  final double price;
  final String? imageUrl;

  final DateTime createdAt;        // posted time
  final DateTime serviceDateTime;  // scheduled time

  ServiceRequest({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.price,
    required this.createdAt,
    required this.serviceDateTime,
    this.imageUrl,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'],
      serviceName: json['serviceName'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      serviceDateTime:
      DateTime.parse(json['serviceDateTime']).toLocal(),
    );
  }
}
