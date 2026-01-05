class Booking {
  final int id;
  final String jobTitle;
  final String status;
  final int price;
  final DateTime serviceDateTime;

  Booking({
    required this.id,
    required this.jobTitle,
    required this.status,
    required this.price,
    required this.serviceDateTime,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      jobTitle: json['serviceName'] ?? "Job",
      status: (json['status'] != null && json['status'].toString().isNotEmpty)
          ? json['status']
          : "Pending", // <- default Pending
      price: json['price'] ?? 0,
      serviceDateTime: DateTime.parse(json['serviceDateTime']),
    );
  }

}
