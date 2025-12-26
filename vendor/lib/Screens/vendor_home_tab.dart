import 'package:flutter/material.dart';

class VendorHomeTab extends StatelessWidget {
  const VendorHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 👋 Greeting
          const Text(
            "Hello, Vendor 👋",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          /// 🎁 Offer Banner
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

          /// 🔍 Search
          TextField(
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

          /// 🏷️ Categories
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _CategoryChip(title: "All", selected: true),
                _CategoryChip(title: "Electrician"),
                _CategoryChip(title: "Plumber"),
                _CategoryChip(title: "Cleaning"),
                _CategoryChip(title: "AC Repair"),
                _CategoryChip(title: "Painter"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 🧾 Services List
          _ServiceCard(
            title: "Electrician",
            price: 299,
            rating: 4.6,
            icon: Icons.electrical_services,
          ),
          _ServiceCard(
            title: "Plumber",
            price: 249,
            rating: 4.5,
            icon: Icons.plumbing,
          ),
          _ServiceCard(
            title: "House Cleaning",
            price: 499,
            rating: 4.7,
            icon: Icons.cleaning_services,
          ),
        ],
      ),
    );
  }
}

/// 🏷️ Category Chip
class _CategoryChip extends StatelessWidget {
  final String title;
  final bool selected;

  const _CategoryChip({required this.title, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(title),
        backgroundColor: selected ? Colors.blue : Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

/// 🧾 Service Card
class _ServiceCard extends StatelessWidget {
  final String title;
  final int price;
  final double rating;
  final IconData icon;

  const _ServiceCard({
    required this.title,
    required this.price,
    required this.rating,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFEDE7F6),
              child: Icon(icon, color: Colors.deepPurple),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(rating.toString()),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  "₹$price",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () {},
                  child: const Text("Manage"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
