class WorkerPayment {
  final int id;
  final String serviceName;
  final String vendorName;
  final int price;
  final String status;         // Completed
  final String paymentStatus;  // Pending / Paid

  WorkerPayment({
    required this.id,
    required this.serviceName,
    required this.vendorName,
    required this.price,
    required this.status,
    required this.paymentStatus,
  });

  factory WorkerPayment.fromJson(Map<String, dynamic> json) {
    return WorkerPayment(
      id: json['id'],
      serviceName: json['serviceName'],
      vendorName: json['vendorName'],
      price: (json['price'] as num).toInt(),
      status: json['status'],
      paymentStatus: json['paymentStatus'],
    );
  }
}
