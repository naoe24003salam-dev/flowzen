import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../data/models/goal.dart';
import '../../providers/goal_provider.dart';
import 'widgets/goal_dialog.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<GoalProvider>(
          builder: (context, provider, _) {
            final goals = provider.allGoals;

            if (goals.isEmpty) {
              return _buildEmptyState(context);
            }

            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: 30,
                      child: FadeInAnimation(
                        child: _buildGoalCard(context, goals[index], provider),
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

  Widget _buildGoalCard(BuildContext context, Goal goal, GoalProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                HapticUtils.mediumImpact();
                provider.deleteGoal(goal.id);
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: goal.progress == 100
                            ? AppColors.success.withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${goal.progress}%',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: goal.progress == 100
                                  ? AppColors.success
                                  : AppColors.primary,
                            ),
                      ),
                    ),
                  ],
                ),
                if (goal.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    goal.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: goal.progress / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      goal.progress == 100 ? AppColors.success : AppColors.primary,
                    ),
                  ),
                )
                    .animate()
                    .slideX(duration: 600.ms, curve: Curves.easeOut),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      goal.type == GoalType.shortTerm
                          ? Icons.today
                          : Icons.calendar_month,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      goal.type == GoalType.shortTerm ? 'Short-term' : 'Long-term',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _showProgressDialog(context, goal, provider),
                      child: const Text('Update Progress'),
                    ),
                  ],
                ),
              ],
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
          Icon(Icons.flag, size: 80, color: AppColors.textTertiary)
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(delay: 200.ms),
          const SizedBox(height: 24),
          Text(
            'No goals yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 8),
          Text(
            'Set your first goal and start achieving!',
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
      builder: (_) => const GoalDialog(),
    );
  }

  void _showProgressDialog(BuildContext context, Goal goal, GoalProvider provider) {
    HapticUtils.lightImpact();
    showDialog(
      context: context,
      builder: (ctx) => _ProgressUpdateDialog(goal: goal, provider: provider),
    );
  }
}

class _ProgressUpdateDialog extends StatefulWidget {
  final Goal goal;
  final GoalProvider provider;

  const _ProgressUpdateDialog({required this.goal, required this.provider});

  @override
  State<_ProgressUpdateDialog> createState() => _ProgressUpdateDialogState();
}

class _ProgressUpdateDialogState extends State<_ProgressUpdateDialog> {
  late double _progress;

  @override
  void initState() {
    super.initState();
    _progress = widget.goal.progress.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Progress',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Text(
              '${_progress.toInt()}%',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
            Slider(
              value: _progress,
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: (value) {
                HapticUtils.selection();
                setState(() => _progress = value);
              },
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
                  onPressed: () {
                    HapticUtils.mediumImpact();
                    widget.provider
                        .updateProgress(widget.goal.id, _progress.toInt());
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
