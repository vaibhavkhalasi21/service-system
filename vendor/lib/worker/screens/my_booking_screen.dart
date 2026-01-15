import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/booking_model.dart';
import '../services/worker_service_api.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  bool isLoading = true;
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      final result = await WorkerServiceApi.getMyBookings();
      if (!mounted) return;

      setState(() {
        bookings = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  // ================= STATUS UI =================
  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return Colors.greenAccent;
      case "rejected":
        return Colors.redAccent;
      case "completed":
        return Colors.blueAccent;
      case "pending":
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "accepted":
        return Icons.check_circle;
      case "rejected":
        return Icons.cancel;
      case "completed":
        return Icons.verified;
      case "pending":
        return Icons.hourglass_top;
      default:
        return Icons.info;
    }
  }

  Color paymentColor(String status) {
    return status.toLowerCase() == "paid"
        ? Colors.greenAccent
        : Colors.orangeAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F0F0F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Bookings",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xff7C3AED),
        ),
      )
          : bookings.isEmpty
          ? const Center(
        child: Text(
          "No applications yet",
          style: TextStyle(color: Colors.white60),
        ),
      )
          : RefreshIndicator(
        color: const Color(0xff7C3AED),
        onRefresh: loadBookings,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final b = bookings[index];

            final displayStatus =
            b.status.isNotEmpty
                ? b.status[0].toUpperCase() +
                b.status.substring(1).toLowerCase()
                : "Pending";

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= HEADER =================
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: statusColor(b.status)
                            .withOpacity(0.15),
                        child: Icon(
                          statusIcon(b.status),
                          color: statusColor(b.status),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          b.jobTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        displayStatus,
                        style: TextStyle(
                          color: statusColor(b.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ================= DETAILS =================
                  Text(
                    "${b.category} • ${b.vendorName}",
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    DateFormat('dd MMM yyyy • hh:mm a')
                        .format(b.serviceDateTime),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ================= PAYMENT =================
                  Row(
                    children: [
                      Icon(
                        Icons.payments_outlined,
                        size: 16,
                        color: paymentColor(b.paymentStatus),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Payment: ${b.paymentStatus}",
                        style: TextStyle(
                          color:
                          paymentColor(b.paymentStatus),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),

                      // ================= RATING =================
                      if (b.status.toLowerCase() == "completed")
                        b.vendorRated
                            ? Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              b.vendorRating
                                  ?.toString() ??
                                  "-",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                            : TextButton(
                          onPressed: () {
                            // 🔥 NEXT STEP: rating dialog
                          },
                          child: const Text(
                            "Rate Vendor",
                            style: TextStyle(
                              color: Color(0xff7C3AED),
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
