import 'package:flutter/material.dart';
import 'package:vws/screens/edit_worker_profile.dart';
import 'package:vws/screens/auth/login_screen.dart';
import 'package:vws/sessions/worker_session.dart';
import 'package:vws/screens/my_booking_screen.dart';

class WorkerProfile extends StatefulWidget {
  const WorkerProfile({super.key});

  @override
  State<WorkerProfile> createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  var worker;

  @override
  void initState() {
    super.initState();
    // ✅ Load logged-in worker session
    worker = WorkerSession.currentWorker;
  }

  @override
  Widget build(BuildContext context) {
    if (worker == null) {
      return const Scaffold(
        body: Center(
          child: Text("Worker data not found"),
        ),
      );
    }

    const String imageUrl =
        "https://png.pngtree.com/png-clipart/20230927/original/pngtree-man-avatar-image-for-profile-png-image_13001882.png";

    return Scaffold(
      backgroundColor: const Color(0xffF2F3F7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------- TOP SECTION ----------
            Container(
              width: double.infinity,
              height: 240,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff2563EB), Color(0xff1E40AF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
                    radius: 52,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Display Name
                  Text(
                    worker.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // ✅ Display Email
                  Text(
                    worker.email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------- PROFILE ACTIONS ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _ProfileButton(
                    icon: Icons.edit,
                    text: "Edit Profile",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditWorkerProfile(worker: worker),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  _ProfileButton(
                    icon: Icons.book_online,
                    text: "My Bookings",
                    color: Colors.green,
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
                    icon: Icons.logout,
                    text: "Logout",
                    color: Colors.red,
                    onTap: () {
                      WorkerSession.currentWorker = null;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- PROFILE BUTTON WIDGET ----------
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
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
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
