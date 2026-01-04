import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/focus_provider.dart';
import '../../providers/habit_provider.dart';
import '../../providers/statistics_provider.dart';
import '../../providers/task_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductivityScore(context),
              const SizedBox(height: 24),
              _buildStatsGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductivityScore(BuildContext context) {
    return Consumer4<StatisticsProvider, TaskProvider, HabitProvider,
        FocusProvider>(
      builder: (context, statsProv, taskProv, habitProv, focusProv, _) {
        // Recalculate score
        WidgetsBinding.instance.addPostFrameCallback((_) {
          statsProv.recalculateScore(
            tasksCompleted: taskProv.completedTodayCount,
            habitStreak: habitProv.currentStreak,
            focusMinutes: focusProv.totalFocusMinutesToday,
          );
        });

        return Center(
          child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.gradientPrimary,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Productivity Score',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${statsProv.productivityScore}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                      ),
                ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
                Text(
                  'Out of 100',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),        ),        );
      },
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Consumer3<TaskProvider, HabitProvider, FocusProvider>(
      builder: (context, taskProv, habitProv, focusProv, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              context,
              'Tasks Completed',
              '${taskProv.completedTodayCount}',
              Icons.check_circle,
              AppColors.success,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              context,
              'Current Streak',
              '${habitProv.currentStreak} days',
              Icons.local_fire_department,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              context,
              'Focus Time',
              '${focusProv.totalFocusMinutesToday} minutes',
              Icons.timer,
              AppColors.primary,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
