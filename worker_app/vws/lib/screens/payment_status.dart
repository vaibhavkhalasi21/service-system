import 'package:flutter/material.dart';

class PaymentStatusScreen extends StatefulWidget {
  const PaymentStatusScreen({super.key});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  String paymentMethod = "online";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💼 Payment Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Application Fee",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 💳 Payment Method
            const Text(
              "Select Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _paymentTile(
              value: "online",
              title: "Online Payment",
              subtitle: "UPI / Card / Net Banking",
              icon: Icons.payment,
            ),

            _paymentTile(
              value: "offline",
              title: "Offline Payment",
              subtitle: "Pay cash to vendor",
              icon: Icons.money,
            ),

            const Spacer(),

            // 🚀 Pay Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  _showResultDialog();
                },
                child: Text(
                  paymentMethod == "online"
                      ? "Pay Now"
                      : "Confirm Offline Payment",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Payment Option Tile
  Widget _paymentTile({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: RadioListTile(
        value: value,
        groupValue: paymentMethod,
        activeColor: Colors.deepPurple,
        onChanged: (value) {
          setState(() {
            paymentMethod = value!;
          });
        },
        title: Text(title),
        subtitle: Text(subtitle),
        secondary: Icon(icon),
      ),
    );
  }

  // ✅ Result Dialog
  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(
              paymentMethod == "online"
                  ? Icons.check_circle
                  : Icons.info,
              color:
              paymentMethod == "online" ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(
              paymentMethod == "online"
                  ? "Payment Successful"
                  : "Offline Payment",
            ),
          ],
        ),
        content: Text(
          paymentMethod == "online"
              ? "Your payment was completed successfully."
              : "Please pay the amount directly to the vendor.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // payment screen
              Navigator.pop(context); // apply job screen
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
