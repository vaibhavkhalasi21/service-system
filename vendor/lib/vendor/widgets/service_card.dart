import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/vendor_service.dart';
import '../screens/manage_service_page.dart';

// ================= UI CONSTANTS =================
const Color kCardBg = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kTextGrey = Color(0xFF9E9E9E);

class ServiceCard extends StatelessWidget {
  final VendorService service; // ✅ FIXED
  final VoidCallback onUpdated;
  final bool showActions;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onUpdated,
    this.showActions = false,
  });

  // ===============================
  // RELATIVE TIME
  // ===============================
  String timeAgo(DateTime date) {
    final now = DateTime.now().toLocal();
    final localDate = date.toLocal();
    final diff = now.difference(localDate);

    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hrs ago";
    return "${diff.inDays} days ago";
  }

  // ===============================
  // STATUS COLOR
  // ===============================
  Color statusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Completed":
        return Colors.blue;
      case "Expired":
        return Colors.orange;
      case "Disabled":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localServiceTime = service.serviceDateTime.toLocal();
    final date = DateFormat('dd MMM yyyy').format(localServiceTime);
    final time = DateFormat('hh:mm a').format(localServiceTime);

    final vendorName =
    service.vendorName.isNotEmpty ? service.vendorName : "Vendor";

    final bool isActive = service.status == "Active";

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= IMAGE =================
          Stack(
            children: [
              SizedBox(
                height: 170,
                width: double.infinity,
                child: service.imagePath.startsWith("http")
                    ? Image.network(
                  service.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: kTextGrey),
                )
                    : Image.asset(
                  service.imagePath,
                  fit: BoxFit.cover,
                ),
              ),

              // ================= STATUS BADGE =================
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor(service.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    service.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= TITLE + PRICE =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "₹${service.price}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPurple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // ================= CATEGORY =================
                Text(
                  service.category,
                  style: const TextStyle(
                    color: kTextGrey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 10),

                // ================= DATE & TIME =================
                Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 16, color: kTextGrey),
                    const SizedBox(width: 6),
                    Text(
                      "$date • $time",
                      style: const TextStyle(
                        color: kTextGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ================= POSTED INFO =================
                Row(
                  children: [
                    const Icon(Icons.person,
                        size: 16, color: kTextGrey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Posted by $vendorName • ${timeAgo(service.createdAt)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: kTextGrey,
                        ),
                      ),
                    ),
                  ],
                ),

                // ================= ACTIONS =================
                if (showActions) ...[
                  const SizedBox(height: 14),
                  if (isActive)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding:
                          const EdgeInsets.symmetric(vertical: 12),
                        ),
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
                        child: const Text(
                          "Edit Service",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else
                    Text(
                      "This service is ${service.status.toLowerCase()}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: kTextGrey,
                        fontStyle: FontStyle.italic,
                      ),
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
