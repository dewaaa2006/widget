import 'package:flutter/animation.dart';

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
}

class AppCurves {
  static const Cubic easeOutQuart = Cubic(0.25, 1, 0.25, 1);
  static const Cubic easeInOutQuart = Cubic(0.77, 0, 0.175, 1);
  static const Cubic easeOutQuad = Cubic(0.25, 0.46, 0.45, 0.94);
  static const Cubic easeOutCirc = Cubic(0, 0.55, 0.45, 1);
  static const Cubic smooth = Cubic(0.4, 0, 0.2, 1);
}
