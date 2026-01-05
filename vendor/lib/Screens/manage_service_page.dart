import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/service_categories.dart';
import '../models/service.dart';
import '../models/create_service_request.dart';
import '../services/service_api.dart';

class ManageServicePage extends StatefulWidget {
  final Service service;

  const ManageServicePage({
    super.key,
    required this.service,
  });

  @override
  State<ManageServicePage> createState() => _ManageServicePageState();
}

class _ManageServicePageState extends State<ManageServicePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController priceController;

  String? selectedCategory;
  File? selectedImage;

  bool isLoading = false;
  bool isDeleting = false;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.service.title);
    priceController =
        TextEditingController(text: widget.service.price.toString());

    selectedCategory = serviceCategories.contains(widget.service.category)
        ? widget.service.category
        : null;
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    super.dispose();
  }

  // =============================
  // IMAGE PICKER
  // =============================
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  // =============================
  // UPDATE SERVICE
  // =============================
  Future<void> updateService() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null) return;

    FocusScope.of(context).unfocus();

    setState(() => isLoading = true);

    final request = CreateServiceRequest(
      serviceName: titleController.text.trim(),
      category: selectedCategory!,
      price: double.parse(priceController.text),
      serviceDateTime: widget.service.serviceDateTime,
    );

    final success = await ServiceApi.updateService(
      widget.service.id,
      request,
      selectedImage,
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Service updated successfully"
              : "Failed to update service",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      await Future.delayed(const Duration(milliseconds: 300));
      Navigator.pop(context, true);
    }
  }

  // =============================
  // DELETE SERVICE
  // =============================
  Future<void> deleteService() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Service"),
        content: const Text(
          "Are you sure you want to delete this service?\n\nThis action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isDeleting = true);

    final success = await ServiceApi.deleteService(widget.service.id);

    if (!mounted) return;

    setState(() => isDeleting = false);

    if (success) {
      Navigator.pop(context, true);
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
              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: selectedImage != null
                    ? Image.file(
                  selectedImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  widget.service.imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 40),
                ),
              ),

              TextButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Change Image"),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Service Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: serviceCategories
                    .map(
                      (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ),
                )
                    .toList(),
                onChanged: (v) => setState(() => selectedCategory = v),
                validator: (v) => v == null ? "Select category" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
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

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: isDeleting ? null : deleteService,
                  child: isDeleting
                      ? const CircularProgressIndicator()
                      : const Text("Delete Service"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
