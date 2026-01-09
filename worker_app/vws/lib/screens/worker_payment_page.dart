import 'package:flutter/material.dart';
import '../model/worker_payment.dart';
import '../services/worker_payment_api.dart';

class WorkerPaymentsPage extends StatefulWidget {
  const WorkerPaymentsPage({super.key});

  @override
  State<WorkerPaymentsPage> createState() =>
      _WorkerPaymentsPageState();
}

class _WorkerPaymentsPageState
    extends State<WorkerPaymentsPage> {
  bool isLoading = true;
  List<WorkerPayment> payments = [];

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      final all = await WorkerPaymentApi.getPayments();

      if (!mounted) return;

      setState(() {
        payments = all;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Worker payment load error: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Payments")),
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
            final isPaid =
                p.paymentStatus == "Paid";

            return Card(
              margin: const EdgeInsets.only(
                  bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
              ),
              child: Padding(
                padding:
                const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.serviceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Vendor: ${p.vendorName}",
                      style: const TextStyle(
                          color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          "₹${p.price}",
                          style:
                          const TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        _statusChip(
                          isPaid
                              ? "Paid"
                              : "Pending",
                          isPaid
                              ? Colors.green
                              : Colors.orange,
                        ),
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

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
