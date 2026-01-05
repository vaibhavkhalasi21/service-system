import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Screens/vendor_application_page.dart';

import 'vendor_login.dart';
import 'booking_request_page.dart';
import 'vendor_post_service.dart';
import 'my_services_page.dart';

class VendorProfileTab extends StatefulWidget {
  const VendorProfileTab({super.key});

  @override
  State<VendorProfileTab> createState() => _VendorProfileTabState();
}

class _VendorProfileTabState extends State<VendorProfileTab> {
  String vendorName = "Vendor Name";
  String vendorEmail = "vendor@email.com";

  @override
  void initState() {
    super.initState();
    loadVendorData();
  }

  // =============================
  // LOAD VENDOR SESSION DATA
  // =============================
  Future<void> loadVendorData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vendorName = prefs.getString("vendor_name") ?? "Vendor Name";
      vendorEmail = prefs.getString("vendor_email") ?? "vendor@email.com";
    });
  }

  // =============================
  // LOGOUT
  // =============================
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const VendorLoginScreen()),
          (_) => false,
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
        children: [
          _profileCard(),

          const SizedBox(height: 24),

          /// 📥 VIEW APPLICATIONS (REAL API DATA)
          _actionButton(
            icon: Icons.list_alt,
            label: "View Applications",
            color: Colors.deepPurple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VendorApplicationsPage(),
                ),
              );
            },
          ),


          const SizedBox(height: 16),

          /// ➕ POST NEW SERVICE
          _actionButton(
            icon: Icons.add_circle_outline,
            label: "Post New Service",
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PostServicePage()),
              );
            },
          ),

          const SizedBox(height: 16),

          /// 👁 MY SERVICES
          _actionButton(
            icon: Icons.remove_red_eye,
            label: "My Services",
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyServicesPage()),
              );
            },
          ),

          const SizedBox(height: 16),

          /// 🚪 LOGOUT
          _actionButton(
            icon: Icons.logout,
            label: "Logout",
            color: Colors.deepPurple,
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }

  // =============================
  // PROFILE CARD
  // =============================
  Widget _profileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            vendorEmail,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // =============================
  // REUSABLE ACTION BUTTON
  // =============================
  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
