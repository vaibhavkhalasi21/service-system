import 'package:flutter/material.dart';

import '../models/worker_model.dart';
import '../sessions/worker_session.dart';

class EditWorkerProfile extends StatefulWidget {
  const EditWorkerProfile({super.key});

  @override
  State<EditWorkerProfile> createState() => _EditWorkerProfileState();
}

class _EditWorkerProfileState extends State<EditWorkerProfile> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;

  Worker? worker;

  @override
  void initState() {
    super.initState();
    worker = WorkerSession.currentWorker;

    nameController = TextEditingController(text: worker?.name ?? "");
    emailController = TextEditingController(text: worker?.email ?? "");
  }

  @override
  Widget build(BuildContext context) {
    if (worker == null) {
      return const Scaffold(
        backgroundColor: Color(0xff0F0F0F),
        body: Center(
          child: Text(
            "Worker not found",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F0F0F),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 TITLE
              const Text(
                "Update Your Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              /// 👤 NAME
              _inputField(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person,
                validator: (v) =>
                v == null || v.isEmpty ? "Enter name" : null,
              ),

              /// 📧 EMAIL
              _inputField(
                controller: emailController,
                label: "Email Address",
                icon: Icons.email,
                keyboard: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Enter email";
                  }
                  if (!v.contains('@')) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),

              const Spacer(),

              /// 🔘 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7C3AED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "SAVE PROFILE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 DARK INPUT FIELD
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white60),
          prefixIcon: Icon(icon, color: Colors.white54),
          filled: true,
          fillColor: const Color(0xff1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    String? token = await WorkerSession.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error: Token not found"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    /// 🔥 UPDATED WORKER (NAME + EMAIL)
    Worker updatedWorker = Worker(
      id: worker!.id,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: worker!.phone,
      skill: worker!.skill,
      address: worker!.address,
    );

    await WorkerSession.saveWorker(updatedWorker, token);

    Navigator.pop(context); // back to profile
  }
}
