import 'package:flutter/material.dart';
import 'package:vws/screens/auth/login_screen.dart';
import 'package:vws/screens/auth/signup_screen.dart';
import 'package:vws/screens/worker_bottom_nav.dart';
import 'package:vws/sessions/worker_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WorkerSession.loadWorker();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Worker App',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xffF2F3F7),
      ),
      home: WorkerSession.currentWorker != null
          ? const WorkerBottomNav()
          : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const WorkerRegisterScreen(),
      },
    );
  }
}
