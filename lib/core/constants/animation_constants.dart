import 'package:flutter/material.dart';

class AnimationConstants {
  AnimationConstants._();

  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
  static const Curve defaultCurve = Curves.easeInOutCubic;
}
