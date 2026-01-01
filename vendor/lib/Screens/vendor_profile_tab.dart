import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking_request.dart';
import 'vendor_login.dart';
import 'booking_request_page.dart';
import 'vendor_post_service.dart';

class VendorProfileTab extends StatefulWidget {
  const VendorProfileTab({super.key});

  @override
  State<VendorProfileTab> createState() => _VendorProfileTabState();
}

class _VendorProfileTabState extends State<VendorProfileTab> {
  String vendorName = "Vendor Name";
  String vendorEmail = "vendor@email.com";

  List<BookingRequest> bookingRequests = [
    BookingRequest(
      workerName: "Rahul Sharma",
      serviceName: "Electrician Service",
      price: 350,
      date: "29 Dec 2025",
      time: "10:30 AM",
    ),
    BookingRequest(
      workerName: "Amit Patel",
      serviceName: "Plumbing Service",
      price: 450,
      date: "30 Dec 2025",
      time: "02:00 PM",
    ),
  ];

  @override
  void initState() {
    super.initState();
    loadVendorData();
  }

  // =============================
  // LOAD SESSION DATA
  // =============================
  Future<void> loadVendorData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vendorName = prefs.getString("vendor_name") ?? "Vendor Name";
      vendorEmail = prefs.getString("vendor_email") ?? "vendor@email.com";
    });
  }

  // =============================
  // SAVE PROFILE DATA
  // =============================
  Future<void> saveVendorData(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("vendor_name", name);
    await prefs.setString("vendor_email", email);

    setState(() {
      vendorName = name;
      vendorEmail = email;
    });
  }

  // =============================
  // LOGOUT (CLEAR SESSION)
  // =============================
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const VendorLoginScreen()),
          (route) => false,
    );
  }

  // =============================
  // EDIT PROFILE UI
  // =============================
  void openEditProfile() {
    final nameController = TextEditingController(text: vendorName);
    final emailController = TextEditingController(text: vendorEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Vendor Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    saveVendorData(
                      nameController.text.trim(),
                      emailController.text.trim(),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =============================
  // UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PROFILE CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
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
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                  onPressed: openEditProfile,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // VIEW APPLICATIONS
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text("View Applications"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingRequestsPage(
                      bookingRequests: bookingRequests,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // POST SERVICE
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text("Post New Service"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PostServicePage(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          // LOGOUT
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
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
}
