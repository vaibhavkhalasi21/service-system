import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_request.dart';
import '../services/vendor_application_api.dart';

// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kCard = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ===============================
  // LOAD VENDOR JOBS
  // ===============================
  Future<void> loadJobs() async {
    setState(() => isLoading = true);

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

  /// Status filters (LOGIC UNCHANGED)
  List<BookingRequest> get pendingJobs =>
      allJobs.where((j) => j.status == "Accepted").toList();

  List<BookingRequest> get completedJobs =>
      allJobs.where((j) => j.status == "Completed").toList();

  List<BookingRequest> get cancelledJobs =>
      allJobs.where((j) => j.status == "Cancelled").toList();

  // ===============================
  // EMPTY STATE
  // ===============================
  Widget _emptyState(String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPurple.withOpacity(0.15),
            ),
            child: const Icon(
              Icons.work_outline,
              size: 48,
              color: kPurple,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "No jobs found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kGrey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================
  // JOB LIST UI
  // ===============================
  Widget _jobList(List<BookingRequest> jobs) {
    return RefreshIndicator(
      color: kPurple,
      onRefresh: loadJobs,
      child: jobs.isEmpty
          ? ListView(
        children: [
          const SizedBox(height: 140),
          _emptyState(
            "You don't have any jobs in this category yet.",
          ),
        ],
      )
          : ListView.builder(
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

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// SERVICE + STATUS
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        j.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// WORKER
                Text(
                  "Worker: ${j.workerName}",
                  style: const TextStyle(
                    color: kGrey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                /// DATE TIME
                Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 16, color: kGrey),
                    const SizedBox(width: 6),
                    Text(
                      "$date • $time",
                      style: const TextStyle(
                        color: kGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// PRICE
                Text(
                  "₹${j.price}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPurple,
                  ),
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
    return Container(
      color: kBg,
      child: Column(
        children: [
          // ================= HEADER =================
          const SizedBox(height: 16),
          const Text(
            "My Services",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // ================= ICON TABS =================
          TabBar(
            controller: _tabController,
            indicatorColor: kPurple,
            labelColor: kPurple,
            unselectedLabelColor: kGrey,
            tabs: const [
              Tab(
                icon: Icon(Icons.access_time),
                text: "Pending",
              ),
              Tab(
                icon: Icon(Icons.check_circle_outline),
                text: "Completed",
              ),
              Tab(
                icon: Icon(Icons.cancel_outlined),
                text: "Cancelled",
              ),
            ],
          ),

          // ================= TAB VIEWS =================
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(color: kPurple),
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
