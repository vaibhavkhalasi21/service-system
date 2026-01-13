import 'package:flutter/material.dart';

class PaymentStatusScreen extends StatefulWidget {
  const PaymentStatusScreen({super.key});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  String paymentMethod = "online";
  final amountCtrl = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F0F0F),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Payment",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 💼 PAYMENT SUMMARY
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xff1E1E1E),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Application Fee",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "₹ ${amountCtrl.text}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff7C3AED),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 💰 ENTER AMOUNT
            const Text(
              "Enter Amount",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixText: "₹ ",
                prefixStyle: const TextStyle(color: Colors.white),
                hintText: "Enter amount",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xff1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 28),

            /// 💳 PAYMENT METHOD
            const Text(
              "Select Payment Method",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

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

            /// 🚀 PAY BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff7C3AED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _handlePay,
                child: Text(
                  paymentMethod == "online"
                      ? "Pay Now"
                      : "Confirm Offline Payment",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 PAYMENT TILE (DARK)
  Widget _paymentTile({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = paymentMethod == value;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? const Color(0xff7C3AED) : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: RadioListTile(
        value: value,
        groupValue: paymentMethod,
        activeColor: const Color(0xff7C3AED),
        onChanged: (value) {
          setState(() => paymentMethod = value!);
        },
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white54),
        ),
        secondary: Icon(icon, color: Colors.white70),
      ),
    );
  }

  /// ✅ HANDLE PAY
  void _handlePay() {
    if (amountCtrl.text.isEmpty || amountCtrl.text == "0") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid amount")),
      );
      return;
    }
    _showResultDialog();
  }

  /// ✅ RESULT DIALOG
  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff1E1E1E),
        title: Row(
          children: [
            Icon(
              paymentMethod == "online"
                  ? Icons.check_circle
                  : Icons.info,
              color:
              paymentMethod == "online" ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 10),
            Text(
              paymentMethod == "online"
                  ? "Payment Successful"
                  : "Offline Payment",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          paymentMethod == "online"
              ? "₹${amountCtrl.text} payment completed successfully."
              : "Please pay ₹${amountCtrl.text} directly to the vendor.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Color(0xff7C3AED)),
            ),
          ),
        ],
      ),
    );
  }
}
