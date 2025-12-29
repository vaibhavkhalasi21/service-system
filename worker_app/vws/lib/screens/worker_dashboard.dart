import 'package:flutter/material.dart';
import 'package:vws/widget/job_card.dart';
import 'package:vws/screens/apply_job.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = "All";

  final List<String> categories = [
    "All",
    "Plumber",
    "Electrician",
    "Carpenter",
    "Cleaner",
    "Painter",
  ];

  final List<Map<String, String>> allJobs = [
    {
      "title": "Kitchen Cabinet Installation",
      "category": "Carpenter",
      "description":
      "Need experienced carpenter to install custom kitchen cabinets.",
      "image":
      "https://images.unsplash.com/photo-1588854337115-1c67d9247e4d",
    },
    {
      "title": "Fan Repair",
      "category": "Electrician",
      "description": "Ceiling fan not working properly.",
      "image":
      "https://www.finnleyelectrical.com.au/wp-content/uploads/2022/09/Electrician-repairing-a-ceiling-fan.jpg",
    },
    {
      "title": "Bathroom Pipe Fix",
      "category": "Plumber",
      "description": "Water leakage issue in bathroom.",
      "image":
      "https://images.unsplash.com/photo-1600880292203-757bb62b4baf",
    },
    {
      "title": "House Cleaning",
      "category": "Cleaner",
      "description": "Need full house deep cleaning.",
      "image":
      "https://images.unsplash.com/photo-1581579185169-9c9d1f9e1b29",
    },
    {
      "title": "Wall Painting",
      "category": "Painter",
      "description": "2BHK house painting work.",
      "image":
      "https://images.unsplash.com/photo-1598300054341-0b5e1adba77d",
    },
  ];

  List<Map<String, String>> get filteredJobs {
    return allJobs.where((job) {
      final searchText = _searchController.text.toLowerCase();

      final matchesSearch =
          job["category"]!.toLowerCase().contains(searchText) ||
              job["title"]!.toLowerCase().contains(searchText);

      final matchesCategory =
          selectedCategory == "All" || job["category"] == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

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
                        Text("Welcome back,",
                            style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 4),
                        Text(
                          "John Smith",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text("Find your next opportunity",
                            style: TextStyle(color: Colors.white70)),
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
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
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
                ),

                const SizedBox(height: 16),

                /// 🏷 CATEGORY LIST
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category == selectedCategory;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),

          /// 🔽 BODY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// TITLE
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
                  ],
                ),
                const SizedBox(height: 12),

                /// JOB LIST
                if (filteredJobs.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No jobs found"),
                    ),
                  ),

                ...filteredJobs.map((job) {
                  return JobCard(
                    title: job["title"]!,
                    category: job["category"]!,
                    description: job["description"]!,
                    imageUrl: job["image"]!,
                    onApply: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ApplyJobScreen(),
                        ),
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
