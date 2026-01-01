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
      WorkerDashboard(),
      ServicesScreen(vsync: this), // ✅ vsync pass
      WorkerProfile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
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

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return WorkerDashboard();
      case 1:
        return ServicesScreen(vsync: this);
      case 2:
        return WorkerProfile(); // 🔥 yahan rebuild hoga
      default:
        return WorkerDashboard();
    }
  }

}
