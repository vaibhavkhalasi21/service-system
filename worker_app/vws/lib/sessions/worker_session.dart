import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/worker_model.dart';

class WorkerSession {
  static Worker? currentWorker;

  static Future<void> saveWorker(Worker worker, String token) async {
    final prefs = await SharedPreferences.getInstance();
    currentWorker = worker;
    await prefs.setString('worker_data', jsonEncode(worker.toJson()));
    await prefs.setString('worker_token', token);
  }

  static Future<void> loadWorker() async {
    final prefs = await SharedPreferences.getInstance();
    final workerJson = prefs.getString('worker_data');
    if (workerJson != null) {
      currentWorker = Worker.fromJson(jsonDecode(workerJson));
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('worker_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    currentWorker = null;
    await prefs.clear();
  }
}
