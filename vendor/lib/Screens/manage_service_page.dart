import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  bool isLoading = false;
  bool isDeleting = false;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  final List<String> categories = [
    "Cleaning",
    "Plumber",
    "Electrician",
    "AC Repair",
    "Painter",
  ];

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.service.title);
    priceController =
        TextEditingController(text: widget.service.price.toString());
    selectedCategory = widget.service.category;
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

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
      );
      return;
    }

    setState(() => isLoading = true);

    final updatedService = CreateServiceRequest(
      serviceName: titleController.text.trim(),
      category: selectedCategory!,
      price: double.parse(priceController.text),

      // ✅ REQUIRED FIX
      serviceDateTime: widget.service.serviceDateTime,

      description: null,
    );


    final success = await ServiceApi.updateService(
      widget.service.id,
      updatedService,
      selectedImage,
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
      Navigator.pop(context, true); // refresh list
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
  // DELETE SERVICE
  // =============================
  Future<void> deleteService() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Service"),
        content: const Text(
          "Are you sure you want to delete this service?\n\nThis action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isDeleting = true);

    final success = await ServiceApi.deleteService(widget.service.id);

    setState(() => isDeleting = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Service deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // refresh previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to delete service"),
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
      appBar: AppBar(
        title: const Text("Manage Service"),
      ),
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
                    : Image.network(
                  widget.service.imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 40),
                ),
              ),

              const SizedBox(height: 12),

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
                validator: (v) =>
                v == null ? "Select category" : null,
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

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updateService,
                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text("Save Changes"),
                ),
              ),

              const SizedBox(height: 12),

              // DELETE BUTTON
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
