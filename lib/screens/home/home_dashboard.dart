import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/utils/haptic_utils.dart';
import '../../providers/focus_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/habit_provider.dart';
import '../../providers/task_provider.dart';
import 'widgets/feature_card.dart';
import 'widgets/quick_add_task_dialog.dart';
import 'widgets/stat_card.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStatsGrid(context),
                  const SizedBox(height: 24),
                  _buildFeaturesGrid(context),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Quick Add'),
      ).animate().scale(delay: 500.ms, duration: 400.ms),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.gradientPrimary),
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateTimeUtils.greeting(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ).animate().fadeIn(duration: 600.ms),
              const SizedBox(height: 4),
              Text(
                DateTimeUtils.friendlyDate(DateTime.now()),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Consumer4<TaskProvider, HabitProvider, FocusProvider, GoalProvider>(
      builder: (context, taskProv, habitProv, focusProv, goalProv, _) {
        return AnimationLimiter(
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 400),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 30,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                StatCard(
                  icon: Icons.check_circle,
                  label: 'Tasks Done',
                  value: taskProv.completedTodayCount.toString(),
                  gradient: AppColors.gradientSuccess,
                ),
                StatCard(
                  icon: Icons.local_fire_department,
                  label: 'Streak',
                  value: '${habitProv.currentStreak}d',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                StatCard(
                  icon: Icons.timer,
                  label: 'Focus Time',
                  value: '${focusProv.totalFocusMinutesToday}m',
                  gradient: AppColors.gradientPrimary,
                ),
                StatCard(
                  icon: Icons.flag,
                  label: 'Active Goals',
                  value: goalProv.activeGoalsCount.toString(),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 400),
          delay: const Duration(milliseconds: 200),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 40,
            child: FadeInAnimation(child: widget),
          ),
          children: const [
            FeatureCard(
              icon: Icons.note_outlined,
              label: 'Quick Notes',
              route: '/notes',
            ),
            FeatureCard(
              icon: Icons.calendar_today,
              label: 'Daily Planner',
              route: '/planner',
            ),
            FeatureCard(
              icon: Icons.settings,
              label: 'Settings',
              route: '/settings',
            ),
            FeatureCard(
              icon: Icons.insights,
              label: 'Insights',
              route: '/insights',
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickAddDialog(BuildContext context) {
    HapticUtils.mediumImpact();
    showDialog(
      context: context,
      builder: (_) => const QuickAddTaskDialog(),
    );
  }
}
