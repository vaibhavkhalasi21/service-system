import 'package:flutter/material.dart';
import '../model/service_model.dart';
import '../services/worker_service_api.dart';
import '../widget/job_card.dart';
import 'apply_job.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = "All";
  bool isLoading = true;
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
      print("Fetched ${jobs.length} services");
    } catch (e) {
      print("Error fetching services: $e");
      setState(() => isLoading = false);
    }
  }

  List<ServiceModel> get filteredJobs {
    return allJobs.where((job) {
      final query = _searchController.text.toLowerCase();
      final matchesSearch = job.title.toLowerCase().contains(query) ||
          job.category.toLowerCase().contains(query);
      final matchesCategory = selectedCategory == "All" ||
          job.category.toLowerCase() == selectedCategory.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2563EB), Color(0xff1E40AF)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Welcome back,", style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                const Text(
                  "Worker",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // SEARCH
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: "Search services...",
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // CATEGORY FILTER
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final selected = cat == selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategory = cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: selected ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cat,
                            style: TextStyle(color: selected ? Colors.white : Colors.blue),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // BODY
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: fetchJobs,
              child: filteredJobs.isEmpty
                  ? const Center(child: Text("No services found"))
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
                    price: job.price,     // ✅ REQUIRED
                    rating: 4.5,          // ✅ TEMP (until backend sends rating)
                    onApply: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApplyJobScreen(serviceId: job.id),
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
