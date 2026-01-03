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

  /// ⏱ Relative time (posted)
  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return "${diff.inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    final scheduledDate =
    DateFormat('dd MMM yyyy').format(service.serviceDateTime);

    final scheduledTime =
    DateFormat('hh:mm a').format(service.serviceDateTime);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🖼 IMAGE
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🏷 TITLE
                Text(
                  service.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                /// 📂 CATEGORY
                Text(
                  service.category,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 6),

                /// 💰 PRICE + RATING
                Text(
                  "₹${service.price} • ⭐ ${service.rating}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 8),

                /// 🗓 SERVICE SCHEDULE
                Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 16, color: Colors.blueGrey),
                    const SizedBox(width: 6),
                    Text(
                      "Service on $scheduledDate • $scheduledTime",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                /// ⏱ POSTED AGO
                Row(
                  children: [
                    const Icon(Icons.history,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "Posted ${timeAgo(service.createdAt)}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// ⚙ MANAGE BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
