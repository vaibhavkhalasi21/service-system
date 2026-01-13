class VendorCreateServiceRequest {
  final String serviceName;
  final String category;
  final double price;

  // 🔴 REQUIRED
  final DateTime serviceDateTime;

  final String? description;

  VendorCreateServiceRequest({
    required this.serviceName,
    required this.category,
    required this.price,
    required this.serviceDateTime, // 🔴 REQUIRED
    this.description,
  });
}
