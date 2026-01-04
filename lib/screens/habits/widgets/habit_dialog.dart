import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../data/models/habit.dart';
import '../../../providers/habit_provider.dart';

class HabitDialog extends StatefulWidget {
  const HabitDialog({super.key});

  @override
  State<HabitDialog> createState() => _HabitDialogState();
}

class _HabitDialogState extends State<HabitDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Color _selectedColor = const Color(0xFF6B4CE6);
  String _category = 'Health';

  final List<Color> _colors = const [
    Color(0xFF6B4CE6),
    Color(0xFFFF6B9D),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF3B82F6),
  ];

  final List<String> _categories = const [
    'Health',
    'Work',
    'Personal',
    'Social',
    'Learning',
  ];

  @override
  void dispose() {
    _nameController.dispose();
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
              'New Habit',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Habit name',
                prefixIcon: Icon(Icons.track_changes),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description (optional)',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _categories.map((cat) {
                return ChoiceChip(
                  label: Text(cat),
                  selected: _category == cat,
                  onSelected: (selected) {
                    if (selected) {
                      HapticUtils.selection();
                      setState(() => _category = cat);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Color',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    HapticUtils.selection();
                    setState(() => _selectedColor = color);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppColors.textPrimary, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
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
                  onPressed: _addHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Habit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addHabit() {
    if (_nameController.text.trim().isEmpty) return;
    HapticUtils.mediumImpact();

    final habit = Habit(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      colorValue: _selectedColor.value,
      category: _category,
    );

    Provider.of<HabitProvider>(context, listen: false).addHabit(habit);
    Navigator.of(context).pop();
  }
}
