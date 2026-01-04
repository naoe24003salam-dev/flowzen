import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import 'focus_session.dart';
import 'goal.dart';
import 'habit.dart';
import 'note.dart';
import 'task.dart';

class ModelRegistry {
  ModelRegistry._();

  static bool _adaptersRegistered = false;

  static void registerAdapters() {
    if (_adaptersRegistered) return;
    
    try {
      if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(PriorityAdapter());
      if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(TaskAdapter());
      if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(HabitAdapter());
      if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(GoalTypeAdapter());
      if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(GoalAdapter());
      if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(FocusSessionAdapter());
      if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(NoteAdapter());
      _adaptersRegistered = true;
    } catch (e) {
      debugPrint('Error registering adapters: $e');
      rethrow;
    }
  }

  static Future<void> openBoxes() async {
    try {
      if (!Hive.isBoxOpen(AppConstants.tasksBox)) {
        await Hive.openBox<Task>(AppConstants.tasksBox);
      }
      if (!Hive.isBoxOpen(AppConstants.habitsBox)) {
        await Hive.openBox<Habit>(AppConstants.habitsBox);
      }
      if (!Hive.isBoxOpen(AppConstants.goalsBox)) {
        await Hive.openBox<Goal>(AppConstants.goalsBox);
      }
      if (!Hive.isBoxOpen(AppConstants.focusSessionsBox)) {
        await Hive.openBox<FocusSession>(AppConstants.focusSessionsBox);
      }
      if (!Hive.isBoxOpen(AppConstants.notesBox)) {
        await Hive.openBox<Note>(AppConstants.notesBox);
      }
      if (!Hive.isBoxOpen(AppConstants.settingsBox)) {
        await Hive.openBox(AppConstants.settingsBox);
      }
    } catch (e) {
      debugPrint('Error opening boxes: $e');
      rethrow;
    }
  }
}
