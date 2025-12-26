import 'package:flutter/material.dart';

class VendorJobsTab extends StatelessWidget {
  const VendorJobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text("Post New Service"),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Post Service Clicked")),
          );
        },
      ),
    );
  }
}
