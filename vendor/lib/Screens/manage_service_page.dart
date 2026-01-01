import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/service.dart';
import '../Models/service_request.dart';
import '../services/service_api.dart';

class ManageServicePage extends StatefulWidget {
  final Service service;

  const ManageServicePage({super.key, required this.service});

  @override
  State<ManageServicePage> createState() => _ManageServicePageState();
}

class _ManageServicePageState extends State<ManageServicePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController categoryController;

  bool isLoading = false;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.service.title);
    priceController =
        TextEditingController(text: widget.service.price.toString());
    categoryController =
        TextEditingController(text: widget.service.category);
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  // =============================
  // PICK IMAGE
  // =============================
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  // =============================
  // UPDATE SERVICE (API + IMAGE)
  // =============================
  Future<void> updateService() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final updatedService = ServiceRequest(
      id: widget.service.id,
      serviceName: titleController.text.trim(),
      category: categoryController.text.trim(),
      price: double.parse(priceController.text),
      description: null,
      imageUrl: null,
    );

    final success = await ServiceApi.updateService(
      widget.service.id,
      updatedService,
      selectedImage, // 🔥 image optional
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Service updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true); // 🔥 refresh Home tab
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update service"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =============================
  // UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Service")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // IMAGE PREVIEW
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: selectedImage != null
                    ? Image.file(
                  selectedImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : widget.service.imagePath.startsWith("http")
                    ? Image.network(
                  widget.service.imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  widget.service.imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 12),

              // CHANGE IMAGE BUTTON
              OutlinedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Change Image"),
              ),

              const SizedBox(height: 20),

              // SERVICE NAME
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Service Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 12),

              // CATEGORY
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 12),

              // PRICE
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updateService,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
