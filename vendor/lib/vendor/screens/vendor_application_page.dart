import 'package:flutter/material.dart';

import '../models/vendor_application_item.dart';
import '../services/vendor_application_api.dart';
import '../widgets/booking_request_card.dart';

// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

class VendorApplicationsPage extends StatefulWidget {
  const VendorApplicationsPage({super.key});

  @override
  State<VendorApplicationsPage> createState() =>
      _VendorApplicationsPageState();
}

class _VendorApplicationsPageState extends State<VendorApplicationsPage> {
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
      requests = await VendorApplicationApi.getApplicationItems();
    } catch (e) {
      debugPrint("Vendor applications error: $e");
      hasError = true;
    }

    if (mounted) setState(() => isLoading = false);
  }

  // =============================
  // UPDATE STATUS
  // =============================
  Future<void> updateStatus(int id, String status) async {
    await VendorApplicationApi.updateStatus(id, status);
    fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,

      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        title: const Text(
          "Worker Applications",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: kPurple),
      )
          : hasError
          ? const Center(
        child: Text(
          "Failed to load applications",
          style: TextStyle(color: kGrey),
        ),
      )
          : requests.isEmpty
          ? _emptyState()
          : RefreshIndicator(
        color: kPurple,
        onRefresh: fetchRequests,
        child: ListView.builder(
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
      ),
    );
  }

  // =============================
  // EMPTY STATE
  // =============================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPurple.withOpacity(0.15),
            ),
            child: const Icon(
              Icons.people_outline,
              size: 48,
              color: kPurple,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "No applications yet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Workers will appear here once they apply\nfor your services.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kGrey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
