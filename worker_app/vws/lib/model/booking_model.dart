class Booking {
  final int id;
  final String jobTitle;      // serviceName
  final String category;
  final String vendorName;
  final String status;        // Job status
  final String paymentStatus; // Paid / Pending
  final int price;
  final DateTime serviceDateTime;

  Booking({
    required this.id,
    required this.jobTitle,
    required this.category,
    required this.vendorName,
    required this.status,
    required this.paymentStatus,
    required this.price,
    required this.serviceDateTime,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      jobTitle: json['serviceName'],
      category: json['category'],
      vendorName: json['vendorName'],
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      price: (json['price'] as num).toInt(),
      serviceDateTime:
      DateTime.parse(json['serviceDateTime']),
    );
  }
}
