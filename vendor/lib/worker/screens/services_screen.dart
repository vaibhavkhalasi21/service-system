import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/booking_model.dart';
import '../services/worker_service_api.dart';
import '../services/location_service.dart';

// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kPurple = Color(0xFF7B4DFF);
const Color kGrey = Color(0xFF9E9E9E);

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
  Position? workerPosition;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: widget.vsync);
    _loadWorkerLocation();
    loadJobs();
  }

  // ================= LOAD WORKER LOCATION =================
  Future<void> _loadWorkerLocation() async {
    final pos = await LocationService.getFastLocation();
    if (!mounted) return;
    setState(() => workerPosition = pos);
  }

  // ================= LOAD BOOKINGS =================
  Future<void> loadJobs() async {
    try {
      final data = await WorkerServiceApi.getMyBookings();
      if (!mounted) return;
      setState(() {
        allBookings = data;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  // ================= FILTERS =================
  List<Booking> get acceptedJobs =>
      allBookings.where((b) => b.status == "Accepted").toList();

  List<Booking> get completedJobs =>
      allBookings.where((b) => b.status == "Completed").toList();

  List<Booking> get cancelledJobs =>
      allBookings.where((b) => b.status == "Cancelled").toList();

  // ================= DISTANCE =================
  double _distanceKm(Booking b) {
    if (workerPosition == null) return 0;
    final meters = Geolocator.distanceBetween(
      workerPosition!.latitude,
      workerPosition!.longitude,
      b.serviceLatitude,
      b.serviceLongitude,
    );
    return meters / 1000;
  }

  // ================= OPEN MAP =================
  Future<void> _openMap(double lat, double lng) async {
    final uri = Uri.parse("geo:$lat,$lng?q=$lat,$lng");

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open map")),
      );
    }
  }


  // ================= JOB LIST =================
  Widget _jobList(List<Booking> jobs, {bool showLocation = false}) {
    if (jobs.isEmpty) {
      return const Center(
        child: Text(
          "No jobs found",
          style: TextStyle(color: kGrey),
        ),
      );
    }

    return RefreshIndicator(
      color: kPurple,
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
                // 🔹 TITLE
                Text(
                  b.jobTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // 🔹 CATEGORY & VENDOR
                Text(
                  "${b.category} • ${b.vendorName}",
                  style: const TextStyle(
                    color: kGrey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 10),

                // 🔹 LOCATION (EXACT VENDOR STYLE)
                if (showLocation && workerPosition != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _openMap(
                            b.serviceLatitude,
                            b.serviceLongitude,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                              "${_distanceKm(b).toStringAsFixed(1)} km (approx)",

                        style: const TextStyle(
                                  color: kGrey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "location",
                                style: TextStyle(
                                  color: kPurple,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                if (showLocation) const SizedBox(height: 10),

                // 🔹 DATE & TIME
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

                // 🔹 PRICE + ACTION
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

                    if (showLocation)
                      ElevatedButton(
                        onPressed: () async {
                          final success =
                          await WorkerServiceApi.markJobCompleted(b.id);
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Job marked as completed"),
                              ),
                            );
                            loadJobs();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPurple,
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

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        centerTitle: true,
        title: const Text("My Services"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kPurple,
          labelColor: kPurple,
          unselectedLabelColor: kGrey,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Completed"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: kPurple),
      )
          : TabBarView(
        controller: _tabController,
        children: [
          _jobList(acceptedJobs, showLocation: true),
          _jobList(completedJobs),
          _jobList(cancelledJobs),
        ],
      ),
    );
  }
}
