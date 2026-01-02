import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:vws/screens/worker_api.dart';

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

  final List<String> categories = [
    "Plumber",
    "Electrician",
    "AC Repairer",
    "Cleaning",
    "Painter",
  ];

  bool isPasswordHidden = true;
  bool isLoading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select category"),
          backgroundColor: Colors.red,
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registered successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  bool _isValidEmail(String email) =>
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);

  bool _isValidPassword(String password) =>
      RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{6,}$").hasMatch(password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("Worker Registration", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: inputStyle("Full Name", Icons.person),
                      validator: (v) => v!.isEmpty ? "Enter name" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailCtrl,
                      decoration: inputStyle("Email", Icons.email),
                      validator: (v) => !_isValidEmail(v!) ? "Enter valid email" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneCtrl,
                      decoration: inputStyle("Phone", Icons.phone),
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.length != 10 ? "Enter valid phone" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: isPasswordHidden,
                      decoration: inputStyle("Password", Icons.lock).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => isPasswordHidden = !isPasswordHidden),
                        ),
                      ),
                      validator: (v) => !_isValidPassword(v!) ? "Min 6 chars with letters & numbers" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: addressCtrl,
                      decoration: inputStyle("Address", Icons.location_on),
                      validator: (v) => v!.isEmpty ? "Enter address" : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: inputStyle("Category", Icons.work),
                      items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => selectedCategory = v),
                      validator: (v) => v == null ? "Select category" : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : register,
                        child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Register"),
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
}
