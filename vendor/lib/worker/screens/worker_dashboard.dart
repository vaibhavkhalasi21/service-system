import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/job_model.dart';
import '../services/worker_service_api.dart';
import '../services/location_service.dart';
import '../widgets/job_card.dart';
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
  bool locationUpdated = false;

  String selectedCategory = "All";
  List<MyJob> allJobs = [];

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
    _initDashboard();
  }

  // ================= INIT FLOW =================
  Future<void> _initDashboard() async {
    await _updateWorkerLocationOnce();
    await fetchNearbyJobs();
  }

  // ================= LOCATION =================
  Future<void> _updateWorkerLocationOnce() async {
    if (locationUpdated) return;

    try {
      final Position? position =
      await LocationService.getCurrentLocation();

      if (position == null) return;

      await WorkerServiceApi.updateWorkerLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      locationUpdated = true;
    } catch (_) {
      // Silent fail: location should never break dashboard
    }
  }

  // ================= FETCH NEARBY JOBS =================
  Future<void> fetchNearbyJobs() async {
    setState(() => isLoading = true);

    try {
      final jobs = await WorkerServiceApi.getNearbyJobs();

      if (!mounted) return;

      setState(() {
        allJobs = jobs;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ================= FILTER =================
  List<MyJob> get filteredJobs {
    final query = _searchController.text.toLowerCase();

    return allJobs.where((job) {
      final matchesSearch =
          job.title.toLowerCase().contains(query) ||
              job.category.toLowerCase().contains(query) ||
              job.vendorName.toLowerCase().contains(query) ||
              job.address.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == "All" ||
              job.category.toLowerCase() ==
                  selectedCategory.toLowerCase();

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
          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding:
            EdgeInsets.fromLTRB(20, topPadding + 30, 20, 30),
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

          // ================= SEARCH =================
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
                  hintText: "Search service, vendor or location...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  icon: Icon(Icons.search,
                      color: Color(0xff7C3AED)),
                ),
              ),
            ),
          ),

          // ================= CATEGORY FILTER =================
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
                  onTap: () =>
                      setState(() => selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xff7C3AED)
                          : const Color(0xff1E1E1E),
                      borderRadius: BorderRadius.circular(30),
                      border:
                      Border.all(color: const Color(0xff7C3AED)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: TextStyle(
                        color:
                        selected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ================= JOB LIST =================
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xff7C3AED),
              ),
            )
                : RefreshIndicator(
              color: const Color(0xff7C3AED),
              onRefresh: fetchNearbyJobs,
              child: filteredJobs.isEmpty
                  ? const Center(
                child: Text(
                  "No nearby jobs found",
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
                    vendorName: job.vendorName,
                    createdAt: job.createdAt,
                    serviceDateTime: job.serviceDateTime,
                    address: job.address,
                    onApply: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApplyJobScreen(
                            serviceId: job.id,
                            serviceLatitude: job.serviceLatitude,
                            serviceLongitude: job.serviceLongitude,
                            serviceAddress: job.address,
                          ),
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
