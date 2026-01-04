import 'package:hive/hive.dart';

part 'focus_session.g.dart';

@HiveType(typeId: 5)
class FocusSession {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  DateTime endTime;

  @HiveField(3)
  int durationMinutes;

  @HiveField(4)
  bool completed;

  FocusSession({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.completed = false,
  });
}
