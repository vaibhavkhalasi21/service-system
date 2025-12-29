import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final VoidCallback onApply; // 👈 CONNECT POINT

  const JobCard({
    super.key,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(category,
                    style: const TextStyle(color: Colors.blue)),
                const SizedBox(height: 10),
                Text(description,
                    style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 16),

                /// APPLY BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onApply, // 👈 EXISTING CODE CALL
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Apply Job",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
