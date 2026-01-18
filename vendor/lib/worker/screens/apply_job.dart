import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/worker_service_api.dart';
import '../sessions/worker_session.dart';

class ApplyJobScreen extends StatefulWidget {
  final int serviceId;

  const ApplyJobScreen({
    super.key,
    required this.serviceId,
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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

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

  // ================= APPLY =================
  Future<void> submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final position = await LocationService.getCurrentLocation();
      if (position == null) {
        throw Exception("Location permission required");
      }

      final success =
      await WorkerServiceApi.applyForServiceWithLocation(
        serviceId: widget.serviceId,
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
          success ? Colors.green : Colors.orange,
        ),
      );

      if (success) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
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
        centerTitle: true,
        title: const Text("Apply Job"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _input(nameCtrl, "Full Name", Icons.person),
              _input(emailCtrl, "Email", Icons.email),
              _input(phoneCtrl, "Phone", Icons.phone),
              _input(experienceCtrl, "Experience (optional)", Icons.work),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitApplication,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Submit Application"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
      TextEditingController ctrl,
      String label,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: const Color(0xff1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
