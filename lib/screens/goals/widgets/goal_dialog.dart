import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/models/goal.dart';
import '../../../providers/goal_provider.dart';

class GoalDialog extends StatefulWidget {
  const GoalDialog({super.key});

  @override
  State<GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<GoalDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  GoalType _type = GoalType.shortTerm;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Goal',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Goal title',
                prefixIcon: Icon(Icons.flag),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description (optional)',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Type: '),
                const SizedBox(width: 12),
                Expanded(
                  child: SegmentedButton<GoalType>(
                    segments: const [
                      ButtonSegment(
                        value: GoalType.shortTerm,
                        label: Text('Short-term'),
                      ),
                      ButtonSegment(
                        value: GoalType.longTerm,
                        label: Text('Long-term'),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (Set<GoalType> selected) {
                      HapticUtils.selection();
                      setState(() => _type = selected.first);
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
                  onPressed: _addGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Goal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addGoal() {
    if (_titleController.text.trim().isEmpty) return;
    HapticUtils.mediumImpact();

    final goal = Goal(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      type: _type,
      createdAt: DateTime.now(),
    );

    Provider.of<GoalProvider>(context, listen: false).addGoal(goal);
    Navigator.of(context).pop();
  }
}
