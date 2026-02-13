import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/service_categories.dart';
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
    "Cleaning",
    "Plumber",
    "Electrician",
    "AC Repair",
    "Painter",
  ];

  static const String baseUrl = "http://10.113.136.37:5244";

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
  // FETCH SERVICES
  // ===============================
  Future<void> fetchServices() async {
    setState(() => isLoading = true);

    try {
      final apiServices = await ServiceApi.getVendorServices();
      final mapped = apiServices.map(_mapApiToUi).toList();

      // 🔍 DEBUG (KEEP THIS)
      for (final s in mapped) {
        debugPrint(
          "CATEGORY DEBUG >>> ${s.title} | ${s.category} | ${safeEnumToCategory(s.category)}",
        );
      }

      if (!mounted) return;
      setState(() {
        services = mapped;
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
      category: api.category, // 🔥 INT ONLY
      price: api.price.toInt(),
      rating: api.rating ?? 0.0,
      imagePath: api.imageUrl != null && api.imageUrl!.isNotEmpty
          ? "$baseUrl${api.imageUrl}"
          : "$baseUrl/service-images/default.png",
      vendorName: api.vendorName,
      status: api.status,
      createdAt: api.createdAt,
      serviceDateTime: api.serviceDateTime,
      address: api.address,
      latitude: api.latitude ?? 0.0,
      longitude: api.longitude ?? 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<VendorService> filtered = services;

    // ✅ FIXED FILTER (ENUM FIRST, STRING LAST)
    if (selectedCategory != "All") {
      final selectedEnum = mapCategoryToEnum(selectedCategory);
      filtered = services
          .where((s) => s.category == selectedEnum)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (s) => s.title.toLowerCase().contains(searchQuery.toLowerCase()),
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

          // SEARCH
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

          // CATEGORIES
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((cat) {
                final selected = selectedCategory == cat;
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

          // LIST
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(color: kPurple),
            )
                : RefreshIndicator(
              onRefresh: fetchServices,
              child: filtered.isEmpty
                  ? const Center(
                child: Text(
                  "No services found",
                  style: TextStyle(color: kTextGrey),
                ),
              )
                  : ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) => ServiceCard(
                  service: filtered[i],
                  onUpdated: fetchServices,
                  isVendorView: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
