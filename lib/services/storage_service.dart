import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const _prefix = 'tasks_'; // chave será tasks_YYYY-MM-DD

  Future<List<Task>> loadTasksFor(String dateKey) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$dateKey');
    if (raw == null) return [];
    final List data = jsonDecode(raw) as List;
    return data.map((e) => Task.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> saveTasksFor(String dateKey, List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString('$_prefix$dateKey', raw);
  }
}
