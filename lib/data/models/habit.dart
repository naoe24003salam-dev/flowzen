import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 2)
class Habit {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String iconName;

  @HiveField(4)
  int colorValue;

  @HiveField(5)
  List<String> completedDates;

  @HiveField(6)
  int currentStreak;

  @HiveField(7)
  int longestStreak;

  @HiveField(8)
  String category;

  Habit({
    required this.id,
    required this.name,
    this.description,
    this.iconName = 'star',
    this.colorValue = 0xFF6B4CE6,
    List<String>? completedDates,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.category = 'General',
  }) : completedDates = completedDates ?? [];

  bool isCompletedToday() {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    return completedDates.contains(todayKey);
  }
}
