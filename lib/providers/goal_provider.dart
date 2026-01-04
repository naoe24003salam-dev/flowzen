import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';
import '../data/models/goal.dart';

class GoalProvider with ChangeNotifier {
  Box<Goal>? get _boxOrNull {
    try {
      return Hive.isBoxOpen(AppConstants.goalsBox) 
          ? Hive.box<Goal>(AppConstants.goalsBox)
          : null;
    } catch (e) {
      debugPrint('Error accessing goals box: $e');
      return null;
    }
  }

  List<Goal> get allGoals => _boxOrNull?.values.toList() ?? [];

  List<Goal> get activeGoals =>
      _boxOrNull?.values.where((g) => g.progress < 100).toList() ?? [];

  int get activeGoalsCount => activeGoals.length;

  Future<void> addGoal(Goal goal) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.put(goal.id, goal);
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.put(goal.id, goal);
    notifyListeners();
  }

  Future<void> deleteGoal(String id) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.delete(id);
    notifyListeners();
  }

  Future<void> updateProgress(String id, int progress) async {
    final box = _boxOrNull;
    if (box == null) return;
    final goal = box.get(id);
    if (goal != null) {
      goal.progress = progress.clamp(0, 100);
      await box.put(id, goal);
      notifyListeners();
    }
  }
}
