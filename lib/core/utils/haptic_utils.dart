import 'package:flutter/services.dart';

class HapticUtils {
  HapticUtils._();

  static Future<void> lightImpact() => HapticFeedback.lightImpact();

  static Future<void> mediumImpact() => HapticFeedback.mediumImpact();

  static Future<void> selection() => HapticFeedback.selectionClick();
}
