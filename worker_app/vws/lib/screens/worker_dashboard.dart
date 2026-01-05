import 'package:flutter/material.dart';
import '../model/service_model.dart';
import '../services/worker_service_api.dart';
import '../widget/job_card.dart';
import 'apply_job.dart';
import '../sessions/worker_session.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  String selectedCategory = "All";
  List<ServiceModel> allJobs = [];

  final List<String> categories = [
    "All",
    "Plumber",
    "Electrician",
    "Cleaning",
    "AC Repair",
    "Painter",
  ];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    setState(() => isLoading = true);
    try {
      final jobs = await WorkerServiceApi.getServices();
      setState(() {
        allJobs = jobs;
        isLoading = false;
      });
      debugPrint("Fetched ${jobs.length} services");
    } catch (e) {
      debugPrint("Error fetching services: $e");
      setState(() => isLoading = false);
    }
  }

  List<ServiceModel> get filteredJobs {
    final query = _searchController.text.toLowerCase();
    return allJobs.where((job) {
      final matchesSearch =
          job.title.toLowerCase().contains(query) ||
              job.category.toLowerCase().contains(query) ||
              job.vendorName.toLowerCase().contains(query);

      final matchesCategory = selectedCategory == "All" ||
          job.category.toLowerCase() == selectedCategory.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final workerName = WorkerSession.currentWorker?.name ?? "Worker";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [

          /// 🔷 HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 30, 20, 30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff2563EB), Color(0xff1E40AF)],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  workerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: "Search services",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.blue),
                ),
              ),
            ),
          ),

          /// 🏷 CATEGORY FILTER
          SizedBox(
            height: 50,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final selected = cat == selectedCategory;

                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: selected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.blue),
                      boxShadow: selected
                          ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          /// 📋 JOB LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: fetchJobs,
              child: filteredJobs.isEmpty
                  ? const Center(
                child: Text(
                  "No services found",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = filteredJobs[index];

                  return JobCard(
                    title: job.title,
                    category: job.category,
                    description: job.description,
                    imageUrl: job.imageUrl,
                    price: job.price,
                    rating: 4.5, // temporary
                    vendorName: job.vendorName,
                    createdAt: job.createdAt,
                    serviceDateTime: job.serviceDateTime,
                    onApply: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ApplyJobScreen(serviceId: job.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
