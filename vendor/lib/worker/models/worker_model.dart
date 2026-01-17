class Worker {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;

  /// 🔥 CATEGORY AS INT (ENUM VALUE)
  final int category;

  /// 📍 LOCATION
  final double latitude;
  final double longitude;

  Worker({
    required this.id,
    required this.name,
    required this.email,
    required this.category,
    this.phone = "",
    this.address = "",
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  // ===============================
  // 🔄 COPY WITH (FIXED)
  // ===============================
  Worker copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    int? category,
    double? latitude,
    double? longitude,
  }) {
    return Worker(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  // ===============================
  // 📦 FROM JSON (SAFE)
  // ===============================
  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'] ?? json['workerId'] ?? 0,
      name: json['name'] ?? json['workerName'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      address: json['address'] ?? "",

      /// 🔥 CATEGORY MUST BE INT
      category: json['category'] is int
          ? json['category']
          : int.tryParse(json['category'].toString()) ?? 0,

      /// 📍 LOCATION SAFE PARSE
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString()) ?? 0.0
          : 0.0,

      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString()) ?? 0.0
          : 0.0,
    );
  }

  // ===============================
  // 📤 TO JSON
  // ===============================
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "category": category,
    "latitude": latitude,
    "longitude": longitude,
  };
}
