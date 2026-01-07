import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/service.dart';
import '../screens/manage_service_page.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onUpdated;
  final bool showActions;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onUpdated,
    this.showActions = false,
  });

  String timeAgo(DateTime date) {
    final now = DateTime.now().toLocal();
    final localDate = date.toLocal();
    final diff = now.difference(localDate);

    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hrs ago";
    return "${diff.inDays} days ago";
  }


  @override
  Widget build(BuildContext context) {
    final date =
    DateFormat('dd MMM yyyy').format(service.serviceDateTime);
    final time =
    DateFormat('hh:mm a').format(service.serviceDateTime);

    // ✅ SAFE vendor name
    final vendorName =
    service.vendorName.isNotEmpty ? service.vendorName : "Vendor";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= IMAGE =================
          SizedBox(
            height: 160,
            width: double.infinity,
            child: service.imagePath.startsWith("http")
                ? Image.network(
              service.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.broken_image)),
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
                // ================= TITLE =================
                Text(
                  service.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // ================= CATEGORY =================
                Text(
                  service.category,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 6),

                // ================= PRICE =================
                Text(
                  "₹${service.price}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // ================= SERVICE DATE & TIME =================
                Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 16, color: Colors.blueGrey),
                    const SizedBox(width: 6),
                    Text(
                      "Service on $date • $time",
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // ================= POSTED BY =================
                Row(
                  children: [
                    const Icon(Icons.person,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Posted by $vendorName • ${timeAgo(service.createdAt)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                // ================= ACTIONS =================
                if (showActions) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ManageServicePage(service: service),
                              ),
                            );
                            if (updated == true) onUpdated();
                          },
                          child: const Text("Edit"),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
