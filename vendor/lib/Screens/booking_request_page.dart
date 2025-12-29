import 'package:flutter/material.dart';
import '../models/booking_request.dart';
import '../widgets/booking_request_card.dart';
import 'customer_profile_page.dart';

class BookingRequestsPage extends StatefulWidget {
  final List<BookingRequest> bookingRequests;

  const BookingRequestsPage({super.key, required this.bookingRequests});

  @override
  State<BookingRequestsPage> createState() => _BookingRequestsPageState();
}

class _BookingRequestsPageState extends State<BookingRequestsPage> {
  late List<BookingRequest> requests;

  @override
  void initState() {
    super.initState();
    requests = List.from(widget.bookingRequests);
  }

  void acceptBooking(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Accepted")),
    );
    setState(() {
      requests.removeAt(index);
    });
  }

  void rejectBooking(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Rejected")),
    );
    setState(() {
      requests.removeAt(index);
    });
  }

  Future<void> openCustomerProfile(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerProfilePage(
          request: requests[index],
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      acceptBooking(index);
    } else if (result == false) {
      rejectBooking(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Requests"),
        backgroundColor: Colors.deepPurple,
      ),
      body: requests.isEmpty
          ? const Center(
        child: Text(
          "No new booking requests",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => openCustomerProfile(index),
              child: BookingRequestCard(
                request: requests[index],
                onAccept: () => acceptBooking(index),
                onReject: () => rejectBooking(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
