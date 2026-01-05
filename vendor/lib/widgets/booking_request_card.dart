import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_request.dart';

class BookingRequestCard extends StatelessWidget {
  final BookingRequest request;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const BookingRequestCard({
    super.key,
    required this.request,
    this.onAccept,
    this.onReject,
  });

  Color _statusColor() {
    switch (request.status) {
      case "Accepted":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final date =
    DateFormat("dd MMM yyyy").format(request.serviceDateTime);
    final time =
    DateFormat("hh:mm a").format(request.serviceDateTime);

    final bool isPending = request.status == "Pending";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👤 Worker info
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.workerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        request.serviceName,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                /// 🔖 Status badge
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      color: _statusColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 📅 Date & 💰 Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text("$date • $time"),
                  ],
                ),
                Text(
                  "₹${request.price}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// ✅ Actions (only if Pending)
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text("Reject"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Accept"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
