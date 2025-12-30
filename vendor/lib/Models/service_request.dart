class ServiceRequest {
  final String serviceName;
  final double price;

  ServiceRequest({
    required this.serviceName,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "serviceName": serviceName,
      "price": price,
    };
  }

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      serviceName: json['serviceName'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
