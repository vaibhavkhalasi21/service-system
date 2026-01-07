import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/service.dart';
import '../models/service_request.dart';
import '../services/service_api.dart';
import '../widgets/service_card.dart';
import '../widgets/category_chip.dart';

class VendorHomeTab extends StatefulWidget {
  const VendorHomeTab({super.key});

  @override
  State<VendorHomeTab> createState() => _VendorHomeTabState();
}

class _VendorHomeTabState extends State<VendorHomeTab> {
  String selectedCategory = "All";
  String searchQuery = "";
  bool isLoading = true;

  // 🔥 NEW: Vendor name
  String vendorName = "Vendor";

  List<Service> services = [];

  final List<String> categories = [
    "All",
    "Electrician",
    "Plumber",
    "Cleaning",
    "AC Repair",
    "Painter",
  ];

  static const String baseUrl = "http://10.29.111.37:5244";

  @override
  void initState() {
    super.initState();
    loadVendorName();
    fetchServices();
  }

  // ===============================
  // LOAD VENDOR NAME FROM SESSION
  // ===============================
  Future<void> loadVendorName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vendorName = prefs.getString("vendor_name") ?? "Vendor";
    });
  }

  // ===============================
  // FETCH SERVICES (PUBLIC)
  // ===============================
  Future<void> fetchServices() async {
    setState(() => isLoading = true);

    try {
      final List<ServiceRequest> apiServices =
      await ServiceApi.getPublicServices();

      final List<Service> mappedServices =
      apiServices.map(_mapApiToUi).toList();

      setState(() {
        services = mappedServices;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("FETCH SERVICES ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  // ===============================
  // API → UI MAPPER
  // ===============================
  Service _mapApiToUi(ServiceRequest api) {
    return Service(
      id: api.id,
      title: api.serviceName,
      category: api.category,
      price: api.price.toInt(),
      rating: 4.5,
      imagePath: api.imageUrl != null
          ? "$baseUrl${api.imageUrl}"
          : "assets/images/cleaning.png",
      vendorName: api.vendorName ?? "Vendor",
      createdAt: api.createdAt,
      serviceDateTime: api.serviceDateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Service> filteredServices = selectedCategory == "All"
        ? services
        : services
        .where(
          (s) =>
      s.category.toLowerCase().trim() ==
          selectedCategory.toLowerCase().trim(),
    )
        .toList();

    if (searchQuery.isNotEmpty) {
      filteredServices = filteredServices
          .where(
            (s) =>
            s.title.toLowerCase().contains(searchQuery.toLowerCase()),
      )
          .toList();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HELLO TEXT =================
          Text(
            "Hello, $vendorName 👋",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // ================= SEARCH =================
          TextField(
            onChanged: (v) => setState(() => searchQuery = v),
            decoration: InputDecoration(
              hintText: "Search services...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              filled: true,
            ),
          ),

          const SizedBox(height: 16),

          // ================= CATEGORY FILTER =================
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) {
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: CategoryChip(
                    title: cat,
                    selected: selectedCategory == cat,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // ================= SERVICES LIST =================
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredServices.isEmpty
                ? const Center(child: Text("No services found"))
                : ListView.builder(
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                return ServiceCard(
                  service: filteredServices[index],
                  onUpdated: fetchServices,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
