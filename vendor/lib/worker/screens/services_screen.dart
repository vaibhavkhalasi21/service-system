import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
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
        child: Text(
          "No jobs found",
          style: TextStyle(color: Colors.white60),
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xff7C3AED),
      onRefresh: loadJobs,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final b = jobs[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 SERVICE TITLE
                Text(
                  b.jobTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// 🔹 CATEGORY & VENDOR
                Text(
                  "${b.category} • ${b.vendorName}",
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔹 DATE & TIME
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.white54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd MMM yyyy • hh:mm a')
                          .format(b.serviceDateTime),
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// 🔹 PRICE + ACTION
                Row(
                  children: [
                    Text(
                      "₹${b.price}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),

                    if (allowComplete)
                      ElevatedButton(
                        onPressed: () async {
                          final success =
                          await WorkerServiceApi.markJobCompleted(b.id);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Job marked as completed"),
                              ),
                            );
                            loadJobs();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff7C3AED),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Mark Completed"),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F0F0F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Services",
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xff7C3AED),
          labelColor: const Color(0xff7C3AED),
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.access_time), text: "Pending"),
            Tab(icon: Icon(Icons.check_circle_outline), text: "Completed"),
            Tab(icon: Icon(Icons.cancel_outlined), text: "Cancelled"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xff7C3AED),
        ),
      )
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
