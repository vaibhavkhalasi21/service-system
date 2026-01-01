class CreateServiceRequest {
  final String serviceName;
  final String category;
  final double price;
  final String? description;

  CreateServiceRequest({
    required this.serviceName,
    required this.category,
    required this.price,
    this.description,
  });
}