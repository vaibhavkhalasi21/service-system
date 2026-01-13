import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../vendor/screens/vendor_home.dart';
import '../vendor/services/vendor_api.dart';

// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kCard = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool isPasswordHidden = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  // =============================
  // LOGIN
  // =============================
  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final response = await VendorApi.loginVendor(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      final status = response["status"];
      final body = response["body"];

      if (status == 200 && body is Map<String, dynamic>) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setInt("vendor_id", int.parse(body["userId"].toString()));
        await prefs.setString("vendor_email", body["email"] ?? "");
        await prefs.setString("vendor_name", body["name"] ?? "Vendor");
        await prefs.setString("role", body["role"] ?? "Vendor");

        if (body["token"] == null) {
          throw Exception("Login failed");
        }

        await prefs.setString("vendor_token", body["token"]);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VendorHomeScreen()),
        );
      } else {
        throw Exception("Invalid email or password");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // =============================
  // UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white12),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ================= LOGO =================
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPurple.withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.storefront,
                        color: kPurple,
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Vendor Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Manage your services & workers",
                      style: TextStyle(
                        color: kGrey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= EMAIL =================
                    _darkField(
                      controller: emailCtrl,
                      label: "Email",
                      icon: Icons.email,
                      validator: (v) =>
                      v == null || v.isEmpty ? "Enter email" : null,
                    ),

                    const SizedBox(height: 14),

                    // ================= PASSWORD =================
                    _darkField(
                      controller: passwordCtrl,
                      label: "Password",
                      icon: Icons.lock,
                      obscureText: isPasswordHidden,
                      suffix: IconButton(
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                      ),
                      validator: (v) =>
                      v == null || v.length < 6 ? "Invalid password" : null,
                    ),

                    const SizedBox(height: 22),

                    // ================= LOGIN BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: isLoading ? null : login,
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =============================
  // DARK INPUT FIELD
  // =============================
  Widget _darkField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kGrey),
        prefixIcon: Icon(icon, color: kGrey),
        suffixIcon: suffix,
        filled: true,
        fillColor: kBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
