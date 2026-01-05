import 'package:flutter/material.dart';
import '../models/service.dart';
import '../models/service_request.dart';
import '../services/service_api.dart';
import '../widgets/service_card.dart';

class MyServicesPage extends StatefulWidget {
  const MyServicesPage({super.key});

  @override
  State<MyServicesPage> createState() => _MyServicesPageState();
}

class _MyServicesPageState extends State<MyServicesPage> {
  bool isLoading = true;
  List<Service> myServices = [];

  static const String baseUrl = "http://10.141.25.37:5244";

  @override
  void initState() {
    super.initState();
    fetchMyServices();
  }

  Future<void> fetchMyServices() async {
    setState(() => isLoading = true);

    final List<ServiceRequest> apiServices =
    await ServiceApi.getVendorServices();

    myServices = apiServices
        .map(
          (e) => Service(
        id: e.id,
        title: e.serviceName,
        category: e.category,
        price: e.price.toInt(),
        rating: 4.5,
        imagePath: "$baseUrl${e.imageUrl}",
        vendorName: e.vendorName,
        createdAt: e.createdAt,
        serviceDateTime: e.serviceDateTime,
      ),
    )
        .toList();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Services")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: myServices.length,
          itemBuilder: (context, index) {
            return ServiceCard(
              service: myServices[index],
              showActions: true,
              onUpdated: fetchMyServices,
            );
          },
        ),
      ),
    );
  }
}
