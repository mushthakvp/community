import 'package:flutter/material.dart';

class VCartColors {
  static const Color primary = Color(0xFFF0B90A);
  static const Color secondary = Color(0xFF9DB2CE);
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFF75555);
  static const Color success = Color(0xFF00D48D);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF007AFF);

  // Semantic colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFACACAC);
  static const Color textTertiary = Color(0xFF9796A1);
  static const Color border = Color(0xFF2A2A2A);
  static const Color borderLight = Color(0xFF404040);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color divider = Color(0xFF333333);

  // Opacity variants
  static Color primaryOpacity(double opacity) => primary.withOpacity(opacity);
  static Color backgroundOpacity(double opacity) =>
      background.withOpacity(opacity);
  static Color surfaceOpacity(double opacity) => surface.withOpacity(opacity);
}
