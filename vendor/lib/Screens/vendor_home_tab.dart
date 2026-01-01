import 'package:flutter/material.dart';
import '../models/service.dart';
import '../Models/service_request.dart';
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
    "Painter"
  ];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      final apiServices = await ServiceApi.getServices();

      setState(() {
        services = apiServices.map(_mapApiToUi).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // =========================
  // API → UI mapper
  // =========================
  Service _mapApiToUi(ServiceRequest apiService) {
    return Service(
      title: apiService.serviceName,
      category: apiService.category,
      price: apiService.price.toInt(),
      rating: 4.5,
      imagePath: apiService.imageUrl != null
          ? "http://10.141.25.37:5244${apiService.imageUrl}"
          : "assets/images/cleaning.png",
    );
  }

  @override
  Widget build(BuildContext context) {
    // CATEGORY FILTER
    List<Service> filteredServices = selectedCategory == "All"
        ? services
        : services.where((s) => s.category == selectedCategory).toList();

    // SEARCH FILTER
    if (searchQuery.isNotEmpty) {
      filteredServices = filteredServices
          .where((s) =>
          s.title.toLowerCase().contains(searchQuery.toLowerCase()))
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

          TextField(
            onChanged: (value) {
              setState(() => searchQuery = value);
            },
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

          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories
                  .map((cat) => GestureDetector(
                onTap: () =>
                    setState(() => selectedCategory = cat),
                child: CategoryChip(
                  title: cat,
                  selected: selectedCategory == cat,
                ),
              ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredServices.isEmpty
                ? const Center(child: Text("No services found"))
                : ListView(
              children: filteredServices
                  .map((s) => ServiceCard(service: s))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
