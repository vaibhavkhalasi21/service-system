class Worker {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String skill;
  final String address;

  // 📍 LOCATION (NEW)
  final double latitude;
  final double longitude;

  Worker({
    required this.id,
    required this.name,
    required this.email,
    this.phone = "",
    this.skill = "",
    this.address = "",
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'] ?? json['workerId'] ?? 0,
      name: json['name'] ?? json['workerName'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      skill: json['skill'] ?? "",

      // 🏠 ADDRESS
      address: json['address'] ?? "",

      // 📍 LOCATION SAFE PARSE
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString()) ?? 0.0
          : 0.0,

      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString()) ?? 0.0
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "skill": skill,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
  };
}
