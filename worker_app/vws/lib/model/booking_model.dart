class Booking {
  final int id;
  final String jobTitle;      // serviceName
  final String category;      // category
  final String vendorName;    // vendorName
  final String status;
  final int price;
  final DateTime serviceDateTime;

  Booking({
    required this.id,
    required this.jobTitle,
    required this.category,
    required this.vendorName,
    required this.status,
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
      price: (json['price'] as num).toInt(), // already fixed
      serviceDateTime: DateTime.parse(json['serviceDateTime']),
    );
  }
}