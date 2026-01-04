import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';
import '../data/models/habit.dart';

class HabitProvider with ChangeNotifier {
  Box<Habit>? get _boxOrNull {
    try {
      return Hive.isBoxOpen(AppConstants.habitsBox) 
          ? Hive.box<Habit>(AppConstants.habitsBox)
          : null;
    } catch (e) {
      debugPrint('Error accessing habits box: $e');
      return null;
    }
  }

  List<Habit> get allHabits => _boxOrNull?.values.toList() ?? [];

  int get currentStreak {
    final box = _boxOrNull;
    if (box == null || box.values.isEmpty) return 0;
    final streaks = box.values.map((h) => h.currentStreak).toList();
    return streaks.reduce((a, b) => a > b ? a : b);
  }

  Future<void> addHabit(Habit habit) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.put(habit.id, habit);
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.put(habit.id, habit);
    notifyListeners();
  }

  Future<void> deleteHabit(String id) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.delete(id);
    notifyListeners();
  }

  Future<void> toggleHabitToday(String id) async {
    final box = _boxOrNull;
    if (box == null) return;
    final habit = box.get(id);
    if (habit == null) return;

    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';

    if (habit.completedDates.contains(todayKey)) {
      habit.completedDates.remove(todayKey);
      habit.currentStreak = _recalculateStreak(habit);
    } else {
      habit.completedDates.add(todayKey);
      habit.currentStreak++;
      if (habit.currentStreak > habit.longestStreak) {
        habit.longestStreak = habit.currentStreak;
      }
    }

    await box.put(id, habit);
    notifyListeners();
  }

  int _recalculateStreak(Habit habit) {
    if (habit.completedDates.isEmpty) return 0;
    final sorted = habit.completedDates.toList()..sort();
    int streak = 1;
    for (int i = sorted.length - 1; i > 0; i--) {
      final current = DateTime.parse(sorted[i]);
      final previous = DateTime.parse(sorted[i - 1]);
      if (current.difference(previous).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
