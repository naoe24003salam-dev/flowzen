import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../providers/theme_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/habit_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/note_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildQuickStats(context),
            const SizedBox(height: 24),
            _buildThemeSection(context),
            const SizedBox(height: 16),
            _buildDataSection(context),
            const SizedBox(height: 16),
            _buildNotificationSection(context),
            const SizedBox(height: 16),
            _buildHelpSection(context),
            const SizedBox(height: 16),
            _buildAboutSection(context),
          ],
        ).animate().fadeIn(duration: 400.ms),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Consumer4<TaskProvider, HabitProvider, GoalProvider, NoteProvider>(
      builder: (context, taskProv, habitProv, goalProv, noteProv, _) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.gradientPrimary,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      context,
                      'Tasks',
                      taskProv.allTasks.length.toString(),
                      Icons.task_alt,
                    ),
                    _buildStatColumn(
                      context,
                      'Habits',
                      habitProv.allHabits.length.toString(),
                      Icons.track_changes,
                    ),
                    _buildStatColumn(
                      context,
                      'Goals',
                      goalProv.allGoals.length.toString(),
                      Icons.flag,
                    ),
                    _buildStatColumn(
                      context,
                      'Notes',
                      noteProv.allNotes.length.toString(),
                      Icons.note,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: 400.ms).scale(delay: 100.ms);
  }

  Widget _buildStatColumn(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<ThemeProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Light Mode'),
                      subtitle: const Text('Always use light theme'),
                      value: ThemeMode.light,
                      groupValue: provider.themeMode,
                      onChanged: (mode) {
                        if (mode != null) {
                          HapticUtils.selection();
                          provider.setThemeMode(mode);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Always use dark theme'),
                      value: ThemeMode.dark,
                      groupValue: provider.themeMode,
                      onChanged: (mode) {
                        if (mode != null) {
                          HapticUtils.selection();
                          provider.setThemeMode(mode);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('System Default'),
                      subtitle: const Text('Follow system theme'),
                      value: ThemeMode.system,
                      groupValue: provider.themeMode,
                      onChanged: (mode) {
                        if (mode != null) {
                          HapticUtils.selection();
                          provider.setThemeMode(mode);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storage, color: AppColors.secondary),
                const SizedBox(width: 12),
                Text(
                  'Data Management',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.download, color: AppColors.success),
              title: const Text('Export Data'),
              subtitle: const Text('Backup all your data'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticUtils.mediumImpact();
                _showExportDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload, color: AppColors.primary),
              title: const Text('Import Data'),
              subtitle: const Text('Restore from backup'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticUtils.mediumImpact();
                _showImportDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: AppColors.error),
              title: const Text('Clear All Data'),
              subtitle: const Text('Permanently delete everything'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticUtils.mediumImpact();
                _showClearDataDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications, color: AppColors.warning),
                const SizedBox(width: 12),
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Task Reminders'),
              subtitle: const Text('Get notified about upcoming tasks'),
              value: true,
              onChanged: (value) {
                HapticUtils.selection();
                // TODO: Implement notification toggle
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature coming soon!')),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Habit Reminders'),
              subtitle: const Text('Daily habit check-in reminders'),
              value: true,
              onChanged: (value) {
                HapticUtils.selection();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature coming soon!')),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Focus Session'),
              subtitle: const Text('Notifications during focus time'),
              value: false,
              onChanged: (value) {
                HapticUtils.selection();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.help_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Help & Support',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.book, color: AppColors.primary),
              title: const Text('User Guide'),
              subtitle: const Text('Learn how to use FlowZen'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticUtils.mediumImpact();
                _showUserGuide(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tips_and_updates, color: AppColors.secondary),
              title: const Text('Quick Tips'),
              subtitle: const Text('Productivity tips & tricks'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticUtils.mediumImpact();
                _showTipsDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.success),
              title: const Text('Share FlowZen'),
              subtitle: const Text('Tell your friends'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticUtils.mediumImpact();
                Share.share(
                  'Check out FlowZen - Your Mindful Productivity Companion!\\n\\nStay focused, build better habits, and achieve your goals.',
                  subject: 'FlowZen App',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.spa, color: AppColors.primary, size: 24),
              ),
              title: const Text('FlowZen'),
              subtitle: const Text('Your Mindful Productivity Companion'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.code, color: AppColors.secondary),
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: AppColors.error),
              title: const Text('Made with Love'),
              subtitle: const Text('For productive minds everywhere'),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '© 2026 FlowZen. All rights reserved.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your data will be exported as a JSON file.'),
            SizedBox(height: 16),
            Text('This includes:'),
            SizedBox(height: 8),
            Text('• All tasks'),
            Text('• All habits'),
            Text('• All goals'),
            Text('• All notes'),
            Text('• Focus sessions'),
            Text('• App settings'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon!')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, size: 48, color: AppColors.warning),
            SizedBox(height: 16),
            Text('Importing will replace all current data.'),
            SizedBox(height: 8),
            Text('Make sure you have a backup before continuing.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Import feature coming soon!')),
              );
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_forever, size: 64, color: AppColors.error),
            SizedBox(height: 16),
            Text(
              'This will permanently delete ALL your data!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('This action cannot be undone.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              final taskProv = Provider.of<TaskProvider>(context, listen: false);
              final habitProv = Provider.of<HabitProvider>(context, listen: false);
              final goalProv = Provider.of<GoalProvider>(context, listen: false);
              final noteProv = Provider.of<NoteProvider>(context, listen: false);
              
              // Clear all data
              for (var task in taskProv.allTasks) {
                await taskProv.deleteTask(task.id);
              }
              for (var habit in habitProv.allHabits) {
                await habitProv.deleteHabit(habit.id);
              }
              for (var goal in goalProv.allGoals) {
                await goalProv.deleteGoal(goal.id);
              }
              for (var note in noteProv.allNotes) {
                await noteProv.deleteNote(note.id);
              }
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _showUserGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Guide'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGuideSection('📋 Tasks', 'Create and manage your daily tasks with priorities and due dates.'),
              _buildGuideSection('⏱️ Focus Timer', 'Use the Pomodoro technique to stay focused. 25-minute focus sessions followed by 5-minute breaks.'),
              _buildGuideSection('🎯 Habits', 'Build consistent habits. Track your streaks and stay motivated.'),
              _buildGuideSection('🏆 Goals', 'Set long-term goals and track your progress towards achieving them.'),
              _buildGuideSection('📝 Notes', 'Quick notes for capturing ideas and important information.'),
              _buildGuideSection('📅 Planner', 'Schedule your tasks in a calendar view with time blocks.'),
              _buildGuideSection('📊 Analytics', 'View your productivity score and activity statistics.'),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideSection(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(description),
        ],
      ),
    );
  }

  void _showTipsDialog(BuildContext context) {
    final tips = [
      '💡 Start your day by setting 3 priority tasks',
      '🎯 Focus on one thing at a time - multitasking reduces productivity',
      '⏰ Use the Pomodoro timer for deep work sessions',
      '✅ Complete your most important task first thing in the morning',
      '📊 Review your weekly progress every Sunday',
      '🔄 Build habits slowly - start with just 2 minutes a day',
      '📝 Write down ideas immediately - don\'t trust your memory',
      '🎨 Customize your theme to match your mood',
      '🏆 Celebrate small wins to stay motivated',
      '💪 Consistency beats intensity - show up every day',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Productivity Tips'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(tip),
            )).toList(),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Thanks!'),
          ),
        ],
      ),
    );
  }
}
