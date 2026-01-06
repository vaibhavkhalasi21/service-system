import 'package:flutter/material.dart';
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

  List<Service> services = [];

  final List<String> categories = [
    "All",
    "Electrician",
    "Plumber",
    "Cleaning",
    "AC Repair",
    "Painter",
  ];

  static const String baseUrl = "http://10.172.79.37:5244";

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  // ===============================
  // FETCH SERVICES FROM API
  // ===============================
  Future<void> fetchServices() async {
    setState(() => isLoading = true);

    try {
      final List<ServiceRequest> apiServices =
      await ServiceApi.getVendorServices();

      // 🔴 DEBUG
      debugPrint("API SERVICES COUNT: ${apiServices.length}");
      debugPrint(apiServices.map((e) => e.serviceName).toList().toString());

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
  // API → UI MAPPER (FIXED)
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

      vendorName: api.vendorName ??"posted by",


      createdAt: api.createdAt,
      serviceDateTime: api.serviceDateTime, // ✅ FIXED
    );
  }


  @override
  Widget build(BuildContext context) {
    List<Service> filteredServices = selectedCategory == "All"
        ? services
        : services.where((s) =>
    s.category.toLowerCase().trim() ==
        selectedCategory.toLowerCase().trim()
    ).toList();



    if (searchQuery.isNotEmpty) {
      filteredServices = filteredServices
          .where(
            (s) => s.title.toLowerCase().contains(
          searchQuery.toLowerCase(),
        ),
      )
          .toList();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hello, Vendor 👋",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 🔍 SEARCH
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

          // 🏷 CATEGORY FILTER
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

          // 📃 SERVICES LIST
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
