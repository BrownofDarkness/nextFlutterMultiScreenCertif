import 'package:flutter/material.dart';

/// Gourmet Canvas palette — Material 3 tokens.
class AppColors {
  AppColors._();

  // Light tokens
  static const Color primary = Color(0xFF9E3D00);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFC64F00);
  static const Color onPrimaryContainer = Color(0xFFFFFBFF);

  static const Color secondary = Color(0xFF4E6073);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFCFE2F9);
  static const Color onSecondaryContainer = Color(0xFF526478);

  static const Color tertiary = Color(0xFF605C50);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF797468);
  static const Color onTertiaryContainer = Color(0xFFFFFBFF);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color surface = Color(0xFFFCF9F8);
  static const Color onSurface = Color(0xFF1C1B1B);
  static const Color onSurfaceVariant = Color(0xFF594238);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainer = Color(0xFFF0EDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE7E7);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E1);

  static const Color outline = Color(0xFF8C7166);
  static const Color outlineVariant = Color(0xFFE0C0B2);
  static const Color inverseSurface = Color(0xFF313030);
  static const Color inverseOnSurface = Color(0xFFF3F0EF);
  static const Color inversePrimary = Color(0xFFFFB595);

  // Backwards-compat aliases (kept while we migrate call-sites)
  static const Color primaryColor = primary;
  static const Color secondaryColor = secondary;
  static const Color tertiaryColor = Color(0xFFFDF5E6);
  static const Color backgroundColor = surface;
  static const Color textColor = onSurface;
  static const Color neutralColor = Color(0xFF1A1A1A);
}
