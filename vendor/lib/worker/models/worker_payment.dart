class WorkerPayment {
  final int id;
  final String serviceName;
  final String vendorName;
  final int price;

  final String status;          // Job status (Completed)
  final String paymentStatus;   // Paid / Unpaid
  final String escrowStatus;    // HELD / RELEASED

  final String? paymentMethod;
  final bool workerRated;
  final int? workerRating;

  WorkerPayment({
    required this.id,
    required this.serviceName,
    required this.vendorName,
    required this.price,
    required this.status,
    required this.paymentStatus,
    required this.escrowStatus,
    required this.paymentMethod,
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
      paymentStatus: json['paymentStatus'] ?? "Unpaid",
      escrowStatus: json['escrowStatus'] ?? "HELD",

      paymentMethod: json['paymentMethod'],
      workerRated: json['workerRated'] ?? false,
      workerRating: json['workerRating'],
    );
  }
}
