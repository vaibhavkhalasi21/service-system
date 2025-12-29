import 'package:flutter/material.dart';
import 'package:vws/model/worker_model.dart';

class EditWorkerProfile extends StatefulWidget {
  final Worker worker;

  const EditWorkerProfile({super.key, required this.worker});

  @override
  State<EditWorkerProfile> createState() => _EditWorkerProfileState();
}

class _EditWorkerProfileState extends State<EditWorkerProfile> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController professionController;
  late TextEditingController experienceController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.worker.name);
    emailController = TextEditingController(text: widget.worker.email);
    phoneController = TextEditingController(text: widget.worker.phone);
    professionController =
        TextEditingController(text: widget.worker.profession);
    experienceController =
        TextEditingController(text: widget.worker.experience);
    locationController =
        TextEditingController(text: widget.worker.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _field("Full Name", nameController),
              _field("Email", emailController),
              _field("Phone", phoneController,
                  keyboardType: TextInputType.phone),
              _field("Profession", professionController),
              _field("Experience", experienceController),
              _field("Location", locationController),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(
                          context,
                          Worker(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            profession: professionController.text,
                            experience: experienceController.text,
                            location: locationController.text,
                          ),
                        );
                      }
                    },
                    child: const Text("SAVE CHANGES"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (v) => v!.isEmpty ? "Enter $label" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
