class ServiceModel {
  final int id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final double price;

  ServiceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    const baseUrl = "http://10.141.25.37:5244";

    return ServiceModel(
      id: json['id'] ?? 0,
      title: json['serviceName'] ?? "No Title",
      category: json['category'] ?? "General",
      description: json['description'] ?? "",
      price: (json['price'] != null)
          ? double.tryParse(json['price'].toString()) ?? 0
          : 0,
      imageUrl: (json['imageUrl'] != null && json['imageUrl'] != "")
          ? "$baseUrl${json['imageUrl']}"
          : "https://via.placeholder.com/150",
    );
  }
}
