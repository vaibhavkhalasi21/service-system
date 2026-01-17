import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  bool isSaving = false;

  static const String _host = "172.20.253.37:5244";
  static const String _basePath = "/api";

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
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Update Your Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              /// 👤 NAME (EDITABLE)
              _inputField(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person,
                validator: (v) =>
                v == null || v.isEmpty ? "Enter name" : null,
              ),

              /// 📧 EMAIL (READ ONLY)
              _inputField(
                controller: emailController,
                label: "Email Address",
                icon: Icons.email,
                enabled: false,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7C3AED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
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

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        enabled: enabled,
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

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      final token = await WorkerSession.getToken();
      if (token == null) throw Exception("Token missing");

      final uri = Uri.http(_host, "$_basePath/worker/profile");

      final response = await http.put(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": nameController.text.trim(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Update failed");
      }

      /// ✅ UPDATE LOCAL SESSION
      Worker updatedWorker = worker!.copyWith(
        name: nameController.text.trim(),
      );

      await WorkerSession.saveWorker(updatedWorker, token);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }
}
