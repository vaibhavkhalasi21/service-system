import 'package:flutter/material.dart';
import '../model/booking_model.dart';
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
      bookings = await WorkerServiceApi.getMyBookings();

      // DEBUG: Check backend status
      for (var b in bookings) {
        debugPrint("Job: ${b.jobTitle}, Status: ${b.status}");
      }
    } catch (e) {
      debugPrint("Error loading bookings: $e");
    }
    setState(() => isLoading = false);
  }


  Color statusColor(String status) {
    status = status.toLowerCase();
    if (status == "accepted") return Colors.green;
    if (status == "rejected") return Colors.red;
    if (status == "pending") return Colors.orange;
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
      backgroundColor: const Color(0xffF2F3F7),
      appBar: AppBar(title: const Text("My Bookings")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
          ? const Center(child: Text("No applications yet"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final b = bookings[index];

          // Safe display of status
          final displayStatus = b.status.isNotEmpty
              ? b.status[0].toUpperCase() + b.status.substring(1).toLowerCase()
              : "Pending";

          Text(
            displayStatus,
            style: TextStyle(
              color: statusColor(b.status),
              fontWeight: FontWeight.bold,
            ),
          );

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
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
                      Text(
                        b.jobTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd MMM yyyy')
                            .format(b.serviceDateTime),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
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
          );
        },
      ),
    );
  }
}
