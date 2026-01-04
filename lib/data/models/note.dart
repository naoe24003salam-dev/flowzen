import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 6)
class Note {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  int colorValue;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  bool isPinned;

  @HiveField(7)
  List<String> tags;

  Note({
    required this.id,
    this.title = '',
    required this.content,
    this.colorValue = 0xFFFFFFFF,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    List<String>? tags,
  }) : tags = tags ?? [];
}
