class VendorPayment {
  final int id;
  final String serviceName;
  final String workerName;
  final int price;
  final String status;
  final String paymentStatus;

  // ⭐ NEW
  final String? paymentMethod;

  VendorPayment({
    required this.id,
    required this.serviceName,
    required this.workerName,
    required this.price,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
  });

  factory VendorPayment.fromJson(Map<String, dynamic> json) {
    return VendorPayment(
      id: json['id'],
      serviceName: json['serviceName'],
      workerName: json['workerName'],
      price: (json['price'] as num).toInt(),
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      paymentMethod: json['paymentMethod'], // ⭐ IMPORTANT
    );
  }
}
