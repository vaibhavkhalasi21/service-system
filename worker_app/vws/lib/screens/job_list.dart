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
          child: Text("No jobs found", style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) => JobCard(
        title: jobs[index].title,
        category: jobs[index].category,
        description: "Date: ${jobs[index].date}, Location: ${jobs[index].location}",
        imageUrl: "https://via.placeholder.com/150", onApply: () {  },
      ),
    );
  }
}
