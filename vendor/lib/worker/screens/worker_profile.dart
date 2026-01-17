import 'package:flutter/material.dart';
import 'package:vendor/worker/screens/worker_payment_page.dart';

import '../../auth/role_selection_screen.dart';
import '../models/worker_model.dart';
import '../sessions/worker_session.dart';
import 'edit_worker_profile.dart';
import 'my_booking_screen.dart';

class WorkerProfile extends StatefulWidget {
  const WorkerProfile({super.key});

  @override
  State<WorkerProfile> createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  Worker? worker;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkerSession();
  }

  void _loadWorkerSession() async {
    await WorkerSession.loadWorker();
    setState(() {
      worker = WorkerSession.currentWorker;
      _loading = false;
    });
  }

  void _refreshWorker() {
    setState(() {
      worker = WorkerSession.currentWorker;
    });
  }

  // =============================
  // 🔐 CATEGORY HELPER
  // =============================
  String categoryName(int category) {
    switch (category) {
      case 1:
        return "Cleaning";
      case 2:
        return "Plumber";
      case 3:
        return "Electrician";
      case 4:
        return "AC Repair";
      case 5:
        return "Painter";
      default:
        return "Unknown";
    }
  }

  // =============================
  // LOGOUT
  // =============================
  Future<void> _logout(BuildContext context) async {
    await WorkerSession.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const RoleSelectionScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xff0F0F0F),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xff7C3AED),
          ),
        ),
      );
    }

    if (worker == null) {
      return const Scaffold(
        backgroundColor: Color(0xff0F0F0F),
        body: Center(
          child: Text(
            "Worker data not found",
            style: TextStyle(color: Colors.white60),
          ),
        ),
      );
    }

    const String imageUrl =
        "https://png.pngtree.com/png-clipart/20230927/original/pngtree-man-avatar-image-for-profile-png-image_13001882.png";

    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔥 HEADER
            Container(
              width: double.infinity,
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff0F0F0F),
                    Color(0xff1C1C1C),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 54,
                    backgroundColor: const Color(0xff7C3AED),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // NAME
                  Text(
                    worker!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // EMAIL
                  Text(
                    worker!.email,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🔥 CATEGORY BADGE
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xff7C3AED).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border:
                      Border.all(color: const Color(0xff7C3AED), width: 1),
                    ),
                    child: Text(
                      categoryName(worker!.category),
                      style: const TextStyle(
                        color: Color(0xff7C3AED),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔘 ACTION BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _ProfileButton(
                    icon: Icons.edit,
                    text: "Edit Name",
                    color: const Color(0xff7C3AED),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditWorkerProfile(),
                        ),
                      );
                      _refreshWorker();
                    },
                  ),

                  const SizedBox(height: 16),

                  _ProfileButton(
                    icon: Icons.book_online,
                    text: "My Bookings",
                    color: Colors.greenAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyBookingsScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  _ProfileButton(
                    icon: Icons.payments,
                    text: "My Payments",
                    color: Colors.purpleAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WorkerPaymentsPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  _ProfileButton(
                    icon: Icons.logout,
                    text: "Logout",
                    color: Colors.redAccent,
                    onTap: () => _logout(context),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================
// PROFILE BUTTON
// =============================
class _ProfileButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _ProfileButton({
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xff1E1E1E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white38,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
