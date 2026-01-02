import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/create_service_request.dart';
import '../services/service_api.dart';

class PostServicePage extends StatefulWidget {
  const PostServicePage({super.key});

  @override
  State<PostServicePage> createState() => _PostServicePageState();
}

class _PostServicePageState extends State<PostServicePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? selectedCategory;
  bool isLoading = false;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  final List<String> categories = [
    "Cleaning",
    "Plumbing",
    "Electrician",
    "AC Repair",
    "Painter",
  ];

  // =====================
  // IMAGE PICKER
  // =====================
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  // =====================
  // SUBMIT SERVICE
  // =====================
  Future<void> publishService() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
      );
      return;
    }

    setState(() => isLoading = true);

    final service = CreateServiceRequest(
      serviceName: _titleController.text.trim(),
      category: selectedCategory!,
      price: double.parse(_priceController.text),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    final success = await ServiceApi.addService(service, selectedImage);

    setState(() => isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Service published successfully"
              : "Failed to publish service",
        ),
      ),
    );

    if (success) Navigator.pop(context, true);
  }

  // =====================
  // UI
  // =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post New Service"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Service Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // SERVICE NAME
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Service Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 16),

              // CATEGORY
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map(
                      (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ),
                )
                    .toList(),
                onChanged: (v) => setState(() => selectedCategory = v),
                validator: (v) => v == null ? "Required" : null,
              ),

              const SizedBox(height: 16),

              // PRICE
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price (₹)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 16),

              // DESCRIPTION
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description (optional)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // IMAGE PICKER
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Select Image"),
                  ),
                  const SizedBox(width: 12),
                  if (selectedImage != null)
                    const Text(
                      "Image selected",
                      style: TextStyle(color: Colors.green),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              if (selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    selectedImage!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 24),

              // SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : publishService,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Publish Service"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
