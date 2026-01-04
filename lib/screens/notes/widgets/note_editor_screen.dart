import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/models/note.dart';
import '../../../providers/note_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note note;

  const NoteEditorScreen({super.key, required this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Color _currentColor;

  final List<Color> _noteColors = const [
    Color(0xFFFFFFFF),
    Color(0xFFFFF9C4),
    Color(0xFFFFCCBC),
    Color(0xFFB2DFDB),
    Color(0xFFC5CAE9),
    Color(0xFFF8BBD0),
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _currentColor = Color(widget.note.colorValue);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(
              widget.note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            ),
            onPressed: () {
              HapticUtils.lightImpact();
              Provider.of<NoteProvider>(context, listen: false)
                  .togglePin(widget.note.id);
              setState(() {
                widget.note.isPinned = !widget.note.isPinned;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Container(
        color: _currentColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      hintText: 'Note',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  children: _noteColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        HapticUtils.selection();
                        setState(() => _currentColor = color);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _currentColor == color
                                ? AppColors.primary
                                : Colors.grey.shade300,
                            width: _currentColor == color ? 3 : 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    HapticUtils.mediumImpact();
    widget.note.title = _titleController.text.trim();
    widget.note.content = _contentController.text.trim();
    widget.note.colorValue = _currentColor.value;

    final provider = Provider.of<NoteProvider>(context, listen: false);
    if (widget.note.content.isEmpty) {
      provider.deleteNote(widget.note.id);
    } else {
      if (provider.allNotes.any((n) => n.id == widget.note.id)) {
        provider.updateNote(widget.note);
      } else {
        provider.addNote(widget.note);
      }
    }

    Navigator.of(context).pop();
  }
}
