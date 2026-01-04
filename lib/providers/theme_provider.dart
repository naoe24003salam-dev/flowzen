import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // Call this AFTER Hive is initialized
  Future<void> loadSavedTheme() async {
    try {
      if (!Hive.isBoxOpen(AppConstants.settingsBox)) return;
      
      final box = Hive.box(AppConstants.settingsBox);
      final themeName = box.get('themeMode', defaultValue: 'system') as String;
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.name == themeName,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    try {
      if (Hive.isBoxOpen(AppConstants.settingsBox)) {
        final box = Hive.box(AppConstants.settingsBox);
        await box.put('themeMode', mode.name);
      }
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
}
