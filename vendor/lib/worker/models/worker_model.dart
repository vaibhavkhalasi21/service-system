class Worker {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;

  /// ✅ CATEGORY AS STRING (UI READY)
  final String category;

  /// 📍 LOCATION
  final double latitude;
  final double longitude;

  Worker({
    required this.id,
    required this.name,
    required this.email,
    required this.category, // ✅ STRING
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
    String? category, // ✅ STRING
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
  // 📦 FROM JSON (ENUM → STRING)
  // ===============================
  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'] ?? json['workerId'] ?? 0,
      name: json['name'] ?? json['workerName'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      address: json['address'] ?? "",

      /// 🔥 ENUM → STRING (FINAL FIX)
      category: _categoryFromJson(json['category']),

      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString()) ?? 0.0
          : 0.0,

      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString()) ?? 0.0
          : 0.0,
    );
  }

  // ===============================
  // 🔥 ENUM / STRING → STRING
  // ===============================
  static String _categoryFromJson(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return value;
    }

    if (value is int) {
      switch (value) {
        case 1:
          return "Cleaning";
        case 2:
          return "Plumber";
        case 3:
          return "Electrician";
        case 4:
          return "AC Repair";
        case 5:
          return "Painter";
      }
    }

    return "Unknown";
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
    "category": category, // ✅ STRING
    "latitude": latitude,
    "longitude": longitude,
  };
}
