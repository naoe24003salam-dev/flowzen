import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';
import '../data/models/task.dart';

class TaskProvider with ChangeNotifier {
  Box<Task>? get _boxOrNull {
    try {
      return Hive.isBoxOpen(AppConstants.tasksBox) 
          ? Hive.box<Task>(AppConstants.tasksBox)
          : null;
    } catch (e) {
      debugPrint('Error accessing tasks box: $e');
      return null;
    }
  }

  List<Task> get allTasks => _boxOrNull?.values.toList() ?? [];

  List<Task> get activeTasks =>
      _boxOrNull?.values.where((t) => !t.isCompleted).toList() ?? [];

  List<Task> get completedTasks =>
      _boxOrNull?.values.where((t) => t.isCompleted).toList() ?? [];

  int get completedTodayCount {
    final box = _boxOrNull;
    if (box == null) return 0;
    
    final today = DateTime.now();
    return box.values.where((t) {
      return t.isCompleted &&
          t.createdAt.year == today.year &&
          t.createdAt.month == today.month &&
          t.createdAt.day == today.day;
    }).length;
  }

  Future<void> addTask(Task task) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.put(task.id, task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.put(task.id, task);
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.delete(id);
    notifyListeners();
  }

  Future<void> toggleComplete(String id) async {
    final box = _boxOrNull;
    if (box == null) return;
    final task = box.get(id);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      await box.put(id, task);
      notifyListeners();
    }
  }

  Future<void> toggleTaskComplete(String id) => toggleComplete(id);

  List<Task> getTasksForDate(DateTime date) {
    final box = _boxOrNull;
    if (box == null) return [];
    
    return box.values.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == date.year &&
          task.dueDate!.month == date.month &&
          task.dueDate!.day == date.day;
    }).toList();
  }

  Future<void> createTask({
    required String title,
    String description = '',
    Priority priority = Priority.medium,
    DateTime? dueDate,
  }) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
      createdAt: DateTime.now(),
      dueDate: dueDate,
    );
    await addTask(task);
  }
}
