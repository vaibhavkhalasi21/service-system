import 'package:flutter/material.dart';

class VendorBookingsScreen extends StatelessWidget {
  const VendorBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.deepPurple,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildList("Pending Booking"),
                _buildList("Completed Booking"),
                _buildList("Cancelled Booking"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(String text) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(12),
          child: ListTile(
            title: Text(text),
            subtitle: const Text("Customer Name"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }
}
