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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Card
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
          ),

          const SizedBox(height: 24),

          // Options
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

          // Logout Button
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
