import 'package:flutter/material.dart';
import '../services/worker_service_api.dart';
import '../sessions/worker_session.dart';

class ApplyJobScreen extends StatefulWidget {
  final int serviceId;

  const ApplyJobScreen({super.key, required this.serviceId});

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

    /// ✅ AUTO FILL FROM WORKER SESSION
    final worker = WorkerSession.currentWorker;
    if (worker != null) {
      nameCtrl.text = worker.name;
      emailCtrl.text = worker.email;
      phoneCtrl.text = worker.phone;
    }
  }

  Future<void> submitApplication() async {
    setState(() => isLoading = true);

    try {
      final success =
      await WorkerServiceApi.applyForService(widget.serviceId);

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
        SnackBar(content: Text(e.toString())),
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

              /// 🔥 TITLE
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
                v!.isEmpty ? "Name is required" : null,
              ),

              _inputField(
                controller: emailCtrl,
                label: "Email",
                icon: Icons.email,
                keyboard: TextInputType.emailAddress,
                validator: (v) =>
                v!.contains("@") ? null : "Enter valid email",
              ),

              _inputField(
                controller: phoneCtrl,
                label: "Phone Number",
                icon: Icons.phone,
                keyboard: TextInputType.phone,
                validator: (v) =>
                v!.length < 10 ? "Enter valid phone" : null,
              ),

              if (errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),

              const SizedBox(height: 30),

              /// 🔘 SUBMIT BUTTON
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

  /// 🔹 INPUT FIELD (DARK STYLE)
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
