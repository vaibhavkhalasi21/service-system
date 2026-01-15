import 'package:flutter/material.dart';

import '../models/vendor_application_item.dart';
import '../services/vendor_application_api.dart';
import '../widgets/booking_request_card.dart';

class BookingRequestsPage extends StatefulWidget {
  const BookingRequestsPage({super.key});

  @override
  State<BookingRequestsPage> createState() =>
      _BookingRequestsPageState();
}

class _BookingRequestsPageState extends State<BookingRequestsPage> {
  bool isLoading = true;
  bool hasError = false;

  // ✅ CORRECT MODEL
  List<VendorApplicationItem> requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  // =============================
  // FETCH APPLICATIONS
  // =============================
  Future<void> fetchRequests() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      requests =
      await VendorApplicationApi.getApplicationItems();
    } catch (e) {
      debugPrint("BookingRequests error: $e");
      hasError = true;
    }

    if (mounted) setState(() => isLoading = false);
  }

  // =============================
  // UPDATE STATUS
  // =============================
  Future<void> _updateStatus(int id, String status) async {
    await VendorApplicationApi.updateStatus(id, status);
    fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Applications"),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : hasError
          ? const Center(
        child: Text("Failed to load applications"),
      )
          : requests.isEmpty
          ? const Center(
        child: Text("No applications yet"),
      )
          : RefreshIndicator(
        onRefresh: fetchRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];

            return BookingRequestCard(
              request: request, // VendorApplicationItem
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
