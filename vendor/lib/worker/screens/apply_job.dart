import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/worker_service_api.dart';
import '../sessions/worker_session.dart';

class ApplyJobScreen extends StatefulWidget {
  final int serviceId;
  final double serviceLatitude;
  final double serviceLongitude;
  final String serviceAddress;

  const ApplyJobScreen({
    super.key,
    required this.serviceId,
    required this.serviceLatitude,
    required this.serviceLongitude,
    required this.serviceAddress,
  });

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController experienceCtrl = TextEditingController();

  String jobType = "Full Time";
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    // ✅ AUTO FILL FROM WORKER SESSION
    final worker = WorkerSession.currentWorker;
    if (worker != null) {
      nameCtrl.text = worker.name;
      emailCtrl.text = worker.email;
      phoneCtrl.text = worker.phone;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    experienceCtrl.dispose();
    super.dispose();
  }

  // ===============================
  // 🔥 SUBMIT APPLICATION (LOCATION BASED)
  // ===============================
  Future<void> submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // 🔥 1. Get CURRENT worker location
      final position = await LocationService.getCurrentLocation();

      if (position == null) {
        throw Exception("Location permission required to apply");
      }

      // 🔥 2. Send location with application
      final success =
      await WorkerServiceApi.applyForServiceWithLocation(
        serviceId: widget.serviceId,
        serviceLatitude: widget.serviceLatitude,
        serviceLongitude: widget.serviceLongitude,
        serviceAddress: widget.serviceAddress,

        // 🔥 NEW (IMPORTANT)
        workerLatitude: position.latitude,
        workerLongitude: position.longitude,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? "Applied successfully ✅" : "Already applied",
          ),
          backgroundColor:
          success ? Colors.greenAccent : Colors.orangeAccent,
        ),
      );

      if (success) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F0F0F),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Apply Job",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 TITLE
              const Text(
                "Job Application",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              _inputField(
                controller: nameCtrl,
                label: "Full Name",
                icon: Icons.person,
                validator: (v) =>
                v == null || v.isEmpty ? "Name is required" : null,
              ),

              _inputField(
                controller: emailCtrl,
                label: "Email",
                icon: Icons.email,
                keyboard: TextInputType.emailAddress,
                validator: (v) =>
                v != null && v.contains("@")
                    ? null
                    : "Enter valid email",
              ),

              _inputField(
                controller: phoneCtrl,
                label: "Phone Number",
                icon: Icons.phone,
                keyboard: TextInputType.phone,
                validator: (v) =>
                v != null && v.length >= 10
                    ? null
                    : "Enter valid phone number",
              ),

              _inputField(
                controller: experienceCtrl,
                label: "Experience (optional)",
                icon: Icons.work,
              ),

              const SizedBox(height: 30),

              // 🔘 SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7C3AED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Submit Application",
                    style: TextStyle(
                      color: Colors.white,
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

  // ===============================
  // 🔹 INPUT FIELD (DARK THEME)
  // ===============================
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
}
