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
      ServicesScreen(vsync: this),
      const WorkerProfile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      body: _buildScreen(),

      /// 🔥 DARK BOTTOM NAV
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xff1C1C1C),
          border: Border(
            top: BorderSide(color: Colors.white10),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xff1C1C1C),
          elevation: 0,
          type: BottomNavigationBarType.fixed,

          selectedItemColor: const Color(0xff7C3AED),
          unselectedItemColor: Colors.white54,

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: "Services",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  /// 🔄 SCREEN SWITCH (UNCHANGED LOGIC)
  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return const WorkerDashboard();
      case 1:
        return ServicesScreen(vsync: this);
      case 2:
        return const WorkerProfile();
      default:
        return const WorkerDashboard();
    }
  }
}
