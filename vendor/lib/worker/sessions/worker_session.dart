import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/worker_model.dart';

class WorkerSession {
  // ===============================
  // 🔥 IN-MEMORY CACHE
  // ===============================
  static Worker? currentWorker;
  static String? token;

  // Location sync flag (used by dashboard)
  static bool locationSynced = false;

  // ===============================
  // 🔥 SAVE SESSION (LOGIN)
  // ===============================
  static Future<void> saveWorker(
      Worker worker,
      String authToken,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    currentWorker = worker;
    token = authToken;
    locationSynced = false; // reset on new login

    await prefs.setString(
      'worker_data',
      jsonEncode(worker.toJson()), // 👈 category included here
    );
    await prefs.setString(
      'worker_token',
      authToken,
    );
  }

  // ===============================
  // 🔥 LOAD SESSION (APP START)
  // ===============================
  static Future<void> loadWorker() async {
    final prefs = await SharedPreferences.getInstance();

    final workerJson = prefs.getString('worker_data');
    final storedToken = prefs.getString('worker_token');

    if (workerJson != null && storedToken != null) {
      currentWorker = Worker.fromJson(
        jsonDecode(workerJson), // 👈 category restored here
      );
      token = storedToken;
    }
  }

  // ===============================
  // 🔥 FAST TOKEN ACCESS
  // ===============================
  static String? getTokenSync() {
    return token;
  }

  // (kept for backward compatibility)
  static Future<String?> getToken() async {
    if (token != null) return token;

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('worker_token');
    return token;
  }

  // ===============================
  // 🔥 LOGOUT
  // ===============================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    currentWorker = null;
    token = null;
    locationSynced = false;

    await prefs.remove('worker_data');
    await prefs.remove('worker_token');
  }

  // ===============================
  // 🔥 SESSION CHECK
  // ===============================
  static bool get isLoggedIn =>
      currentWorker != null && token != null;
}
