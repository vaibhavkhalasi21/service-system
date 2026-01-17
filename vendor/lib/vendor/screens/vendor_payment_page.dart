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
  List<VendorBookingRequest> payments = [];

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  // ===============================
  // LOAD PAYMENTS
  // ===============================
  Future<void> loadPayments() async {
    setState(() => isLoading = true);

    try {
      final all = await VendorApplicationApi.getApplications();
      if (!mounted) return;

      setState(() {
        payments = all.where((j) => j.status == "Completed").toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Payments load error: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  // ===============================
  // CASH PAYMENT
  // ===============================
  Future<void> markCashPaid(int applicationId) async {
    try {
      await VendorPaymentApi.markPaidCash(applicationId);
      await loadPayments();
      _showSnack("Cash payment marked successfully");
    } catch (_) {
      _showSnack("Failed to mark cash payment");
    }
  }

  // ===============================
  // ONLINE PAYMENT (DEMO)
  // ===============================
  Future<void> markOnlinePaid(int applicationId) async {
    try {
      await VendorPaymentApi.markPaidOnline(applicationId);
      await loadPayments();
      _showSnack("Online payment successful (Demo)");
    } catch (_) {
      _showSnack("Failed to mark online payment");
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
                markCashPaid(applicationId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text("Online"),
              subtitle: const Text("Demo payment"),
              onTap: () {
                Navigator.pop(context);
                markOnlinePaid(applicationId);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // RATE WORKER
  // ===============================
  Future<void> rateWorker(int applicationId, int rating) async {
    try {
      await VendorApplicationApi.rateWorker(applicationId, rating);
      await loadPayments();
      _showSnack("Rating submitted");
    } catch (_) {
      _showSnack("You have already rated this worker");
    }
  }

  void showRatingDialog(int applicationId) {
    int rating = 5;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Rate Worker"),
              content: DropdownButton<int>(
                value: rating,
                isExpanded: true,
                items: [1, 2, 3, 4, 5]
                    .map(
                      (e) => DropdownMenuItem(
                    value: e,
                    child: Text("$e ⭐"),
                  ),
                )
                    .toList(),
                onChanged: (v) {
                  setDialogState(() {
                    rating = v!;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await rateWorker(applicationId, rating);
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
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
          : payments.isEmpty
          ? const Center(
        child: Text(
          "No completed jobs yet",
          style: TextStyle(color: kGrey),
        ),
      )
          : RefreshIndicator(
        color: kPurple,
        onRefresh: loadPayments,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final p = payments[index];
            final date = DateFormat('dd MMM yyyy')
                .format(p.serviceDateTime.toLocal());
            final isPaid = p.paymentStatus == "Paid";

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
                    p.serviceName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Worker: ${p.workerName}",
                    style:
                    const TextStyle(color: kGrey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Date: $date",
                    style:
                    const TextStyle(color: kGrey),
                  ),
                  if (isPaid &&
                      p.paymentMethod != null)
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 6),
                      child: Text(
                        "Paid via ${p.paymentMethod}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Text(
                        "₹${p.price}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                          color: kPurple,
                        ),
                      ),
                      if (!isPaid)
                        ElevatedButton(
                          onPressed: () =>
                              showPaymentMethodDialog(
                                  p.id),
                          style: ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            Colors.green,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  12),
                            ),
                          ),
                          child:
                          const Text("Pay"),
                        )
                      else if (!p.vendorRated)
                        ElevatedButton(
                          onPressed: () =>
                              showRatingDialog(
                                  p.id),
                          style: ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            kPurple,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  12),
                            ),
                          ),
                          child: const Text(
                              "Rate Worker"),
                        )
                      else
                        _ratingStars(
                            p.vendorRating ?? 0),
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

  Widget _ratingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }
}
