import 'package:flutter/material.dart';

/// App color palette — exact Figma hex values.
class AppColors {
  AppColors._();

  // ─── Background Gradients ───
  static const Color backgroundLight = Color(0xFFE8D7F1);
  static const Color backgroundLightEnd = Color(0xFFF5E0D0);
  static const Color backgroundDark = Color(0xFF1A1128);
  static const Color backgroundDarkEnd = Color(0xFF2D1B4E);

  // ─── Brand Gradient (buttons) ───
  static const Color gradientStart = Color(0xFFFF8A00);
  static const Color gradientEnd = Color(0xFF6C0862);

  // ─── Primary Text ───
  static const Color textPrimary = Color(0xFF141414);
  static const Color textSecondary = Color(0xFF737373);

  // ─── Dark mode text ───
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFD4D4D4);

  // ─── Chips (Light) ───
  static const Color chipUnselectedBg = Color(0xFFF5F5F5);
  static const Color chipUnselectedText = Color(0xFF737373);
  // no border for unselected
  static const Color chipSelectedBg = Color(0xFFFFF8F0);
  static const Color chipSelectedBorder = Color(0xFFE47B00);
  static const Color chipSelectedText = Color(0xFFE47B00);

  // ─── Chips (Dark) ───
  static const Color chipUnselectedBgDark = Color(0xFF383840);
  static const Color chipUnselectedTextDark = Color(0xFFD4D4D4);
  static const Color chipSelectedBgDark = Color(0xFF3D2E1A);
  static const Color chipSelectedBorderDark = Color(0xFFE47B00);
  static const Color chipSelectedTextDark = Color(0xFFE47B00);

  // ─── Phase Control (Light) ───
  static const Color controlBgLight = Color(0xFFF5F5F5);
  static const Color controlButtonLight = Color(0xFFFFFFFF);
  static const Color controlIconLight = Color(0xFF141414);

  // ─── Phase Control (Dark) ───
  static const Color controlBgDark = Color(0xFF383840);
  static const Color controlButtonDark = Color(0x26FFFFFF);    // white 15%
  static const Color controlIconDark = Color(0xFFFFFFFF);

  // ─── Card ───
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0x14FFFFFF);  // white 8%

  // ─── Switch ───
  static const Color switchTrack = Color(0xFF6C0862);

  // ─── Misc ───
  static const Color success = Color(0xFF4CAF50);
  static const Color accent = Color(0xFF7C4DFF);
  static const Color backToSetup = Color(0xFF6C0862);

  // ─── Bubble (Dark Get Ready) ───
  static const Color bubbleBgDark = Color(0xFF383840);
}
