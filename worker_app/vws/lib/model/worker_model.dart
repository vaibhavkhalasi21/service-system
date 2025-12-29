// model/worker_model.dart
class Worker {
  final String name;
  final String email;
  final String phone;
  final String profession;
  final String experience;
  final String location;

  Worker({
    required this.name,
    required this.email,
    required this.phone,
    required this.profession,
    required this.experience,
    required this.location,
  });

  /// JSON → Model
  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profession: json['profession'] ?? '',
      experience: json['experience'] ?? '',
      location: json['location'] ?? '',
    );
  }

  /// Model → JSON (Signup ke time kaam aayega)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "profession": profession,
      "experience": experience,
      "location": location,
    };
  }
}
