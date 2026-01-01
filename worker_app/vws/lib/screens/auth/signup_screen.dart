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


  bool isPasswordHidden = true;
  bool isLoading = false;

  String? selectedCategory;
  final List<String> categories = [
    "Plumber",
    "Electrician",
    "Carpenter",
    "Cleaner",
    "Painter",
  ];

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }


  bool _isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{6,}$").hasMatch(password);
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select category"),
          backgroundColor: Colors.red,
        ),
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
      skill: selectedCategory!,
      address: addressCtrl.text.trim(),
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (error == null) {
      // ✅ SUCCESS
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Worker Registered Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      // ❌ REAL BACKEND ERROR
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              elevation: 12,
              shadowColor: Colors.black45,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Worker Registration",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Create your account to get started",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      const SizedBox(height: 24),

                      // NAME
                      TextFormField(
                        controller: nameCtrl,
                        decoration: inputStyle("Full Name", Icons.person),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Enter your name";
                          if (v.trim().length < 3) return "Name must be at least 3 characters";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // EMAIL
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputStyle("Email", Icons.email),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Enter email";
                          if (!_isValidEmail(v.trim())) return "Enter valid email";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // PHONE
                      TextFormField(
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: inputStyle("Phone", Icons.phone).copyWith(
                          counterText: "",
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Enter phone number";
                          }
                          if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) {
                            return "Enter valid Indian phone number";
                          }
                          return null;
                        },

                      ),
                      const SizedBox(height: 16),

                      // PASSWORD
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: isPasswordHidden,
                        decoration: inputStyle("Password", Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                                isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                                color: Colors.deepPurple),
                            onPressed: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Enter password";
                          if (!_isValidPassword(v)) return "Password must contain letters & numbers";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // ADDRESS
                      TextFormField(
                        controller: addressCtrl,
                        decoration: inputStyle("Address", Icons.location_on),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Enter address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // CATEGORY
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: inputStyle("Category", Icons.work),
                        items: categories
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            selectedCategory = v;
                          });
                        },
                        validator: (v) => v == null ? "Select category" : null,
                      ),
                      const SizedBox(height: 24),

                      // REGISTER BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.deepPurple),
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
