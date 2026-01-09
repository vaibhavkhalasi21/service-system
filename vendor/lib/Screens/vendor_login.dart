import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/vendor_api.dart';
import 'vendor_home.dart';

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
  // LOGIN + SESSION
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

        // ✅ SAFE SAVES (NO CRASH)
        await prefs.setInt(
          "vendor_id",
          int.parse(body["userId"].toString()),
        );

        await prefs.setString(
          "vendor_email",
          body["email"] ?? "",
        );

        await prefs.setString(
          "vendor_name",
          body["name"] ?? "Vendor", // 🔥 ADD THIS LINE
        );

        await prefs.setString(
          "role",
          body["role"] ?? "Vendor",
        );


        // ✅ TOKEN ONLY IF EXISTS
        if (body["token"] == null) {
          throw Exception("Login failed: token missing");
        }

        await prefs.setString("vendor_token", body["token"]);


        // 🔍 DEBUG
        print("LOGIN OK");
        print("ID    => ${prefs.getInt("vendor_id")}");
        print("EMAIL => ${prefs.getString("vendor_email")}");
        print("ROLE  => ${prefs.getString("role")}");
        print("TOKEN => ${prefs.getString("vendor_token")}");

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
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6A11CB), Color(0xff2575FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Vendor Login",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? "Enter email" : null,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: isPasswordHidden,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) =>
                        v == null || v.length < 6 ? "Invalid password" : null,
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : login,
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Login"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
