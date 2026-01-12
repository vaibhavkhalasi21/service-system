class VendorServiceRequest {
  final int id;
  final String serviceName;
  final String category;
  final double price;
  final String? imageUrl;

  final String? vendorName;

  // 🔥 NEW: service lifecycle status
  final String status;

  final DateTime createdAt;        // posted time
  final DateTime serviceDateTime;  // scheduled time

  VendorServiceRequest({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.price,
    required this.vendorName,
    required this.status,          // 🔥 ADD
    required this.createdAt,
    required this.serviceDateTime,
    this.imageUrl,
  });

  factory VendorServiceRequest.fromJson(Map<String, dynamic> json) {
    return VendorServiceRequest(
      id: json['id'],
      serviceName: json['serviceName'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],

      vendorName: json['vendorName'] ?? "You",

      // 🔥 MAP STATUS FROM BACKEND
      status: json['status'] ?? "Active",

      // KEEP YOUR TIME LOGIC (CORRECT)
      createdAt: DateTime.parse(json['createdAt'] + 'Z').toLocal(),
      serviceDateTime: DateTime.parse(json['serviceDateTime']).toUtc(),
    );
  }
}
