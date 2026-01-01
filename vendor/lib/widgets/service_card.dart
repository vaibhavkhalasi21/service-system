import 'package:flutter/material.dart';
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 IMAGE
          SizedBox(
            height: 160,
            width: double.infinity,
            child: service.imagePath.startsWith("http")
                ? Image.network(
              service.imagePath,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 40),
            )
                : Image.asset(
              service.imagePath,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.category,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹${service.price} • ⭐ ${service.rating}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: const Text("Manage"),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ManageServicePage(service: service),
                      ),
                    );

                    // 🔥 REFRESH HOME AFTER UPDATE
                    if (updated == true) {
                      onUpdated();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
