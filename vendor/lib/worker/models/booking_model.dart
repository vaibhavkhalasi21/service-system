class Booking {
  final int id;
  final String jobTitle;      // serviceName
  final String category;
  final String vendorName;
  final String status;        // Pending / Accepted / Completed
  final String paymentStatus; // Paid / Pending
  final int price;
  final DateTime serviceDateTime;

  // ⭐ Rating-related (NEW)
  final bool vendorRated;
  final int? vendorRating;

  Booking({
    required this.id,
    required this.jobTitle,
    required this.category,
    required this.vendorName,
    required this.status,
    required this.paymentStatus,
    required this.price,
    required this.serviceDateTime,
    required this.vendorRated,
    this.vendorRating,
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
      serviceDateTime: DateTime.parse(json['serviceDateTime']),

      // ⭐ NEW
      vendorRated: json['vendorRated'] ?? false,
      vendorRating: json['vendorRating'],
    );
  }
}
