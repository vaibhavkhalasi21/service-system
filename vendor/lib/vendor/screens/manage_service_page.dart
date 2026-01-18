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

  const ManageServicePage({super.key, required this.service});

  @override
  State<ManageServicePage> createState() => _ManageServicePageState();
}

class _ManageServicePageState extends State<ManageServicePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController latCtrl;
  late TextEditingController lngCtrl;

  String? selectedCategory;
  DateTime? selectedDateTime;

  File? selectedImage;
  bool isLoading = false;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.service.title);
    priceCtrl = TextEditingController(text: widget.service.price.toString());
    addressCtrl = TextEditingController(text: widget.service.address ?? "");
    latCtrl = TextEditingController(text: widget.service.latitude.toString());
    lngCtrl = TextEditingController(text: widget.service.longitude.toString());

    selectedDateTime = widget.service.serviceDateTime;

    // 🔥 SAFE CATEGORY INIT (OLD DATA PROTECTED)
    final mapped = mapEnumToCategory(widget.service.category);
    selectedCategory =
    serviceCategories.contains(mapped) ? mapped : null;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    addressCtrl.dispose();
    latCtrl.dispose();
    lngCtrl.dispose();
    super.dispose();
  }

  // ================= IMAGE PICK =================
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  // ================= DATE & TIME =================
  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime:
      TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
    );

    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  // ================= UPDATE =================
  Future<void> updateService() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      _snack("Please select a valid category");
      return;
    }

    if (selectedDateTime == null) {
      _snack("Please select date & time");
      return;
    }

    setState(() => isLoading = true);

    final req = VendorCreateServiceRequest(
      serviceName: nameCtrl.text.trim(),
      category: mapCategoryToEnum(selectedCategory!),
      price: double.parse(priceCtrl.text),
      serviceDateTime: selectedDateTime!,
      address: addressCtrl.text.trim(),
      latitude: double.parse(latCtrl.text),
      longitude: double.parse(lngCtrl.text),
    );

    final ok = await ServiceApi.updateService(
      widget.service.id,
      req,
      selectedImage,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    _snack(ok ? "Service updated successfully" : "Update failed",
        success: ok);

    if (ok) Navigator.pop(context, true);
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final dateText = selectedDateTime == null
        ? "Select date & time"
        : DateFormat('dd MMM yyyy • hh:mm a')
        .format(selectedDateTime!);

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        title: const Text("Manage Service"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // IMAGE
              GestureDetector(
                onTap: pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: selectedImage != null
                      ? Image.file(
                    selectedImage!,
                    height: 180,
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    widget.service.imagePath,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _field(nameCtrl, "Service Name"),
              _dropdown(),
              _field(
                priceCtrl,
                "Price (₹)",
                keyboard: TextInputType.number,
              ),

              const SizedBox(height: 10),

              OutlinedButton.icon(
                onPressed: pickDateTime,
                icon: const Icon(Icons.schedule),
                label: Text(dateText),
              ),

              const SizedBox(height: 12),

              _field(addressCtrl, "Address"),
              _field(latCtrl, "Latitude",
                  keyboard: TextInputType.number),
              _field(lngCtrl, "Longitude",
                  keyboard: TextInputType.number),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isLoading ? null : updateService,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Update Service"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _field(
      TextEditingController c,
      String label, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: kGrey),
          filled: true,
          fillColor: kCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        items: serviceCategories
            .map(
              (c) => DropdownMenuItem(
            value: c,
            child: Text(c,
                style: const TextStyle(color: Colors.white)),
          ),
        )
            .toList(),
        onChanged: (v) => setState(() => selectedCategory = v),
        validator: (v) => v == null ? "Select category" : null,
        dropdownColor: kCard,
        decoration: InputDecoration(
          labelText: "Service Category",
          labelStyle: const TextStyle(color: kGrey),
          filled: true,
          fillColor: kCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
