import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vendor_login.dart';

class VendorProfileTab extends StatefulWidget {
  const VendorProfileTab({super.key});

  @override
  State<VendorProfileTab> createState() => _VendorProfileTabState();
}

class _VendorProfileTabState extends State<VendorProfileTab> {
  String vendorName = "";
  String vendorEmail = "";

  /// TEMP booking requests (later connect Firebase)
  List<Map<String, dynamic>> bookingRequests = [
    {
      "service": "Electrician",
      "customer": "Rahul Sharma",
      "price": 299,
    },
    {
      "service": "Plumber",
      "customer": "Amit Verma",
      "price": 249,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadVendorData();
  }

  Future<void> loadVendorData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vendorName = prefs.getString("vendor_name") ?? "Vendor Name";
      vendorEmail = prefs.getString("vendor_email") ?? "vendor@email.com";
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const VendorLoginScreen()),
          (route) => false,
    );
  }

  void acceptBooking(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Accepted")),
    );
    setState(() {
      bookingRequests.removeAt(index);
    });
  }

  void rejectBooking(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Rejected")),
    );
    setState(() {
      bookingRequests.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          /// 👤 Profile Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, size: 45, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  vendorName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  vendorEmail,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// 📦 Booking Requests
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "New Booking Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 12),

          bookingRequests.isEmpty
              ? const Text(
            "No new booking requests",
            style: TextStyle(color: Colors.grey),
          )
              : Column(
            children: List.generate(
              bookingRequests.length,
                  (index) {
                final booking = bookingRequests[index];
                return _BookingRequestCard(
                  service: booking["service"],
                  customer: booking["customer"],
                  price: booking["price"],
                  onAccept: () => acceptBooking(index),
                  onReject: () => rejectBooking(index),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          /// ⚙️ Options
          _buildOption(
            icon: Icons.edit,
            title: "Edit Profile",
            onTap: () {},
          ),
          _buildOption(
            icon: Icons.settings,
            title: "Settings",
            onTap: () {},
          ),

          const SizedBox(height: 40),

          /// 🚪 Logout
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

/// 📄 Booking Request Card
class _BookingRequestCard extends StatelessWidget {
  final String service;
  final String customer;
  final int price;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _BookingRequestCard({
    required this.service,
    required this.customer,
    required this.price,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Customer: $customer",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹$price",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: onReject,
                      child: const Text(
                        "Reject",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onAccept,
                      child: const Text("Accept"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
