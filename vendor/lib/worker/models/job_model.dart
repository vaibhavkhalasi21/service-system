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
  final DateTime createdAt;
  final DateTime serviceDateTime;
  final String address;


  // 🔥 ADDED for location-based features
  final double serviceLatitude;
  final double serviceLongitude;

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
    required this.createdAt,
    required this.address,
    required this.serviceDateTime,
    required this.serviceLatitude,
    required this.serviceLongitude,
  });

  factory MyJob.fromJson(Map<String, dynamic> json) {
    const baseUrl = "http://10.29.111.37:5244";

    return MyJob(
      id: json['id'] ?? 0,

      // 🔹 Backend: serviceName
      title: json['serviceName'] ?? json['title'] ?? "",

      category: json['category'] ?? "",

      // 🔹 Nearby jobs don’t have description
      description: json['description'] ?? "No description",

      // 🔹 Friendly date
      date: json['serviceDateTime'] != null
          ? json['serviceDateTime'].toString()
          : "",

      address: json['address'] ??
          json['serviceAddress'] ??
          "Location not specified",

      // 🔥 MAP serviceAddress → location
      location: json['serviceAddress'] ?? "Location not specified",

      // 🔹 Nearby jobs don’t return image
      imageUrl: (json['imageUrl'] != null && json['imageUrl'] != "")
          ? "$baseUrl${json['imageUrl']}"
          : "https://via.placeholder.com/150",

      price: json['price'] != null
          ? (json['price'] as num).toDouble()
          : 0.0,

      // 🔹 Nearby jobs don’t return rating
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 4.0,

      vendorName: json['vendorName'] ?? "Vendor",

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),

      serviceDateTime: json['serviceDateTime'] != null
          ? DateTime.parse(json['serviceDateTime'])
          : DateTime.now(),

      // 🔥 LOCATION COORDINATES
      serviceLatitude: json['serviceLatitude'] != null
          ? (json['serviceLatitude'] as num).toDouble()
          : 0.0,

      serviceLongitude: json['serviceLongitude'] != null
          ? (json['serviceLongitude'] as num).toDouble()
          : 0.0,
    );
  }
}
