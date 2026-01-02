class ServiceRequest {
  final int id;
  final String serviceName;
  final String category;
  final double price;
  final String? imageUrl;
  final DateTime createdAt;

  ServiceRequest({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.price,
    required this.createdAt,
    this.imageUrl,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    print("🟡 RAW createdAt FROM API: ${json['createdAt']}");

    final parsed = DateTime.parse(json['createdAt']);
    print("🟠 PARSED DateTime     : $parsed");
    print("🟠 PARSED TZ OFFSET   : ${parsed.timeZoneOffset}");

    final local = parsed.toLocal();
    print("🟢 LOCAL DateTime      : $local");
    print("🟢 LOCAL TZ OFFSET    : ${local.timeZoneOffset}");

    return ServiceRequest(
      id: json['id'],
      serviceName: json['serviceName'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      createdAt: local,
    );
  }

}
