import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/worker_service_api.dart';
import 'package:intl/intl.dart';

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

      setState(() {
        isLoading = false;
      });
    }
  }

  Color statusColor(String status) {
    status = status.toLowerCase();
    if (status == "accepted") return Colors.greenAccent;
    if (status == "rejected") return Colors.redAccent;
    if (status == "pending") return Colors.orangeAccent;
    return Colors.grey;
  }

  IconData statusIcon(String status) {
    status = status.toLowerCase();
    if (status == "accepted") return Icons.check_circle;
    if (status == "rejected") return Icons.cancel;
    if (status == "pending") return Icons.hourglass_top;
    return Icons.info;
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
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final b = bookings[index];

          final displayStatus = b.status.isNotEmpty
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                  statusColor(b.status).withOpacity(0.15),
                  child: Icon(
                    statusIcon(b.status),
                    color: statusColor(b.status),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 SERVICE NAME
                      Text(
                        b.jobTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// 🔹 CATEGORY & VENDOR
                      Text(
                        "${b.category} • ${b.vendorName}",
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// 🔹 DATE & TIME
                      Text(
                        DateFormat('dd MMM yyyy • hh:mm a')
                            .format(b.serviceDateTime),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔹 STATUS
                Text(
                  displayStatus,
                  style: TextStyle(
                    color: statusColor(b.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
