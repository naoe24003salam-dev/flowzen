import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';
import '../data/models/note.dart';

class NoteProvider with ChangeNotifier {
  Box<Note>? get _boxOrNull {
    try {
      return Hive.isBoxOpen(AppConstants.notesBox) 
          ? Hive.box<Note>(AppConstants.notesBox)
          : null;
    } catch (e) {
      debugPrint('Error accessing notes box: $e');
      return null;
    }
  }

  List<Note> get allNotes {
    final box = _boxOrNull;
    if (box == null) return [];
    final notes = box.values.toList()
      ..sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
    return notes;
  }

  Future<void> addNote(Note note) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.put(note.id, note);
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    final box = _boxOrNull;
    if (box == null) return;
    note.updatedAt = DateTime.now();
    await box.put(note.id, note);
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    final box = _boxOrNull;
    if (box == null) return;
    await box.delete(id);
    notifyListeners();
  }

  Future<void> togglePin(String id) async {
    final box = _boxOrNull;
    if (box == null) return;
    final note = box.get(id);
    if (note != null) {
      note.isPinned = !note.isPinned;
      await box.put(id, note);
      notifyListeners();
    }
  }
}
