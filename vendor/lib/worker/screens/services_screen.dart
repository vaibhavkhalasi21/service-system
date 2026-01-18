import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/booking_model.dart';
import '../services/worker_service_api.dart';
import '../services/location_service.dart';

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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkerLocation() async {
    final pos = await LocationService.getFastLocation();
    if (mounted) setState(() => workerPosition = pos);
  }

  Future<void> loadJobs() async {
    if (mounted) setState(() => isLoading = true);

    try {
      final data = await WorkerServiceApi.getMyBookings();
      if (!mounted) return;

      setState(() {
        allBookings = data;
        isLoading = false;
      });

      print("ALL BOOKINGS: ${allBookings.length}");
      print("ACTIVE BOOKINGS: ${activeJobs.length}");
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= FILTERS =================
  List<Booking> get activeJobs =>
      allBookings.where((b) => b.status == "Accepted").toList();

  List<Booking> get completedJobs =>
      allBookings.where((b) => b.status == "Completed").toList();

  List<Booking> get cancelledJobs =>
      allBookings.where((b) =>
      b.status == "Cancelled" || b.status == "Rejected").toList();

  double _distanceKm(Booking b) {
    if (workerPosition == null) return 0;
    return Geolocator.distanceBetween(
      workerPosition!.latitude,
      workerPosition!.longitude,
      b.serviceLatitude,
      b.serviceLongitude,
    ) /
        1000;
  }

  Future<void> _openMap(double lat, double lng) async {
    final uri = Uri.parse("geo:$lat,$lng?q=$lat,$lng");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _jobList(List<Booking> jobs, {bool showLocation = false}) {
    if (jobs.isEmpty) {
      return const Center(
        child: Text("No jobs found", style: TextStyle(color: kGrey)),
      );
    }

    return RefreshIndicator(
      color: kPurple,
      onRefresh: loadJobs,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final b = jobs[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.jobTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${b.category} • ${b.vendorName}",
                  style: const TextStyle(color: kGrey),
                ),
                if (showLocation && workerPosition != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () =>
                        _openMap(b.serviceLatitude, b.serviceLongitude),
                    child: Text(
                      "${_distanceKm(b).toStringAsFixed(1)} km • Open map",
                      style: const TextStyle(color: kPurple),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Text(
                  DateFormat('dd MMM yyyy • hh:mm a')
                      .format(b.serviceDateTime),
                  style: const TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 12),
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
                          final ok = await WorkerServiceApi
                              .markJobCompleted(b.id);
                          if (ok && mounted) loadJobs();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPurple,
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
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        title: const Text("My Services"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kPurple,
          tabs: const [
            Tab(text: "Active"),
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
          _jobList(activeJobs, showLocation: true),
          _jobList(completedJobs),
          _jobList(cancelledJobs),
        ],
      ),
    );
  }
}
