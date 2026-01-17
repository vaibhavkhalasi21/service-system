import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  late TextEditingController addressController;
  late TextEditingController latController;
  late TextEditingController lngController;

  String? selectedCategory; // 🔹 UI string
  DateTime? selectedServiceDateTime;

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

    addressController =
        TextEditingController(text: widget.service.address ?? "");
    latController =
        TextEditingController(text: widget.service.latitude.toString());
    lngController =
        TextEditingController(text: widget.service.longitude.toString());

    selectedServiceDateTime = widget.service.serviceDateTime;

    // 🔥 ENUM → STRING (IMPORTANT)
    selectedCategory = mapEnumToCategory(widget.service.category);
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    addressController.dispose();
    latController.dispose();
    lngController.dispose();
    super.dispose();
  }

  // ================= IMAGE PICKER =================
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  // ================= DATE & TIME =================
  Future<void> pickServiceDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: selectedServiceDateTime ?? DateTime.now(),
    );

    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime:
      TimeOfDay.fromDateTime(selectedServiceDateTime ?? DateTime.now()),
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

  // ================= UPDATE SERVICE =================
  Future<void> updateService() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCategory == null || selectedServiceDateTime == null) return;

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    final request = VendorCreateServiceRequest(
      serviceName: titleController.text.trim(),

      // 🔥 STRING → ENUM INT (MAIN FIX)
      category: mapCategoryToEnum(selectedCategory!),

      price: double.parse(priceController.text),
      serviceDateTime: selectedServiceDateTime!,
      address: addressController.text.trim(),
      latitude: double.parse(latController.text),
      longitude: double.parse(lngController.text),
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

  // ================= DELETE SERVICE =================
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

    if (success) Navigator.pop(context, true);
  }

  // ================= UI =================
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: selectedImage != null
                    ? Image.file(selectedImage!, height: 180, fit: BoxFit.cover)
                    : Image.network(
                  widget.service.imagePath,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: serviceCategories
                    .map((c) =>
                    DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => selectedCategory = v),
                validator: (v) => v == null ? "Select category" : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
