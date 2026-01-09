import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Screens/vendor_payment_page.dart';

import '../services/vendor_api.dart';
import 'vendor_login.dart';
import 'vendor_application_page.dart';
import 'vendor_post_service.dart';
import 'my_services_page.dart';

class VendorProfileTab extends StatefulWidget {
  const VendorProfileTab({super.key});

  @override
  State<VendorProfileTab> createState() => _VendorProfileTabState();
}

class _VendorProfileTabState extends State<VendorProfileTab> {
  bool isLoading = true;

  String vendorName = "";
  String vendorEmail = "";

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  // =============================
  // FETCH PROFILE FROM API
  // =============================
  Future<void> fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("vendor_token");

      if (token == null) {
        debugPrint("NO TOKEN FOUND");
        setState(() => isLoading = false);
        return;
      }

      final result = await VendorApi.getProfile(token);

      if (result["status"] == 200) {
        final data = result["body"];

        setState(() {
          vendorName = data["name"] ?? "Vendor";
          vendorEmail = data["email"] ?? "";
          isLoading = false;
        });
      } else {
        debugPrint("PROFILE ERROR: ${result["body"]}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("PROFILE EXCEPTION: $e");
      setState(() => isLoading = false);
    }
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _profileCard(),

          const SizedBox(height: 24),

          // 📥 VIEW APPLICATIONS
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

          // ➕ POST NEW SERVICE
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

          // 👁 MY SERVICES
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

// 💰 PAYMENTS
          _actionButton(
            icon: Icons.payments,
            label: "Payments",
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VendorPaymentsPage(),
                ),
              );
            },
          ),



          const SizedBox(height: 16),

          // 🚪 LOGOUT
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
