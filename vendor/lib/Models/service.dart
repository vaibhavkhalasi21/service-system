class Service {
  final int id;
  final String title;
  final String category;
  final int price;
  final double rating;
  final String imagePath;

  /// ✅ Already LOCAL time
  final DateTime createdAt;

  Service({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.createdAt,
  });
}
