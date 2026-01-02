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
  });

  factory MyJob.fromJson(Map<String, dynamic> json) {
    const baseUrl = "http://10.141.25.37:5244";

    return MyJob(
      id: json['id'] ?? 0,
      title: json['serviceName'] ?? json['title'] ?? "",
      category: json['category'] ?? "",
      description: json['description'] ?? "",
      date: json['date'] ?? "",
      location: json['location'] ?? "",
      imageUrl: (json['imageUrl'] != null && json['imageUrl'] != "")
          ? "$baseUrl${json['imageUrl']}"
          : "https://via.placeholder.com/150",
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString()) ?? 4.0
          : 4.0,
    );
  }
}
