import 'package:flutter/material.dart';
import 'package:vws/model/booking_model.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  // Dummy applied jobs data
  List<Booking> get bookings => [
    Booking(
      jobTitle: "AC Repair",
      location: "Surat",
      date: "28 Dec 2025",
      status: "Pending",
    ),
    Booking(
      jobTitle: "Electric Wiring",
      location: "Ahmedabad",
      date: "25 Dec 2025",
      status: "Accepted",
    ),
    Booking(
      jobTitle: "Kitchen Cabinet Work",
      location: "Vadodara",
      date: "20 Dec 2025",
      status: "Rejected",
    ),
  ];

  Color _statusColor(String status) {
    switch (status) {
      case "Accepted":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "Accepted":
        return Icons.check_circle;
      case "Rejected":
        return Icons.cancel;
      default:
        return Icons.hourglass_top;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F3F7),
      appBar: AppBar(
        title: const Text("My Bookings"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];

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
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Status icon
                CircleAvatar(
                  backgroundColor:
                  _statusColor(booking.status).withOpacity(0.15),
                  child: Icon(
                    _statusIcon(booking.status),
                    color: _statusColor(booking.status),
                  ),
                ),
                const SizedBox(width: 16),

                // Job info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.jobTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.date,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Status text
                Text(
                  booking.status,
                  style: TextStyle(
                    color: _statusColor(booking.status),
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
