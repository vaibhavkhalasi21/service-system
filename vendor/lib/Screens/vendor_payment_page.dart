import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_request.dart';
import '../services/vendor_application_api.dart';

class VendorPaymentsPage extends StatefulWidget {
  const VendorPaymentsPage({super.key});

  @override
  State<VendorPaymentsPage> createState() => _VendorPaymentsPageState();
}

class _VendorPaymentsPageState extends State<VendorPaymentsPage> {
  bool isLoading = true;
  List<BookingRequest> payments = [];

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  // ===============================
  // LOAD PAYMENTS
  // ===============================
  Future<void> loadPayments() async {
    try {
      final all = await VendorApplicationApi.getRequests();
      if (!mounted) return;

      setState(() {
        payments = all.where((j) => j.status == "Completed").toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Payment load error: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  // ===============================
  // MARK PAYMENT (CASH / ONLINE)
  // ===============================
  Future<void> markPaid(int applicationId, String method) async {
    try {
      await VendorApplicationApi.markPaymentPaidWithMethod(applicationId, method);

      await loadPayments();
      _showSnack("Payment marked as paid via $method");
    } catch (e) {
      _showSnack("Failed to mark payment");
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
                markPaid(applicationId, "Cash");
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text("Online"),
              onTap: () {
                Navigator.pop(context);
                markPaid(applicationId, "Online");
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
      _showSnack("Rating submitted successfully");
    } catch (_) {
      _showSnack("You have already rated this worker");
      await loadPayments();
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
      appBar: AppBar(title: const Text("Payments")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
          ? const Center(
        child: Text(
          "No completed jobs yet",
          style: TextStyle(color: Colors.grey),
        ),
      )
          : RefreshIndicator(
        onRefresh: loadPayments,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final p = payments[index];
            final date = DateFormat('dd MMM yyyy')
                .format(p.serviceDateTime.toLocal());
            final isPaid = p.paymentStatus == "Paid";

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.serviceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Worker: ${p.workerName}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Date: $date",
                      style: const TextStyle(color: Colors.grey),
                    ),

// ✅ ADD THIS BLOCK
                    if (isPaid && p.paymentMethod != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "Paid via ${p.paymentMethod}",
                          style: TextStyle(
                            color: p.paymentMethod == "Cash"
                                ? Colors.green
                                : Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${p.price}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isPaid)
                          ElevatedButton(
                            onPressed: () =>
                                showPaymentMethodDialog(p.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text("Mark Paid"),
                          )
                        else if (!p.vendorRated)
                          ElevatedButton(
                            onPressed: () =>
                                showRatingDialog(p.id),
                            child: const Text("Rate Worker"),
                          )
                        else
                          _ratingStars(p.vendorRating ?? 0),
                      ],
                    ),
                  ],
                ),
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
