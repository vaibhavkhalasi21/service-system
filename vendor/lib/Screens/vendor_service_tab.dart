import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_request.dart';
import '../services/vendor_application_api.dart';

class VendorJobsTab extends StatefulWidget {
  const VendorJobsTab({super.key});

  @override
  State<VendorJobsTab> createState() => _VendorJobsTabState();
}

class _VendorJobsTabState extends State<VendorJobsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  List<BookingRequest> allJobs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadJobs();
  }

  Future<void> loadJobs() async {
    try {
      final data = await VendorApplicationApi.getRequests();
      if (!mounted) return;
      setState(() {
        allJobs = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Vendor jobs load error: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  /// Status filters
  List<BookingRequest> get pendingJobs =>
      allJobs.where((j) => j.status == "Accepted").toList();

  List<BookingRequest> get completedJobs =>
      allJobs.where((j) => j.status == "Completed").toList();

  List<BookingRequest> get cancelledJobs =>
      allJobs.where((j) => j.status == "Cancelled").toList();

  Widget _jobList(List<BookingRequest> jobs) {
    if (jobs.isEmpty) {
      return const Center(
        child: Text(
          "No jobs found",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadJobs,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final j = jobs[index];

          final localTime = j.serviceDateTime.toLocal();
          final date =
          DateFormat('dd MMM yyyy').format(localTime);
          final time =
          DateFormat('hh:mm a').format(localTime);

          Color statusColor;
          switch (j.status) {
            case "Completed":
              statusColor = Colors.green;
              break;
            case "Cancelled":
              statusColor = Colors.red;
              break;
            default:
              statusColor = Colors.orange;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Service + Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          j.serviceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          j.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// Worker info
                  Text(
                    "Worker: ${j.workerName}",
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
                        "$date • $time",
                        style:
                        const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Price
                  Text(
                    "₹${j.price}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
      body: Column(
        children: [
          /// Tabs
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.deepPurple,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.deepPurple,
              tabs: const [
                Tab(text: "Pending"),
                Tab(text: "Completed"),
                Tab(text: "Cancelled"),
              ],
            ),
          ),

          /// Views
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : TabBarView(
              controller: _tabController,
              children: [
                _jobList(pendingJobs),
                _jobList(completedJobs),
                _jobList(cancelledJobs),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
