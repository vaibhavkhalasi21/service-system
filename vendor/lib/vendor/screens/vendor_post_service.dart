import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/vendor_create_service_request.dart';
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

  // 📍 LOCATION
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  String? selectedCategory;
  DateTime? selectedServiceDateTime;

  bool isLoading = false;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  final List<String> categories = [
    "Cleaning",
    "Plumber",
    "Electrician",
    "AC Repair",
    "Painter",
  ];

  // =======================
  // CATEGORY → ENUM
  // =======================
  int mapCategoryToEnum(String category) {
    switch (category.trim().toLowerCase()) {
      case "cleaning":
        return 1;
      case "plumber":
        return 2;
      case "electrician":
        return 3;
      case "ac repair":
        return 4;
      case "painter":
        return 5;
      default:
        throw Exception("Invalid category: $category");
    }
  }


  // =======================
  // IMAGE PICKER
  // =======================
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  // =======================
  // DATE & TIME PICKER
  // =======================
  Future<void> pickServiceDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time = await showTimePicker(
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

  // =======================
  // SUBMIT SERVICE
  // =======================
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

    if (selectedImage == null) {
      _showSnack("Please select an image");
      return;
    }

    setState(() => isLoading = true);

    final service = VendorCreateServiceRequest(
      serviceName: _titleController.text.trim(),
      category: mapCategoryToEnum(selectedCategory!),
      price: double.parse(_priceController.text),
      serviceDateTime: selectedServiceDateTime!,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      latitude: double.parse(_latController.text),
      longitude: double.parse(_lngController.text),
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
    final scheduledText = selectedServiceDateTime == null
        ? "Select service date & time"
        : DateFormat('dd MMM yyyy • hh:mm a')
        .format(selectedServiceDateTime!);

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        centerTitle: true,
        title: const Text("Post New Service"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _darkField(_titleController, "Service Name"),
              _dropdownCategory(),
              _darkField(_priceController, "Price (₹)",
                  keyboard: TextInputType.number),

              OutlinedButton.icon(
                onPressed: pickServiceDateTime,
                icon: const Icon(Icons.schedule),
                label: Text(scheduledText),
              ),

              _darkField(_addressController, "Service Address"),
              _darkField(_latController, "Latitude",
                  keyboard: TextInputType.number),
              _darkField(_lngController, "Longitude",
                  keyboard: TextInputType.number),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Select Image"),
              ),

              if (selectedImage != null) ...[
                const SizedBox(height: 12),
                Image.file(selectedImage!, height: 160, fit: BoxFit.cover),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isLoading ? null : publishService,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Publish Service"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownCategory() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      dropdownColor: kCard,
      decoration: _inputDecoration("Category"),
      items: categories
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (v) => setState(() => selectedCategory = v),
      validator: (v) => v == null ? "Required" : null,
    );
  }

  Widget _darkField(
      TextEditingController controller,
      String label, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(label),
      ),
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
