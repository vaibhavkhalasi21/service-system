class Booking {
  final int id;
  final String jobTitle;
  final String category; // ✅ STRING
  final String vendorName;
  final String status;
  final String paymentStatus;
  final int price;
  final DateTime serviceDateTime;

  final double serviceLatitude;
  final double serviceLongitude;
  final String serviceAddress;

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
    required this.serviceLatitude,
    required this.serviceLongitude,
    required this.serviceAddress,
    required this.vendorRated,
    this.vendorRating,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      jobTitle: json['serviceName'],
      category: json['category'], // ✅ STRING
      vendorName: json['vendorName'],
      status: json['status'],
      paymentStatus: json['paymentStatus'],
      price: (json['price'] as num).toInt(),
      serviceDateTime: DateTime.parse(json['serviceDateTime']).toLocal(),
      serviceLatitude: (json['serviceLatitude'] as num).toDouble(),
      serviceLongitude: (json['serviceLongitude'] as num).toDouble(),
      serviceAddress: json['serviceAddress'],
      vendorRated: json['vendorRated'] ?? false,
      vendorRating: json['vendorRating'],
    );
  }
}
