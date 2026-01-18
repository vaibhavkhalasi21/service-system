import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/service_categories.dart';


import '../models/vendor_application_item.dart';
import '../utils/location_utils.dart';

// ================= UI CONSTANTS =================
const Color kCard = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

class BookingRequestCard extends StatelessWidget {
  final VendorApplicationItem request;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const BookingRequestCard({
    super.key,
    required this.request,
    this.onAccept,
    this.onReject,
  });

  // ===============================
  // STATUS COLOR
  // ===============================
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

  // ===============================
  // OPEN MAP (SAFE FOR ANDROID 11+)
  // ===============================
  Future<void> _openMap(double lat, double lng) async {
    final uri = Uri.parse("geo:$lat,$lng?q=$lat,$lng");

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  // ===============================
  // WORKER → SERVICE DISTANCE
  // ===============================
  Widget _workerLocation() {
    if (request.workerLatitude == null ||
        request.workerLongitude == null ||
        request.serviceLatitude == null ||
        request.serviceLongitude == null) {
      return const SizedBox();
    }

    final distanceKm = LocationUtils.distanceInKm(
      lat1: request.workerLatitude!,
      lon1: request.workerLongitude!,
      lat2: request.serviceLatitude!,
      lon2: request.serviceLongitude!,
    );

    return InkWell(
      onTap: () => _openMap(
        request.serviceLatitude!,
        request.serviceLongitude!,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.directions_walk, size: 14, color: kGrey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              "📍 ~${distanceKm.toStringAsFixed(1)} km from service location",
              style: const TextStyle(
                color: kGrey,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localTime = request.createdAt.toLocal();
    final date = DateFormat("dd MMM yyyy").format(localTime);
    final time = DateFormat("hh:mm a").format(localTime);

    final bool isPending = request.status == "Pending";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 👤 WORKER INFO + STATUS
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
                    /// WORKER NAME
                    Text(
                      request.workerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    /// WORKER EMAIL
                    Text(
                      request.workerEmail,
                      style: const TextStyle(
                        fontSize: 13,
                        color: kGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    /// 🛠 SERVICE NAME
                    Text(
                      request.serviceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    /// 🏷 CATEGORY
                    Text(
                      request.category,
                      style: const TextStyle(
                        color: kPurple,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),



                    const SizedBox(height: 6),

                    /// 📍 DISTANCE + MAP
                    _workerLocation(),
                  ],
                ),
              ),

              /// STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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

          const SizedBox(height: 10),

          /// 📅 DATE & TIME
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: kGrey),
              const SizedBox(width: 6),
              Text(
                "$date • $time",
                style: const TextStyle(color: kGrey),
              ),
            ],
          ),

          /// ACTION BUTTONS
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
                    ),
                    child: const Text("Accept"),
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
