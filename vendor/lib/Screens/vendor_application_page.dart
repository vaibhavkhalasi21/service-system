import 'package:flutter/material.dart';
import '../models/booking_request.dart';
import '../services/vendor_application_api.dart';
import '../widgets/booking_request_card.dart';

class VendorApplicationsPage extends StatefulWidget {
  const VendorApplicationsPage({super.key});

  @override
  State<VendorApplicationsPage> createState() =>
      _VendorApplicationsPageState();
}

class _VendorApplicationsPageState extends State<VendorApplicationsPage> {
  bool isLoading = true;
  bool hasError = false;
  List<BookingRequest> requests = [];

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
      requests = await VendorApplicationApi.getRequests();
    } catch (_) {
      hasError = true;
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> updateStatus(int id, String status) async {
    await VendorApplicationApi.updateStatus(id, status);
    fetchRequests(); // refresh
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
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return BookingRequestCard(
            request: req,
            onAccept: () =>
                updateStatus(req.id, "Accepted"),
            onReject: () =>
                updateStatus(req.id, "Rejected"),
          );
        },
      ),
    );
  }
}
