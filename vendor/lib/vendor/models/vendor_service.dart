class VendorService {
  final int id;
  final String title;
  final String category;
  final int price;
  final double rating; // ✅ optional now
  final String imagePath;
  final String vendorName;
  final String status;
  final DateTime createdAt;
  final DateTime serviceDateTime;

  VendorService({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    this.rating = 0.0, // ✅ DEFAULT VALUE (fixes error)
    required this.imagePath,
    required this.vendorName,
    required this.status,
    required this.createdAt,
    required this.serviceDateTime,
  });
}
