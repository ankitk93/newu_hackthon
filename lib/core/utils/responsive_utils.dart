import 'package:flutter/material.dart';

/// Provides responsive scaling for font sizes and spacing on wider viewports.
/// Mobile sizes are the baseline (1.0x); tablets and desktops scale up.
class Responsive {
  Responsive._();

  static double scaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 1.3;
    if (width >= 800) return 1.15;
    return 1.0;
  }

  static double fontSize(BuildContext context, double base) {
    return base * scaleFactor(context);
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= 600 && w < 1200;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;
}
