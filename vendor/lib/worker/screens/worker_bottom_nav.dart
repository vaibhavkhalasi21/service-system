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

    // ✅ CREATE ONCE — KEEP ALIVE
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

      // 🔥 KEEP SCREENS ALIVE
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xff1C1C1C),
          border: Border(
            top: BorderSide(color: Colors.white10),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == _currentIndex) return;
            setState(() => _currentIndex = index);
          },
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
}
