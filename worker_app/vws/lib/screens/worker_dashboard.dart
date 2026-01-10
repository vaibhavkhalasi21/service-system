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
    } catch (e) {
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
      backgroundColor: const Color(0xff0F0F0F),
      body: Column(
        children: [

          /// 🔥 HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 30, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff0F0F0F),
                  Color(0xff1C1C1C),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "WELCOME BACK",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  workerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
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
                color: const Color(0xff1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search for a professional...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xff7C3AED)),
                ),
              ),
            ),
          ),

          /// 🏷 CATEGORY FILTER
          SizedBox(
            height: 48,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xff7C3AED)
                          : const Color(0xff1E1E1E),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xff7C3AED),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          /// 📋 JOB LIST
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xff7C3AED),
              ),
            )
                : RefreshIndicator(
              color: const Color(0xff7C3AED),
              onRefresh: fetchJobs,
              child: filteredJobs.isEmpty
                  ? const Center(
                child: Text(
                  "No services found",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                ),
              )
                  : ListView.builder(
                padding:
                const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = filteredJobs[index];

                  return JobCard(
                    title: job.title,
                    category: job.category,
                    description: job.description,
                    imageUrl: job.imageUrl,
                    price: job.price,
                    rating: 4.5,
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
