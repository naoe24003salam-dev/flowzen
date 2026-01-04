import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../data/models/focus_session.dart';

enum FocusTimerState { idle, work, shortBreak, longBreak, paused }

class FocusProvider with ChangeNotifier {
  Box<FocusSession>? get _boxOrNull {
    try {
      return Hive.isBoxOpen(AppConstants.focusSessionsBox) 
          ? Hive.box<FocusSession>(AppConstants.focusSessionsBox)
          : null;
    } catch (e) {
      debugPrint('Error accessing focus sessions box: $e');
      return null;
    }
  }

  FocusTimerState _state = FocusTimerState.idle;
  int _remainingSeconds = AppConstants.defaultWorkMinutes * 60;
  Timer? _timer;
  int _sessionCount = 0;
  DateTime? _sessionStartTime;

  FocusTimerState get state => _state;
  int get remainingSeconds => _remainingSeconds;
  int get sessionCount => _sessionCount;

  int get totalFocusMinutesToday {
    final box = _boxOrNull;
    if (box == null) return 0;
    final today = DateTime.now();
    return box.values
        .where((s) =>
            s.completed &&
            s.startTime.year == today.year &&
            s.startTime.month == today.month &&
            s.startTime.day == today.day)
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  void startWorkSession() {
    _state = FocusTimerState.work;
    _remainingSeconds = AppConstants.defaultWorkMinutes * 60;
    _sessionStartTime = DateTime.now();
    _startCountdown();
    notifyListeners();
  }

  void startBreak({bool isLong = false}) {
    _state = isLong ? FocusTimerState.longBreak : FocusTimerState.shortBreak;
    final minutes =
        isLong ? AppConstants.defaultLongBreakMinutes : AppConstants.defaultShortBreakMinutes;
    _remainingSeconds = minutes * 60;
    _sessionStartTime = DateTime.now();
    _startCountdown();
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _state = FocusTimerState.paused;
    notifyListeners();
  }

  void resume() {
    if (_state == FocusTimerState.paused) {
      _state = FocusTimerState.work;
      _startCountdown();
      notifyListeners();
    }
  }

  void reset() {
    _timer?.cancel();
    _state = FocusTimerState.idle;
    _remainingSeconds = AppConstants.defaultWorkMinutes * 60;
    _sessionCount = 0;
    _sessionStartTime = null;
    notifyListeners();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        _onSessionComplete();
      }
    });
  }

  Future<void> _onSessionComplete() async {
    if (_state == FocusTimerState.work && _sessionStartTime != null) {
      _sessionCount++;
      final session = FocusSession(
        id: const Uuid().v4(),
        startTime: _sessionStartTime!,
        endTime: DateTime.now(),
        durationMinutes: AppConstants.defaultWorkMinutes,
        completed: true,
      );
      final box = _boxOrNull;
      if (box != null) {
        await box.add(session);
      }
    }

    if (_state == FocusTimerState.work) {
      final isLongBreak = _sessionCount % 4 == 0;
      startBreak(isLong: isLongBreak);
    } else {
      _state = FocusTimerState.idle;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
