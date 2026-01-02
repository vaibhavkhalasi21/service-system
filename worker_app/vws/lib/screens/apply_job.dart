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
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final success =
      await WorkerServiceApi.applyForService(widget.serviceId);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Applied successfully ✅"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          errorMessage = "Failed to apply. Try again.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll("Exception:", "");
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Apply Job"),
        backgroundColor: const Color(0xff2563EB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Job Application",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

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

              const SizedBox(height: 16),

              if (errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Submit Application",
                    style: TextStyle(fontSize: 16),
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
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          filled: true,
        ),
      ),
    );
  }
}
