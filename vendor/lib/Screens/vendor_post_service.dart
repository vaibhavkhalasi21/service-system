import 'package:flutter/material.dart';
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

  final List<String> categories = [
    "Cleaning",
    "Plumbing",
    "Electrician",
    "Painting",
    "Carpentry",
  ];

  Future<void> publishService() async {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final service = ServiceRequest(
      serviceName: _titleController.text,
      price: double.parse(_priceController.text),
    );

    final success = await ServiceApi.addService(service);

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service Published Successfully")),
      );
      Navigator.pop(context, true); // return success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to publish service")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Post New Service"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SERVICE TITLE
            const Text(
              "Service Title",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "e.g., Deep House Cleaning",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// CATEGORY
            const Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCategory.isEmpty ? null : selectedCategory,
              items: categories
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() => selectedCategory = value!);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// DESCRIPTION (UI only)
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Describe your service...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// PRICE
            const Text(
              "Price",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter price",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            /// PUBLISH BUTTON
            SizedBox(
              width: double.infinity,
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
    );
  }
}
