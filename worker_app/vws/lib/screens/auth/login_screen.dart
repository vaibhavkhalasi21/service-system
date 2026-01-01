import 'package:flutter/material.dart';
import 'package:vws/screens/worker_bottom_nav.dart';
import 'package:vws/screens/worker_api.dart';
import 'package:vws/sessions/worker_session.dart';
import 'package:vws/model/worker_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

  void login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    Map<String, dynamic>? workerData = await WorkerApi.loginWorkerData(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    print("LOGIN RESPONSE: $workerData");

    if (!mounted) return;

    setState(() => _loading = false);

    if (workerData != null) {
      // ✅ SAVE SESSION
      WorkerSession.currentWorker = Worker.fromJson(workerData);

      // ✅ GO TO DASHBOARD
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WorkerBottomNav()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid email or password"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.black45,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Login to continue",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      const SizedBox(height: 24),

                      // EMAIL
                      TextFormField(
                        controller: emailController,
                        decoration: inputStyle("Email", Icons.email),
                        validator: (v) => v!.isEmpty ? "Enter email" : null,
                      ),
                      const SizedBox(height: 16),

                      // PASSWORD
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: inputStyle("Password", Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (v) =>
                        v!.length < 6 ? "Min 6 characters" : null,
                      ),
                      const SizedBox(height: 24),

                      // LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            "LOGIN",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
