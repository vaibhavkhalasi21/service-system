import 'package:flutter/material.dart';

import '../models/job_model.dart';
import '../widgets/job_card.dart';

class JobList extends StatelessWidget {
  final List<MyJob> jobs;

  const JobList(this.jobs, {super.key});

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return const Center(
        child: Text(
          "No jobs found",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),

      // ✅ prevents scroll conflicts
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),

      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];

        return JobCard(
          title: job.title,

          // ✅ category already STRING (correct)
          category: job.category,

          description: job.description,

          imageUrl: job.imageUrl.isNotEmpty
              ? job.imageUrl
              : "https://via.placeholder.com/150",

          price: job.price,
          vendorName: job.vendorName,
          createdAt: job.createdAt,
          serviceDateTime: job.serviceDateTime,
          address: job.address,

          onApply: () {
            // 🔥 you can navigate later
          },
        );
      },
    );
  }
}
