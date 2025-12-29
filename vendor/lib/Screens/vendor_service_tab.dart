import 'package:flutter/material.dart';

class VendorJobsTab extends StatefulWidget {
  const VendorJobsTab({super.key});

  @override
  State<VendorJobsTab> createState() => _VendorJobsTabState();
}

class _VendorJobsTabState extends State<VendorJobsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// 🔖 Tabs
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

          /// 📋 Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _JobsList(status: "Pending"),
                _JobsList(status: "Completed"),
                _JobsList(status: "Cancelled"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 📄 Jobs List
class _JobsList extends StatelessWidget {
  final String status;

  const _JobsList({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == "Cancelled") {
      return const Center(
        child: Text(
          "No cancelled services",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _JobCard(
          serviceName: "Electrician Service",
          customerName: "Customer ${index + 1}",
          price: 299,
          status: status,
          imagePath: "assets/images/electrician.png",
        );
      },
    );
  }
}

/// 🧾 Job Card
class _JobCard extends StatelessWidget {
  final String serviceName;
  final String customerName;
  final int price;
  final String status;
  final String imagePath;

  const _JobCard({
    required this.serviceName,
    required this.customerName,
    required this.price,
    required this.status,
    required this.imagePath,
  });

  Color getStatusColor() {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == "Completed";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🖼️ Image
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title + Status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        serviceName,
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
                        color: getStatusColor().withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: getStatusColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  "Customer: $customerName",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 12),

                /// 💰 Price + Button
                Row(
                  children: [
                    Text(
                      "₹$price",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    if (!isCompleted)
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Mark Completed"),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
