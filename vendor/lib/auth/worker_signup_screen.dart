import 'package:flutter/material.dart';
import '../worker/services/worker_api.dart';
import 'worker_login_screen.dart';

// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kCard = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

class WorkerRegisterScreen extends StatefulWidget {
  const WorkerRegisterScreen({super.key});

  @override
  State<WorkerRegisterScreen> createState() => _WorkerRegisterScreenState();
}

class _WorkerRegisterScreenState extends State<WorkerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  int? selectedCategory; // 🔥 ENUM NUMBER
  bool isPasswordHidden = true;
  bool isLoading = false;

  // 🔐 Backend enum mapping
  final Map<int, String> categories = {
    1: "Cleaning",
    2: "Plumber",
    3: "Electrician",
    4: "AC Repair",
    5: "Painter",
  };

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) =>
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email);

  bool _isValidPassword(String password) =>
      RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{6,}$").hasMatch(password);

  // =============================
  // REGISTER
  // =============================
  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select category")),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    final error = await WorkerApi.signupWorker(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      category: selectedCategory!, // ✅ ENUM NUMBER
      address: addressCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
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
                    // ================= ICON =================
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPurple.withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: kPurple,
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Worker Registration",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Create your worker account",
                      style: TextStyle(
                        color: kGrey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _darkField(
                      controller: nameCtrl,
                      label: "Full Name",
                      icon: Icons.person,
                      validator: (v) =>
                      v == null || v.isEmpty ? "Enter name" : null,
                    ),

                    const SizedBox(height: 14),

                    _darkField(
                      controller: emailCtrl,
                      label: "Email",
                      icon: Icons.email,
                      validator: (v) =>
                      v == null || !_isValidEmail(v)
                          ? "Enter valid email"
                          : null,
                    ),

                    const SizedBox(height: 14),

                    _darkField(
                      controller: phoneCtrl,
                      label: "Phone",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                      v == null || v.length != 10
                          ? "Enter valid phone"
                          : null,
                    ),

                    const SizedBox(height: 14),

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
                      v == null || !_isValidPassword(v)
                          ? "Min 6 chars, letters & numbers"
                          : null,
                    ),

                    const SizedBox(height: 14),

                    _darkField(
                      controller: addressCtrl,
                      label: "Address",
                      icon: Icons.location_on,
                      validator: (v) =>
                      v == null || v.isEmpty ? "Enter address" : null,
                    ),

                    const SizedBox(height: 14),

                    // ================= CATEGORY DROPDOWN =================
                    DropdownButtonFormField<int>(
                      value: selectedCategory,
                      dropdownColor: kCard,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                      _inputDecoration("Category", Icons.work),
                      items: categories.entries
                          .map(
                            (e) => DropdownMenuItem<int>(
                          value: e.key,
                          child: Text(e.value),
                        ),
                      )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => selectedCategory = v),
                      validator: (v) =>
                      v == null ? "Select category" : null,
                    ),

                    const SizedBox(height: 22),

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
                        onPressed: isLoading ? null : register,
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: kGrey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: kPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
  // DARK FIELD
  // =============================
  Widget _darkField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: _inputDecoration(label, icon).copyWith(
        suffixIcon: suffix,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kGrey),
      prefixIcon: Icon(icon, color: kGrey),
      filled: true,
      fillColor: kBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
