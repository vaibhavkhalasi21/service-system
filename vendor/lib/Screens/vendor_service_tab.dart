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
    return Column(
      children: [

        /// 🔖 Tabs
        Container(
          color: Colors.white,
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
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: TabBarView(
              controller: _tabController,
              children: const [
                _JobsList(status: "Pending"),
                _JobsList(status: "Completed"),
                _JobsList(status: "Cancelled"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 📄 Jobs List Widget
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
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        // You can change images dynamically per index/service
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

/// 🧾 Single Job Card WITH IMAGE & Flexible Layout
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        height: 110,
        child: Row(
          children: [

            /// 🖼️ Service Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: Image.asset(
                imagePath,
                width: 110,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            /// 📄 Job Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
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
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: getStatusColor().withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: getStatusColor(),
                              fontWeight: FontWeight.bold,
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

                    const Spacer(),

                    /// Price + Action Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "₹$price",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (status == "Pending")
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("Mark Completed"),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
