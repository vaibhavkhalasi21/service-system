import 'package:flutter/material.dart';
import '../models/service.dart';
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

  final List<Service> services = [
    Service(
        title: "Electrician",
        category: "Electrician",
        price: 299,
        rating: 4.6,
        imagePath: "assets/images/electrician.png"),
    Service(
        title: "Plumber",
        category: "Plumber",
        price: 249,
        rating: 4.5,
        imagePath: "assets/images/plumbing.png"),
    Service(
        title: "House Cleaning",
        category: "Cleaning",
        price: 499,
        rating: 4.7,
        imagePath: "assets/images/cleaning.png"),
    Service(
        title: "Painter",
        category: "Painter",
        price: 249,
        rating: 4.5,
        imagePath: "assets/images/acrepair.png"),
    Service(
        title: "AC Repair",
        category: "AC Repair",
        price: 499,
        rating: 4.7,
        imagePath: "assets/images/painter.png"),
  ];

  final List<String> categories = [
    "All",
    "Electrician",
    "Plumber",
    "Cleaning",
    "AC Repair",
    "Painter"
  ];

  @override
  Widget build(BuildContext context) {
    // Apply category filter first
    List<Service> filteredServices = selectedCategory == "All"
        ? services
        : services.where((s) => s.category == selectedCategory).toList();

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filteredServices = filteredServices
          .where((s) =>
      s.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          s.category.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hello, Vendor 👋",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF7F00FF), Color(0xFF3F51B5)],
              ),
            ),
            child: const Center(
              child: Text(
                "Boost your services\nGet more bookings today",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // SEARCH BAR
          TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search services...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // CATEGORY FILTER CHIPS
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories
                  .map(
                    (cat) => GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: CategoryChip(
                    title: cat,
                    selected: selectedCategory == cat,
                  ),
                ),
              )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          // FILTERED SERVICES LIST
          Column(
            children: filteredServices
                .map((s) => ServiceCard(service: s))
                .toList(),
          ),
        ],
      ),
    );
  }
}
