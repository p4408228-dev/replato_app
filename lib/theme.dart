import 'package:flutter/material.dart';

class ReplatoColors {
  static const creamBeige    = Color(0xFFF5EFE6);
  static const softCream     = Color(0xFFFFF9F0);
  static const tealGreen     = Color(0xFF1F6F5F);
  static const mustardYellow = Color(0xFFE5A824);
  static const crimsonRed    = Color(0xFFB22234);
  static const oliveGreen    = Color(0xFF6B7A3D);
  static const charcoal      = Color(0xFF2B2B2B);
  static const mutedText     = Color(0xFF6E6A63);
}

class ReplatoTheme {
  static ThemeData light() {
    return ThemeData(
      scaffoldBackgroundColor: ReplatoColors.creamBeige,
      primaryColor: ReplatoColors.tealGreen,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.light(
        primary: ReplatoColors.tealGreen,
        secondary: ReplatoColors.mustardYellow,
        surface: ReplatoColors.softCream,
        error: ReplatoColors.crimsonRed,
        onPrimary: Colors.white,
        onSecondary: ReplatoColors.charcoal,
        onSurface: ReplatoColors.charcoal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ReplatoColors.tealGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ReplatoColors.tealGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ReplatoColors.softCream,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ReplatoColors.oliveGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ReplatoColors.oliveGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ReplatoColors.tealGreen, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: ReplatoColors.softCream,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}