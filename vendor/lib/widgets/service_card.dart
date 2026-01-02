import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/service.dart';
import '../screens/manage_service_page.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onUpdated;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ SAFE: already local time, no conversion here
    final String formattedDate =
    DateFormat('dd MMM yyyy').format(service.createdAt);

    final String formattedTime =
    DateFormat('hh:mm a').format(service.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 IMAGE
          SizedBox(
            height: 160,
            width: double.infinity,
            child: service.imagePath.startsWith("http")
                ? Image.network(
              service.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image, size: 40),
              ),
            )
                : Image.asset(
              service.imagePath,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🏷 TITLE
                      Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // 📂 CATEGORY
                      Text(
                        service.category,
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 4),

                      // 💰 PRICE + RATING
                      Text(
                        "₹${service.price} • ⭐ ${service.rating}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // 🕒 DATE & TIME
                      const SizedBox(height: 6),
                      Text(
                        "$formattedDate • $formattedTime",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                // ⚙ MANAGE BUTTON
                ElevatedButton(
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ManageServicePage(service: service),
                      ),
                    );

                    if (updated == true) {
                      onUpdated();
                    }
                  },
                  child: const Text("Manage"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
