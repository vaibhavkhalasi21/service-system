import 'package:flutter/material.dart';
import '../models/vendor_booking_request.dart';
import '../services/vendor_application_api.dart';
import '../widgets/booking_request_card.dart';


class BookingRequestsPage extends StatefulWidget {
  const BookingRequestsPage({super.key});

  @override
  State<BookingRequestsPage> createState() => _BookingRequestsPageState();
}

class _BookingRequestsPageState extends State<BookingRequestsPage> {
  bool isLoading = true;
  bool hasError = false;
  List<VendorBookingRequest> requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      requests = (await VendorApplicationApi.getRequests()).cast<VendorBookingRequest>();
    } catch (_) {
      hasError = true;
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _updateStatus(int id, String status) async {
    await VendorApplicationApi.updateStatus(id, status);
    fetchRequests(); // refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Worker Applications")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? const Center(child: Text("Failed to load applications"))
          : requests.isEmpty
          ? const Center(child: Text("No applications yet"))
          : RefreshIndicator(
        onRefresh: fetchRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];

            return BookingRequestCard(
              request: request,
              onAccept: () =>
                  _updateStatus(request.id, "Accepted"),
              onReject: () =>
                  _updateStatus(request.id, "Rejected"),
            );
          },
        ),
      ),
    );
  }
}
