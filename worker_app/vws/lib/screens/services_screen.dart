import 'package:flutter/material.dart';

// Dummy Job Model
class MyJob {
  final String title;
  final String category;
  final String date;
  final String location;
  final String price;
  final String status;

  MyJob(this.title, this.category, this.date, this.location, this.price,
      this.status);
}

class ServicesScreen extends StatefulWidget {
  final TickerProvider vsync; // ✅ pass from BottomNav
  const ServicesScreen({super.key, required this.vsync});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<MyJob> myJobs = [
    MyJob("Office Furniture Assembly", "Carpentry", "Dec 28, 2025",
        "Surat", "90", "Pending"),
    MyJob("AC Repair", "HVAC", "Dec 27, 2025", "Ahmedabad", "110", "Pending"),
    MyJob("Wiring Work", "Electrician", "Dec 20, 2025", "Vadodara", "300",
        "Completed"),
    MyJob("Fan Fix", "Electrician", "Dec 21, 2025", "Surat", "50", "Cancelled"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: widget.vsync);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MyJob> getJobs(String status) {
    return myJobs.where((job) => job.status == status).toList();
  }

  Widget _jobList(List<MyJob> jobs) {
    if (jobs.isEmpty) {
      return const Center(
        child: Text("No jobs found", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        Color statusColor = job.status == "Completed"
            ? Colors.green
            : job.status == "Cancelled"
            ? Colors.red
            : Colors.orange;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
          child: ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(job.title,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text("${job.category} • ${job.date}"),
            trailing: Text(
              job.status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("My Services", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SafeArea(
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(icon: Icon(Icons.access_time), text: "Pending"),
                Tab(icon: Icon(Icons.check_circle_outline), text: "Complete"),
                Tab(icon: Icon(Icons.cancel_outlined), text: "Cancel"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _jobList(getJobs("Pending")),
          _jobList(getJobs("Completed")),
          _jobList(getJobs("Cancelled")),
        ],
      ),
    );
  }
}
