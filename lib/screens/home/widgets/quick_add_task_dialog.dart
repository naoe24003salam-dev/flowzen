import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/models/task.dart';
import '../../../providers/task_provider.dart';

class QuickAddTaskDialog extends StatefulWidget {
  const QuickAddTaskDialog({super.key});

  @override
  State<QuickAddTaskDialog> createState() => _QuickAddTaskDialogState();
}

class _QuickAddTaskDialogState extends State<QuickAddTaskDialog> {
  final _controller = TextEditingController();
  Priority _priority = Priority.medium;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Add Task',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'What needs to be done?',
                prefixIcon: Icon(Icons.task_alt),
              ),
              onSubmitted: (_) => _addTask(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Priority: '),
                const SizedBox(width: 8),
                Expanded(
                  child: SegmentedButton<Priority>(
                    segments: const [
                      ButtonSegment(value: Priority.low, label: Text('Low')),
                      ButtonSegment(value: Priority.medium, label: Text('Mid')),
                      ButtonSegment(value: Priority.high, label: Text('High')),
                    ],
                    selected: {_priority},
                    onSelectionChanged: (Set<Priority> selected) {
                      HapticUtils.selection();
                      setState(() => _priority = selected.first);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;
    HapticUtils.mediumImpact();

    final task = Task(
      id: const Uuid().v4(),
      title: _controller.text.trim(),
      createdAt: DateTime.now(),
      priority: _priority,
    );

    Provider.of<TaskProvider>(context, listen: false).addTask(task);
    Navigator.of(context).pop();
  }
}
