import 'package:flutter/material.dart';
import 'package:vws/widget/job_card.dart';
import 'package:vws/screens/apply_job.dart';

class WorkerDashboard extends StatelessWidget {
  const WorkerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          /// 🔵 HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2563EB), Color(0xff1E40AF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Welcome back,",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "John Smith",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Find your next opportunity",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white.withOpacity(.2),
                      child: const Icon(Icons.notifications,
                          color: Colors.white),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                /// 🔍 SEARCH BAR
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "Search for jobs...",
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.filter_list),
                    )
                  ],
                )
              ],
            ),
          ),

          /// 🔽 BODY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// RECENT JOBS TITLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.work, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Recent Jobs",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "View All",
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),

                const SizedBox(height: 12),

                /// JOB CARDS
                JobCard(
                  title: "Kitchen Cabinet Installation",
                  category: "Carpentry",
                  description:
                  "Need experienced carpenter to install custom kitchen cabinets.",
                  imageUrl:
                  "https://images.unsplash.com/photo-1588854337115-1c67d9247e4d",
                  onApply: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ApplyJobScreen(),
                      ),
                    );
                  },

                ),

                JobCard(
                  title: "Fan Repair",
                  category: "Electrician",
                  description: "Ceiling fan not working properly.",
                  imageUrl:
                  "https://www.finnleyelectrical.com.au/wp-content/uploads/2022/09/Electrician-repairing-a-ceiling-fan.jpg",
                  onApply: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ApplyJobScreen(),
                      ),
                    );
                  },

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
