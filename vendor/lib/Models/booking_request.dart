class BookingRequest {
  final int id;
  final String workerName;
  final String serviceName;
  final int price;
  final String status;
  final DateTime serviceDateTime;

  BookingRequest({
    required this.id,
    required this.workerName,
    required this.serviceName,
    required this.price,
    required this.status,
    required this.serviceDateTime,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      id: json['id'],
      workerName: json['workerName'],
      serviceName: json['serviceName'],
      price: (json['price'] as num).toInt(),
      status: json['status'],
      serviceDateTime: DateTime.parse(json['serviceDateTime']),
    );
  }
}
