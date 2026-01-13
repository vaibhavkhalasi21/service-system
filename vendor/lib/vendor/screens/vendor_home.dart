import 'package:flutter/material.dart';
import 'vendor_dashboard_tab.dart';
import 'vendor_service_tab.dart';
import 'vendor_profile_tab.dart';

// ================= UI CONSTANTS =================
const Color kBg = Color(0xFF0F0F0F);
const Color kNavBg = Color(0xFF1A1A1A);
const Color kPurple = Color(0xFF7B4DFF);
const Color kTextGrey = Color(0xFF9E9E9E);

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    VendorHomeTab(),
    VendorJobsTab(),
    VendorProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: kBg,

        // ================= BODY =================
        body: SafeArea(
          top: true,   // ✅ gives slight space at top
          bottom: false,
          child: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ),

        // ================= BOTTOM NAV =================
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: kNavBg,
            boxShadow: [
              BoxShadow(
                color: kPurple.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: kNavBg,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: kPurple,
            unselectedItemColor: kTextGrey,
            showUnselectedLabels: true,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline),
                activeIcon: Icon(Icons.work),
                label: "Services",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
