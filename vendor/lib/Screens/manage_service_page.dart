import 'package:flutter/material.dart';
import '../models/service.dart';

class ManageServicePage extends StatefulWidget {
  final Service service;

  const ManageServicePage({super.key, required this.service});

  @override
  State<ManageServicePage> createState() => _ManageServicePageState();
}

class _ManageServicePageState extends State<ManageServicePage> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.service.title);
    priceController =
        TextEditingController(text: widget.service.price.toString());
    categoryController =
        TextEditingController(text: widget.service.category);
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void saveService() {
    setState(() {
      widget.service.title = titleController.text;
      widget.service.price = int.parse(priceController.text);
      widget.service.category = categoryController.text;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Service")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Service Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveService,
                child: const Text("Save Changes"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
