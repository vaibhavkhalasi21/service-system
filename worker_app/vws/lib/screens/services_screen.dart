import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/booking_model.dart';
import '../services/worker_service_api.dart';

class ServicesScreen extends StatefulWidget {
  final TickerProvider vsync;
  const ServicesScreen({super.key, required this.vsync});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late TabController _tabController;
  bool isLoading = true;
  List<Booking> allBookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: widget.vsync);
    loadJobs();
  }

  Future<void> loadJobs() async {
    try {
      final data = await WorkerServiceApi.getMyBookings();
      if (!mounted) return;
      setState(() {
        allBookings = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading services: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  List<Booking> get pendingJobs =>
      allBookings.where((b) => b.status == "Accepted").toList();

  List<Booking> get completedJobs =>
      allBookings.where((b) => b.status == "Completed").toList();

  List<Booking> get cancelledJobs =>
      allBookings.where((b) => b.status == "Cancelled").toList();

  Widget _jobList(List<Booking> jobs, {bool allowComplete = false}) {
    if (jobs.isEmpty) {
      return const Center(
        child: Text("No jobs found", style: TextStyle(color: Colors.grey)),
      );
    }

    return RefreshIndicator(
      onRefresh: loadJobs,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final b = jobs[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Service name
                  Text(
                    b.jobTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Category + Vendor
                  Text(
                    "${b.category} • ${b.vendorName}",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  /// Date & Time
                  Row(
                    children: [
                      const Icon(Icons.schedule,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd MMM yyyy • hh:mm a')
                            .format(b.serviceDateTime),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Price + Button
                  Row(
                    children: [
                      Text(
                        "₹${b.price}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),

                      /// ✅ MARK COMPLETED (only in Pending tab)
                      if (allowComplete)
                        ElevatedButton(
                          onPressed: () async {
                            final success =
                            await WorkerServiceApi.markJobCompleted(b.id);

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                  Text("Job marked as completed"),
                                ),
                              );
                              loadJobs();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Mark Completed"),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:
        const Text("My Services", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(icon: Icon(Icons.access_time), text: "Pending"),
            Tab(icon: Icon(Icons.check_circle_outline), text: "Completed"),
            Tab(icon: Icon(Icons.cancel_outlined), text: "Cancelled"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _jobList(pendingJobs, allowComplete: true),
          _jobList(completedJobs),
          _jobList(cancelledJobs),
        ],
      ),
    );
  }
}