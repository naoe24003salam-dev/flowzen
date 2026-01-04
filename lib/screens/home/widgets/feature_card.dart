import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../notes/notes_screen.dart';
import '../../planner/planner_screen.dart';
import '../../settings/settings_screen.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          HapticUtils.lightImpact();
          _navigateTo(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context) {
    Widget? screen;
    switch (route) {
      case '/notes':
        screen = const NotesScreen();
        break;
      case '/planner':
        screen = const PlannerScreen();
        break;
      case '/settings':
        screen = const SettingsScreen();
        break;
      case '/insights':
        // Could navigate to analytics or separate insights
        break;
    }
    if (screen != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen!));
    }
  }
}
