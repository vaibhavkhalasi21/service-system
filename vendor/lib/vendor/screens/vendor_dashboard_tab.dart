import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/vendor_service.dart';
import '../models/vendor_service_request.dart';
import '../services/service_api.dart';
import '../widgets/service_card.dart';

// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kCard = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kTextGrey = Color(0xFF9E9E9E);

class VendorHomeTab extends StatefulWidget {
  const VendorHomeTab({super.key});

  @override
  State<VendorHomeTab> createState() => _VendorHomeTabState();
}

class _VendorHomeTabState extends State<VendorHomeTab> {
  String selectedCategory = "All";
  String searchQuery = "";
  bool isLoading = true;

  String vendorName = "Vendor";
  List<VendorService> services = [];

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
  // LOAD VENDOR NAME
  // ===============================
  Future<void> loadVendorName() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      vendorName = prefs.getString("vendor_name") ?? "Vendor";
    });
  }

  // ===============================
  // FETCH VENDOR SERVICES
  // ===============================
  Future<void> fetchServices() async {
    setState(() => isLoading = true);

    try {
      final List<VendorServiceRequest> apiServices =
      await ServiceApi.getVendorServices();

      // ✅ STRONGLY TYPED LIST (fixes List<dynamic> error)
      final List<VendorService> mappedServices =
      apiServices.map(_mapApiToUi).toList();

      if (!mounted) return;
      setState(() {
        services = mappedServices;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("FETCH SERVICES ERROR: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  // ===============================
  // API → UI MAPPER
  // ===============================
  VendorService _mapApiToUi(VendorServiceRequest api) {
    return VendorService(
      id: api.id,
      title: api.serviceName,
      category: api.category,
      price: api.price.toInt(),
      imagePath: api.imageUrl != null
          ? "$baseUrl${api.imageUrl}"
          : "assets/images/cleaning.png",
      vendorName: api.vendorName ?? "Vendor",
      status: api.status,
      createdAt: api.createdAt,
      serviceDateTime: api.serviceDateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<VendorService> filteredServices =
    selectedCategory == "All"
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

    return Container(
      color: kBg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "WELCOME BACK",
            style: TextStyle(
              color: kTextGrey,
              letterSpacing: 1.2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            vendorName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // ================= SEARCH =================
          Container(
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              onChanged: (v) => setState(() => searchQuery = v),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search for a service...",
                hintStyle: TextStyle(color: kTextGrey),
                prefixIcon: Icon(Icons.search, color: kPurple),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 20),

// ================= CATEGORIES =================
          const Text(
            "Categories",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) {
                final bool selected = selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? kPurple : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kPurple),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : kPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),



          // ================= SERVICES LIST =================
          Expanded(
            child: isLoading
                ? const Center(
              child:
              CircularProgressIndicator(color: kPurple),
            )
                : RefreshIndicator(
              color: kPurple,
              onRefresh: fetchServices,
              child: filteredServices.isEmpty
                  ? const Center(
                child: Text(
                  "No services found",
                  style: TextStyle(color: kTextGrey),
                ),
              )
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
          ),
        ],
      ),
    );
  }
}
