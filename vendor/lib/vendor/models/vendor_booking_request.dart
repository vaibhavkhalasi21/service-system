class VendorBookingRequest {
  final int id;
  final String workerName;
  final String serviceName;
  final int price;
  final String status;
  final DateTime serviceDateTime;
  final String workerEmail;
  final String paymentStatus;

  final bool vendorRated;
  final int? vendorRating;

  // ⭐ NEW
  final String? paymentMethod;

  VendorBookingRequest({
    required this.id,
    required this.workerName,
    required this.serviceName,
    required this.price,
    required this.status,
    required this.serviceDateTime,
    required this.workerEmail,
    required this.paymentStatus,
    required this.vendorRated,
    required this.vendorRating,
    required this.paymentMethod,
  });

  factory VendorBookingRequest.fromJson(Map<String, dynamic> json) {
    return VendorBookingRequest(
      id: json['id'],
      workerName: json['workerName'],
      serviceName: json['serviceName'],
      price: (json['price'] as num).toInt(),
      status: json['status'],
      serviceDateTime: DateTime.parse(json['serviceDateTime']),
      workerEmail: json['workerEmail'],
      paymentStatus: json['paymentStatus'],
      vendorRated: json['vendorRated'] ?? false,
      vendorRating: json['vendorRating'],
      paymentMethod: json['paymentMethod'], // ⭐ IMPORTANT
    );
  }
}
