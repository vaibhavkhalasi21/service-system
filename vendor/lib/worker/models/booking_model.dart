class Booking {
  final int id;
  final String jobTitle;      // serviceName
  final String category;
  final String vendorName;
  final String status;        // Pending / Accepted / Completed
  final String paymentStatus; // Paid / Pending
  final int price;
  final DateTime serviceDateTime;

  final double serviceLatitude;
  final double serviceLongitude;
  final String serviceAddress;


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
    required this.serviceAddress,
    required this.serviceLatitude,
    required this.serviceLongitude
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

      serviceLatitude: (json['serviceLatitude'] as num).toDouble(),
      serviceLongitude: (json['serviceLongitude'] as num).toDouble(),
      serviceAddress: json['serviceAddress'],


      // ⭐ NEW
      vendorRated: json['vendorRated'] ?? false,
      vendorRating: json['vendorRating'],
    );
  }
}
