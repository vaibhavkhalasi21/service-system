import 'package:flutter/material.dart';
import 'worker_dashboard.dart';
import 'services_screen.dart';
import 'worker_profile.dart';

class WorkerBottomNav extends StatefulWidget {
  const WorkerBottomNav({super.key});

  @override
  State<WorkerBottomNav> createState() => _WorkerBottomNavState();
}

class _WorkerBottomNavState extends State<WorkerBottomNav>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const WorkerDashboard(),
      ServicesScreen(vsync: this), // ✅ vsync pass
      const WorkerProfile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
