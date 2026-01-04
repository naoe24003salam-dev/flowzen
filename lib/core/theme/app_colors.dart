import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary gradient palette
  static const Color primary = Color(0xFF6B4CE6);
  static const Color primaryDark = Color(0xFF5538D0);
  static const Color primaryLight = Color(0xFF8B6EF7);

  // Secondary accents
  static const Color secondary = Color(0xFFFF6B9D);
  static const Color secondaryLight = Color(0xFFFF8FB5);

  // Neutrals
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F9);

  // Text
  static const Color textPrimary = Color(0xFF1A1D2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // States
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static const LinearGradient gradientPrimary = LinearGradient(
    colors: [Color(0xFF6B4CE6), Color(0xFF8B6EF7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientSuccess = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
