import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_request.dart';

// ================= UI CONSTANTS =================
const Color kCard = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

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
    final localTime = request.serviceDateTime.toLocal();
    final date = DateFormat("dd MMM yyyy").format(localTime);
    final time = DateFormat("hh:mm a").format(localTime);

    final bool isPending = request.status == "Pending";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 👤 WORKER INFO
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: kPurple,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// NAME
                    Text(
                      request.workerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    /// EMAIL
                    Text(
                      request.workerEmail,
                      style: const TextStyle(
                        fontSize: 13,
                        color: kGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    /// SERVICE
                    Text(
                      request.serviceName,
                      style: const TextStyle(
                        color: kGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              /// STATUS BADGE
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  request.status,
                  style: TextStyle(
                    color: _statusColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// DATE + PRICE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: kGrey),
                  const SizedBox(width: 6),
                  Text(
                    "$date • $time",
                    style: const TextStyle(color: kGrey),
                  ),
                ],
              ),
              Text(
                "₹${request.price}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kPurple,
                ),
              ),
            ],
          ),

          /// ACTIONS
          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
