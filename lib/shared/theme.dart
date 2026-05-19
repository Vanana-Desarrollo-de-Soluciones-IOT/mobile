import 'package:flutter/material.dart';

class AppTheme {
  // Global Palette & Backgrounds
  static const Color pageBackground = Color(0xFF000000);
  static const Color cardBackground = Color(0xFF141414);
  static const Color cardBorder = Color(0xFF2A2A2A);
  static final Color cardShadow = const Color(0xFF000000).withOpacity(0.6);

  // Typography
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF9CA3AF);
  static const Color linkDefault = Color(0xFFE5E7EB);
  static const Color linkHighlight = Color(0xFFFFFFFF);
  static const Color authCallbackLink = Color(0xFF4DABF7);

  // Buttons
  static const Color primaryButtonBg = Color(0xFF262626);
  static const Color primaryButtonHover = Color(0xFF333333);
  static const Color primaryButtonDisabled = Color(0xFF1F1F1F);
  static const Color primaryButtonTextActive = Color(0xFFFFFFFF);
  static const Color primaryButtonTextDisabled = Color(0xFF666666);
  
  static const Color socialButtonBorder = Color(0xFF3A3A3A);
  static const Color socialButtonBorderHover = Color(0xFF4A4A4A);

  // Status & Feedback Messages
  static const Color errorText = Color(0xFFEF4444);
  static const Color successText = Color(0xFF22C55E);

  // Miscellaneous
  static const Color dividerLine = Color(0xFF2A2A2A);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: pageBackground,
      cardColor: cardBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryButtonBg,
        surface: cardBackground,
        error: errorText,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: primaryText, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: primaryText, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: primaryText),
        bodyMedium: TextStyle(color: secondaryText),
        labelLarge: TextStyle(color: primaryText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pageBackground,
        hintStyle: const TextStyle(color: secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: secondaryText),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorText),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryButtonBg,
          foregroundColor: primaryButtonTextActive,
          disabledBackgroundColor: primaryButtonDisabled,
          disabledForegroundColor: primaryButtonTextDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
