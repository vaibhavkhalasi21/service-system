import 'package:flutter/material.dart';
import 'package:vws/sessions/worker_session.dart';
import 'package:vws/model/worker_model.dart';

class EditWorkerProfile extends StatefulWidget {
  const EditWorkerProfile({super.key});

  @override
  State<EditWorkerProfile> createState() => _EditWorkerProfileState();
}

class _EditWorkerProfileState extends State<EditWorkerProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  Worker? worker;

  @override
  void initState() {
    super.initState();
    worker = WorkerSession.currentWorker;
    nameController = TextEditingController(text: worker?.name ?? "");
  }

  @override
  Widget build(BuildContext context) {
    if (worker == null) {
      return const Scaffold(
        body: Center(child: Text("Worker not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Name"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v!.isEmpty ? "Enter email" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveName,
                  child: const Text("SAVE NAME"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveName() async {
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

    Worker updatedWorker = Worker(
      id: worker!.id,
      name: nameController.text.trim(),
      email: worker!.email,
      phone: worker!.phone,
      skill: worker!.skill,
      address: worker!.address,
    );

    await WorkerSession.saveWorker(updatedWorker, token);

    Navigator.pop(context); // go back to profile
  }
}
