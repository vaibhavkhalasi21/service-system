import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/vendor_api.dart';
import 'vendor_login.dart';

class VendorRegisterScreen extends StatefulWidget {
  const VendorRegisterScreen({super.key});

  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool isPasswordHidden = true;
  bool isLoading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) =>
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email);

  bool _isValidPassword(String password) =>
      RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{6,}$").hasMatch(password);

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final response = await VendorApi.registerVendor(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      serviceType: "Vendor",
      address: "NA",
    );

    setState(() => isLoading = false);

    if (response["status"] == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("vendor_name", nameCtrl.text.trim());
      await prefs.setString("vendor_email", emailCtrl.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vendor Registered Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VendorLoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["body"].toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff11998E), Color(0xff38EF7D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Vendor Registration",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: "Vendor Name",
                          prefixIcon: Icon(Icons.store),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter vendor name";
                          }
                          if (value.trim().length < 3) {
                            return "Name must be at least 3 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Enter email";
                          }
                          if (!_isValidEmail(value.trim())) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          labelText: "Phone",
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                          counterText: "",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length != 10) {
                            return "Phone must be 10 digits";
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter password";
                          }
                          if (!_isValidPassword(value)) {
                            return "Password must contain letters & numbers";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : register,
                          child: isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text("Register"),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const VendorLoginScreen()),
                          );
                        },
                        child:
                        const Text("Already have an account? Login"),
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
