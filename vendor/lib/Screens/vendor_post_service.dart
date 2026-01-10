import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/create_service_request.dart';
import '../services/service_api.dart';

// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kCard = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

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

  DateTime? selectedServiceDateTime;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  final List<String> categories = [
    "Cleaning",
    "Plumber",
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
  // DATE & TIME PICKER
  // =====================
  Future<void> pickServiceDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      selectedServiceDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  // =====================
  // SUBMIT SERVICE
  // =====================
  Future<void> publishService() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      _showSnack("Please select a category");
      return;
    }

    if (selectedServiceDateTime == null) {
      _showSnack("Please select service date & time");
      return;
    }

    setState(() => isLoading = true);

    final service = CreateServiceRequest(
      serviceName: _titleController.text.trim(),
      category: selectedCategory!,
      price: double.parse(_priceController.text),
      serviceDateTime: selectedServiceDateTime!,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    final success = await ServiceApi.addService(service, selectedImage);

    setState(() => isLoading = false);

    if (!mounted) return;

    _showSnack(
      success ? "Service published successfully" : "Failed to publish service",
    );

    if (success) Navigator.pop(context, true);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final String scheduledText = selectedServiceDateTime == null
        ? "Select service date & time"
        : DateFormat('dd MMM yyyy • hh:mm a')
        .format(selectedServiceDateTime!);

    return Scaffold(
      backgroundColor: kBg,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Post New Service",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Service Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _darkField(
                controller: _titleController,
                label: "Service Name",
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                dropdownColor: kCard,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Category"),
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

              _darkField(
                controller: _priceController,
                label: "Price (₹)",
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPurple,
                  side: const BorderSide(color: kPurple),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: pickServiceDateTime,
                icon: const Icon(Icons.schedule),
                label: Text(scheduledText),
              ),

              const SizedBox(height: 16),

              _darkField(
                controller: _descriptionController,
                label: "Description (optional)",
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
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

              if (selectedImage != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    selectedImage!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],

              const SizedBox(height: 28),

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
                  onPressed: isLoading ? null : publishService,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Publish Service",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================
  // REUSABLE DARK FIELD
  // ===============================
  Widget _darkField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
