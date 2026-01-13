import 'package:flutter/material.dart';

class AppTheme {
  // ================= DARK THEME =================
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F0F0F),
    cardColor: const Color(0xFF1A1A1A),
    primaryColor: const Color(0xFF7B4DFF),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7B4DFF),
      secondary: Color(0xFF7B4DFF),
      background: Color(0xFF0F0F0F),
      surface: Color(0xFF1A1A1A),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0F0F0F),
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIconColor: Colors.white54,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7B4DFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );

  // ================= LIGHT THEME =================
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF6F6F6),
    cardColor: Colors.white,
    primaryColor: const Color(0xFF7B4DFF),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF7B4DFF),
      secondary: Color(0xFF7B4DFF),
      background: Color(0xFFF6F6F6),
      surface: Colors.white,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black54),
      prefixIconColor: Colors.black45,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7B4DFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}
