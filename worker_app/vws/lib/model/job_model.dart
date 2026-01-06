class MyJob {
  final int id;
  final String title;
  final String category;
  final String description;
  final String date;
  final String location;
  final String imageUrl;
  final double price;
  final double rating;
  final String vendorName;
  final DateTime createdAt;        // ✅ ADDED
  final DateTime serviceDateTime;

  MyJob({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.vendorName,
    required this.createdAt,       // ✅ ADDED
    required this.serviceDateTime,
  });

  factory MyJob.fromJson(Map<String, dynamic> json) {
    const baseUrl = "http://10.172.79.37:5244";

    return MyJob(
      id: json['id'] ?? 0,
      title: json['serviceName'] ?? json['title'] ?? "",
      category: json['category'] ?? "",
      description: json['description'] ?? "",

      // 🗓 display-friendly date
      date: json['date'] ??
          (json['serviceDateTime'] != null
              ? json['serviceDateTime'].toString()
              : ""),

      location: json['location'] ?? "Not specified",

      imageUrl: (json['imageUrl'] != null && json['imageUrl'] != "")
          ? "$baseUrl${json['imageUrl']}"
          : "https://via.placeholder.com/150",

      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,

      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString()) ?? 4.0
          : 4.0,

      vendorName: json['vendorName'] ?? "Unknown Vendor",

      // 🔥 CREATED AT (FIX)
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),

      serviceDateTime: json['serviceDateTime'] != null
          ? DateTime.parse(json['serviceDateTime'])
          : DateTime.now(),
    );
  }
}
