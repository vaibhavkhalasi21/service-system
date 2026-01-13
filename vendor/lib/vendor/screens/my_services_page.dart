import 'package:flutter/material.dart';

import '../models/vendor_service.dart';
import '../models/vendor_service_request.dart';
import '../services/service_api.dart';
import '../widgets/service_card.dart';


// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

class MyServicesPage extends StatefulWidget {
  const MyServicesPage({super.key});

  @override
  State<MyServicesPage> createState() => _MyServicesPageState();
}

class _MyServicesPageState extends State<MyServicesPage> {
  bool isLoading = true;
  List<VendorService> myServices = [];

  static const String baseUrl = "http://10.29.111.37:5244";

  @override
  void initState() {
    super.initState();
    fetchMyServices();
  }

  // ===============================
  // FETCH MY SERVICES
  // ===============================
  Future<void> fetchMyServices() async {
    setState(() => isLoading = true);

    final List<VendorServiceRequest> apiServices =
    (await ServiceApi.getVendorServices()).cast<VendorServiceRequest>();

    myServices = apiServices
        .map(
          (e) => VendorService(
        id: e.id,
        title: e.serviceName,
        category: e.category,
        price: e.price.toInt(),
        rating: 4.5,
        imagePath: "$baseUrl${e.imageUrl}",
        vendorName: e.vendorName ?? "You",
        status: e.status,
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
      backgroundColor: kBg,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Services",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // ================= BODY =================
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: kPurple),
      )
          : myServices.isEmpty
          ? _emptyState()
          : RefreshIndicator(
        color: kPurple,
        onRefresh: fetchMyServices,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
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

  // ===============================
  // EMPTY STATE
  // ===============================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPurple.withOpacity(0.15),
            ),
            child: const Icon(
              Icons.work_outline,
              size: 48,
              color: kPurple,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "No services posted yet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Post your first service to start\ngetting applications from workers.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kGrey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
