import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:vws/services/worker_api.dart';

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

  String? selectedCategory;
  bool isPasswordHidden = true;
  bool isLoading = false;

  final categories = [
    "Plumber",
    "Electrician",
    "AC Repairer",
    "Cleaning",
    "Painter",
  ];

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xff7C3AED)),
      filled: true,
      fillColor: const Color(0xff1E1E1E),
      labelStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  bool _isValidEmail(String email) =>
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email);

  bool _isValidPassword(String password) =>
      RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{6,}$").hasMatch(password);

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select category")),
      );
      return;
    }

    setState(() => isLoading = true);

    final error = await WorkerApi.signupWorker(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      skill: selectedCategory!,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xff1C1C1C),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Worker Registration",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff7C3AED),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: nameCtrl,
                    decoration: _inputStyle("Full Name", Icons.person),
                    style: const TextStyle(color: Colors.white),
                    validator: (v) => v!.isEmpty ? "Enter name" : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: emailCtrl,
                    decoration: _inputStyle("Email", Icons.email),
                    style: const TextStyle(color: Colors.white),
                    validator: (v) =>
                    !_isValidEmail(v!) ? "Enter valid email" : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: phoneCtrl,
                    decoration: _inputStyle("Phone", Icons.phone),
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    validator: (v) =>
                    v!.length != 10 ? "Enter valid phone" : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: passwordCtrl,
                    obscureText: isPasswordHidden,
                    decoration: _inputStyle("Password", Icons.lock).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white54,
                        ),
                        onPressed: () => setState(
                                () => isPasswordHidden = !isPasswordHidden),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (v) => !_isValidPassword(v!)
                        ? "Min 6 chars with letters & numbers"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: addressCtrl,
                    decoration: _inputStyle("Address", Icons.location_on),
                    style: const TextStyle(color: Colors.white),
                    validator: (v) => v!.isEmpty ? "Enter address" : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: _inputStyle("Category", Icons.work),
                    dropdownColor: const Color(0xff1C1C1C),
                    style: const TextStyle(color: Colors.white),
                    items: categories
                        .map(
                          (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ),
                    )
                        .toList(),
                    onChanged: (v) => setState(() => selectedCategory = v),
                    validator: (v) => v == null ? "Select category" : null,
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff7C3AED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Register",
                          style: TextStyle(fontSize: 16,color: Colors.white,)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ",
                          style: TextStyle(color: Colors.white70)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color(0xff7C3AED),
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
    );
  }
}
