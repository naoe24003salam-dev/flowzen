import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/habit.dart';
import '../../providers/habit_provider.dart';
import 'widgets/habit_dialog.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<HabitProvider>(
          builder: (context, provider, _) {
            final habits = provider.allHabits;

            if (habits.isEmpty) {
              return _buildEmptyState(context);
            }

            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: 30,
                      child: FadeInAnimation(
                        child: _buildHabitCard(context, habits[index], provider),
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
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitCard(BuildContext context, Habit habit, HabitProvider provider) {
    final isCompletedToday = habit.isCompletedToday();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                HapticUtils.mediumImpact();
                provider.deleteHabit(habit.id);
              },
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {
              HapticUtils.mediumImpact();
              provider.toggleHabitToday(habit.id);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(habit.colorValue).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompletedToday ? Icons.check_circle : Icons.circle_outlined,
                      color: Color(habit.colorValue),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (habit.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            habit.description!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: habit.currentStreak > 0 ? Colors.orange : Colors.grey,
                        size: 24,
                      )
                          .animate(
                            onPlay: (controller) =>
                                habit.currentStreak > 0 ? controller.repeat() : null,
                          )
                          .shimmer(duration: 1.5.seconds),
                      Text(
                        '${habit.currentStreak}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
          Icon(Icons.track_changes, size: 80, color: AppColors.textTertiary)
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(delay: 200.ms),
          const SizedBox(height: 24),
          Text(
            'No habits yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 8),
          Text(
            'Start building better habits today!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                ),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    HapticUtils.mediumImpact();
    showDialog(
      context: context,
      builder: (_) => const HabitDialog(),
    );
  }
}
