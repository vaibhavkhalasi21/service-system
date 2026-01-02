import 'package:flutter/material.dart';
import 'package:vws/model/job_model.dart';
import 'package:vws/widget/job_card.dart';

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
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];

        return JobCard(
          title: job.title,
          category: job.category,
          description: "Date: ${job.date}\nLocation: ${job.location}",
          imageUrl: job.imageUrl.isNotEmpty == true
              ? job.imageUrl
              : "https://via.placeholder.com/150",
          price: job.price ?? 0,
          rating: job.rating ?? 4.0,
          onApply: () {
            // navigate to apply job screen
          },
        );
      },
    );
  }
}
