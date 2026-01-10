class WorkerPayment {
  final int id;
  final String serviceName;
  final String vendorName;
  final int price;
  final String status;
  final String paymentStatus;

  // ⭐ WORKER → VENDOR RATING
  final bool workerRated;
  final int? workerRating;

  WorkerPayment({
    required this.id,
    required this.serviceName,
    required this.vendorName,
    required this.price,
    required this.status,
    required this.paymentStatus,
    required this.workerRated,
    required this.workerRating,
  });

  factory WorkerPayment.fromJson(Map<String, dynamic> json) {
    return WorkerPayment(
      id: json['id'],
      serviceName: json['serviceName'],
      vendorName: json['vendorName'],
      price: (json['price'] as num).toInt(),
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      workerRated: json['workerRated'] ?? false,
      workerRating: json['workerRating'],
    );
  }
}
