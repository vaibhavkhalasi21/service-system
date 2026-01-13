import 'package:flutter/material.dart';
import '../models/worker_payment.dart';
import '../services/worker_payment_api.dart';
import '../sessions/worker_session.dart';

class WorkerPaymentsPage extends StatefulWidget {
  const WorkerPaymentsPage({super.key});

  @override
  State<WorkerPaymentsPage> createState() => _WorkerPaymentsPageState();
}

class _WorkerPaymentsPageState extends State<WorkerPaymentsPage> {
  bool isLoading = true;
  List<WorkerPayment> payments = [];

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      final data = await WorkerPaymentApi.getPayments();
      if (!mounted) return;
      setState(() {
        payments = data;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void showRatingDialog(int appId) {
    int rating = 5;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Rate Vendor"),
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
                    await WorkerPaymentApi.rateVendor(appId, rating);
                    loadPayments();
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

  Widget _statusChip(String t, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: c.withOpacity(.15),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      t,
      style: TextStyle(color: c, fontWeight: FontWeight.bold),
    ),
  );

  Widget _ratingStars(int r) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
          (i) => Icon(
        i < r ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 18,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final workerName = WorkerSession.currentWorker?.name ?? "Worker";

    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      body: Column(
        children: [
          /// 🔥 HEADER (same as dashboard)
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 30, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff0F0F0F),
                  Color(0xff1C1C1C),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "MY PAYMENTS",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// 📋 PAYMENTS LIST
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xff7C3AED),
              ),
            )
                : RefreshIndicator(
              color: const Color(0xff7C3AED),
              onRefresh: loadPayments,
              child: payments.isEmpty
                  ? ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Text(
                      "No completed jobs yet",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ],
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: payments.length,
                itemBuilder: (_, i) {
                  final p = payments[i];
                  final isPaid = p.paymentStatus == "Paid";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xff1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          // SERVICE
                          Text(
                            p.serviceName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // VENDOR
                          Text(
                            "Vendor: ${p.vendorName}",
                            style: const TextStyle(
                                color: Colors.white70),
                          ),
                          const SizedBox(height: 8),

                          // PAYMENT METHOD
                          if (isPaid && p.paymentMethod != null)
                            Row(
                              children: [
                                Icon(
                                  p.paymentMethod == "Cash"
                                      ? Icons.money
                                      : Icons.payment,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Paid via ${p.paymentMethod}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 12),

                          // PRICE + ACTION
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹${p.price}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              if (isPaid && !p.workerRated)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xff7C3AED),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () =>
                                      showRatingDialog(p.id),
                                  child:
                                  const Text("Rate Vendor"),
                                )
                              else if (p.workerRated)
                                _ratingStars(p.workerRating ?? 0)
                              else
                                _statusChip(
                                  "Pending",
                                  Colors.orange,
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
