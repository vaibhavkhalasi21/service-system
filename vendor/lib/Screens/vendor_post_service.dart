import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Models/service_request.dart';
import '../services/service_api.dart';

class PostServicePage extends StatefulWidget {
  const PostServicePage({super.key});

  @override
  State<PostServicePage> createState() => _PostServicePageState();
}

class _PostServicePageState extends State<PostServicePage> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String selectedCategory = "";
  bool isLoading = false;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  final List<String> categories = [
    "Cleaning",
    "Plumbing",
    "Electrician",
    "Painting",
    "Carpentry",
  ];

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  Future<void> publishService() async {
    setState(() => isLoading = true);

    final service = ServiceRequest(
      serviceName: _titleController.text.trim(),
      category: selectedCategory,
      price: double.parse(_priceController.text),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    final success = await ServiceApi.addService(service, selectedImage);

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? "Service Published Successfully"
            : "Failed to publish service"),
      ),
    );

    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Service")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController),
            TextField(controller: _priceController),
            TextField(controller: _descriptionController),

            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Select Image"),
            ),

            ElevatedButton(
              onPressed: isLoading ? null : publishService,
              child: const Text("Publish"),
            ),
          ],
        ),
      ),
    );
  }
}
