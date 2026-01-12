import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/vendor_service.dart';
import '../models/vendor_create_service_request.dart';

import '../constants/service_categories.dart';
import '../services/service_api.dart';



// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kCard = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

class ManageServicePage extends StatefulWidget {
  // ✅ FIXED TYPE
  final VendorService service;

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

    final request = VendorCreateServiceRequest(
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
      backgroundColor: kBg,

      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Manage Service",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= IMAGE =================
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
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
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 40,
                      color: kGrey,
                    ),
                  ),
                ),
              ),

              TextButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image, color: kPurple),
                label: const Text(
                  "Change Image",
                  style: TextStyle(color: kPurple),
                ),
              ),

              const SizedBox(height: 16),

              _darkField(
                controller: titleController,
                label: "Service Name",
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                dropdownColor: kCard,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Category"),
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

              const SizedBox(height: 14),

              _darkField(
                controller: priceController,
                label: "Price (₹)",
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 28),

              // ================= SAVE =================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: isLoading ? null : updateService,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Save Changes",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ================= DELETE =================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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

  // =============================
  // REUSABLE DARK FIELD
  // =============================
  Widget _darkField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kGrey),
      filled: true,
      fillColor: kCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
