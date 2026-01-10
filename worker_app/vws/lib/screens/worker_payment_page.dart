import 'package:flutter/material.dart';
import '../model/worker_payment.dart';
import '../services/worker_payment_api.dart';

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
      setState(() => isLoading = false);
    }
  }

  void showRatingDialog(int appId) {
    int rating = 5;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rate Vendor"),
        content: DropdownButton<int>(
          value: rating,
          isExpanded: true,
          items: [1, 2, 3, 4, 5]
              .map((e) => DropdownMenuItem(
            value: e,
            child: Text("$e ⭐"),
          ))
              .toList(),
          onChanged: (v) => rating = v!,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Payments")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: loadPayments,
        child: payments.isEmpty
            ? ListView(
          children: const [
            SizedBox(height: 120),
            Center(child: Text("No completed jobs yet")),
          ],
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: payments.length,
          itemBuilder: (_, i) {
            final p = payments[i];
            final isPaid = p.paymentStatus == "Paid";

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.serviceName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("Vendor: ${p.vendorName}",
                        style:
                        const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₹${p.price}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        if (isPaid && !p.workerRated)
                          ElevatedButton(
                            onPressed: () =>
                                showRatingDialog(p.id),
                            child: const Text("Rate Vendor"),
                          )
                        else if (p.workerRated)
                          _ratingStars(p.workerRating ?? 0)
                        else
                          _statusChip(
                              "Pending", Colors.orange),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statusChip(String t, Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration:
    BoxDecoration(color: c.withOpacity(.15), borderRadius: BorderRadius.circular(12)),
    child: Text(t, style: TextStyle(color: c)),
  );

  Widget _ratingStars(int r) => Row(
    children: List.generate(
      5,
          (i) => Icon(
        i < r ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 18,
      ),
    ),
  );
}
