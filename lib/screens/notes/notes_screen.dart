import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/note.dart';
import '../../providers/note_provider.dart';
import 'widgets/note_editor_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Notes'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<NoteProvider>(
          builder: (context, provider, _) {
            final notes = provider.allNotes;

            if (notes.isEmpty) {
              return _buildEmptyState(context);
            }

            return AnimationLimiter(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 2,
                    duration: const Duration(milliseconds: 400),
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: _buildNoteCard(context, notes[index], provider),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNote(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note, NoteProvider provider) {
    return GestureDetector(
      onTap: () {
        HapticUtils.lightImpact();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NoteEditorScreen(note: note),
          ),
        );
      },
      child: Card(
        color: Color(note.colorValue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (note.isPinned)
                    const Icon(Icons.push_pin, size: 16, color: Colors.black54),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      HapticUtils.mediumImpact();
                      _showDeleteConfirmation(context, note, provider);
                    },
                    child: const Icon(Icons.delete_outline, size: 20, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (note.title.isNotEmpty) ...[
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black87,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
              Expanded(
                child: Text(
                  note.content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note, size: 80, color: AppColors.textTertiary)
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(delay: 200.ms),
          const SizedBox(height: 24),
          Text(
            'No notes yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 8),
          Text(
            'Capture your thoughts and ideas!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }

  void _createNote(BuildContext context) {
    HapticUtils.mediumImpact();
    final note = Note(
      id: const Uuid().v4(),
      content: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Note note, NoteProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteNote(note.id);
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
