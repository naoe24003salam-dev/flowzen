import 'package:flutter/material.dart';

class StatisticsProvider with ChangeNotifier {
  int _productivityScore = 75;

  int get productivityScore => _productivityScore;

  void recalculateScore({
    required int tasksCompleted,
    required int habitStreak,
    required int focusMinutes,
  }) {
    final taskScore = (tasksCompleted * 10).clamp(0, 30);
    final habitScore = (habitStreak * 5).clamp(0, 35);
    final focusScore = (focusMinutes ~/ 10).clamp(0, 35);
    _productivityScore = (taskScore + habitScore + focusScore).clamp(0, 100);
    notifyListeners();
  }
}
