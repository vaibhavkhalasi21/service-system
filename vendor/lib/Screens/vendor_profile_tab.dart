import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Screens/vendor_payment_page.dart';

import '../services/vendor_api.dart';
import 'vendor_login.dart';
import 'vendor_application_page.dart';
import 'vendor_post_service.dart';
import 'my_services_page.dart';

// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kCard = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

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
        setState(() => isLoading = false);
      }
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: kPurple),
      );
    }

    return Container(
      color: kBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _profileHeader(),
            const SizedBox(height: 24),

            _menuTile(
              icon: Icons.edit,
              iconBg: Colors.blue,
              label: "Edit Name",
              onTap: () {},
            ),
            const SizedBox(height: 14),

            _menuTile(
              icon: Icons.list_alt,
              iconBg: Colors.deepPurple,
              label: "View Applications",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VendorApplicationsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            _menuTile(
              icon: Icons.work_outline,
              iconBg: Colors.teal,
              label: "My Services",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyServicesPage()),
                );
              },
            ),
            const SizedBox(height: 14),

            _menuTile(
              icon: Icons.payments,
              iconBg: Colors.green,
              label: "Payments",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VendorPaymentsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            _menuTile(
              icon: Icons.add_circle_outline,
              iconBg: kPurple,
              label: "Post New Service",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PostServicePage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            _menuTile(
              icon: Icons.logout,
              iconBg: Colors.red,
              label: "Logout",
              onTap: () => logout(context),
            ),
          ],
        ),
      ),
    );
  }

  // =============================
  // PROFILE HEADER
  // =============================
  Widget _profileHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kPurple, width: 3),
          ),
          child: const CircleAvatar(
            radius: 44,
            backgroundColor: kCard,
            child: Icon(Icons.person, size: 44, color: Colors.white),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          vendorName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          vendorEmail,
          style: const TextStyle(color: kGrey),
        ),
      ],
    );
  }

  // =============================
  // MENU TILE
  // =============================
  Widget _menuTile({
    required IconData icon,
    required Color iconBg,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: iconBg.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconBg),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: kGrey),
          ],
        ),
      ),
    );
  }
}
