class Worker {
  int id;
  String name;
  String email;
  String phone;
  String skill;
  String address;

  Worker({
    required this.id,
    required this.name,
    required this.email,
    this.phone = "",
    this.skill = "",
    this.address = "",
  });

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
    id: json['id'] ?? json['workerId'] ?? 0,
    name: json['name'] ?? json['workerName'] ?? "",
    email: json['email'] ?? "",
    phone: json['phone'] ?? "",
    skill: json['skill'] ?? "",
    address: json['address'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'skill': skill,
    'address': address,
  };
}
