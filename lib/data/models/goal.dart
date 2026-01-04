import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 3)
enum GoalType {
  @HiveField(0)
  shortTerm,
  @HiveField(1)
  longTerm,
}

@HiveType(typeId: 4)
class Goal {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  GoalType type;

  @HiveField(4)
  int progress;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? deadline;

  @HiveField(7)
  String category;

  Goal({
    required this.id,
    required this.title,
    this.description,
    this.type = GoalType.shortTerm,
    this.progress = 0,
    required this.createdAt,
    this.deadline,
    this.category = 'General',
  });
}
