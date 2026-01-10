class Service {
  final int id;
  final String title;
  final String category;
  final int price;
  final double rating;
  final String imagePath;
  final String vendorName;

  final String status; // 🔥 ADD THIS

  final DateTime createdAt;
  final DateTime serviceDateTime;

  Service({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.vendorName,
    required this.status, // 🔥
    required this.createdAt,
    required this.serviceDateTime,
  });
}
