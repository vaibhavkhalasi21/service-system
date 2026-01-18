import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/vendor_booking_request.dart';
import '../services/vendor_application_api.dart';
import '../services/vendor_payment_api.dart';

// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kCard = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

class VendorPaymentsPage extends StatefulWidget {
  const VendorPaymentsPage({super.key});

  @override
  State<VendorPaymentsPage> createState() => _VendorPaymentsPageState();
}

class _VendorPaymentsPageState extends State<VendorPaymentsPage> {
  bool isLoading = true;
  bool isPaying = false; // ✅ prevent double click
  List<VendorBookingRequest> bookings = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  // ===============================
  // LOAD PENDING PAYMENTS
  // ===============================
  Future<void> loadBookings() async {
    setState(() => isLoading = true);

    try {
      final all = await VendorApplicationApi.getVendorJobs();
      if (!mounted) return;

      setState(() {
        bookings = all.where((b) =>
        b.status == "Completed" &&
            b.paymentStatus == "Pending"
        ).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Payment load error: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  // ===============================
  // CASH PAYMENT
  // ===============================
  Future<void> payCash(int applicationId) async {
    if (isPaying) return;
    setState(() => isPaying = true);

    try {
      await VendorPaymentApi.createCashPayment(applicationId);
      await loadBookings();
      _showSnack("Cash payment recorded");
    } catch (e) {
      _showSnack("Cash payment failed");
    } finally {
      if (mounted) setState(() => isPaying = false);
    }
  }

  // ===============================
  // ONLINE PAYMENT (DEMO)
  // ===============================
  Future<void> payOnline(int applicationId) async {
    if (isPaying) return;
    setState(() => isPaying = true);

    try {
      await VendorPaymentApi.createDemoOnlinePayment(applicationId);
      await loadBookings();
      _showSnack("Online payment successful (Demo)");
    } catch (e) {
      _showSnack("Online payment failed");
    } finally {
      if (mounted) setState(() => isPaying = false);
    }
  }

  // ===============================
  // PAYMENT METHOD DIALOG
  // ===============================
  void showPaymentMethodDialog(int applicationId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Payment Method"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text("Cash"),
              onTap: () {
                Navigator.pop(context);
                payCash(applicationId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text("Online"),
              subtitle: const Text("Demo payment"),
              onTap: () {
                Navigator.pop(context);
                payOnline(applicationId);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Payments",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: kPurple),
      )
          : bookings.isEmpty
          ? const Center(
        child: Text(
          "No pending payments",
          style: TextStyle(color: kGrey),
        ),
      )
          : RefreshIndicator(
        color: kPurple,
        onRefresh: loadBookings,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final b = bookings[index];
            final date = DateFormat('dd MMM yyyy')
                .format(b.serviceDateTime.toLocal());

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.serviceName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Worker: ${b.workerName}",
                    style: const TextStyle(color: kGrey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Date: $date",
                    style: const TextStyle(color: kGrey),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${b.price}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kPurple,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isPaying
                            ? null
                            : () =>
                            showPaymentMethodDialog(b.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isPaying
                            ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text("Pay"),
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
