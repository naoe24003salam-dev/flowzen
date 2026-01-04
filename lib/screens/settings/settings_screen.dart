import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/haptic_utils.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildThemeSection(context),
            const SizedBox(height: 24),
            _buildAboutSection(context),
          ],
        ).animate().fadeIn(duration: 400.ms),
      ),
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
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Consumer<ThemeProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Light Mode'),
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

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info_outline, color: AppColors.primary),
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_outline, color: AppColors.secondary),
              title: const Text('FlowZen'),
              subtitle: const Text('Your Mindful Productivity Companion'),
            ),
          ],
        ),
      ),
    );
  }
}
