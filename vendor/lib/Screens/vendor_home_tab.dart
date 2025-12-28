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
            imagePath: "assets/images/electrician.png",
          ),
          _ServiceCard(
            title: "Plumber",
            price: 249,
            rating: 4.5,
            imagePath: "assets/images/plumbing.png",
          ),
          _ServiceCard(
            title: "House Cleaning",
            price: 499,
            rating: 4.7,
            imagePath: "assets/images/cleaning.png",
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

/// 🧾 Service Card (FULL HEIGHT IMAGE)
class _ServiceCard extends StatelessWidget {
  final String title;
  final int price;
  final double rating;
  final String imagePath;

  const _ServiceCard({
    required this.title,
    required this.price,
    required this.rating,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        height: 90, // Card height
        child: Row(
          children: [

            /// 🖼️ FULL HEIGHT IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Image.asset(
                imagePath,
                width: 90,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            /// 📄 Title + Rating
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
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

            /// 💰 Price + Manage Button
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
