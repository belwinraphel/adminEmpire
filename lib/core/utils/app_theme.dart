import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F0F12), // Deep dark background
    primaryColor: const Color(0xFF6C63FF), // Vibrant purple
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6C63FF),
      secondary: Color(0xFF00C853), // Success green
      surface: Color(0xFF1E1E24), // Card background

      error: Color(0xFFCF6679),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyMedium: const TextStyle(fontSize: 14, color: Color(0xFFB0B0C0)),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E24),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFB0B0C0)),
    dividerColor: const Color(0xFF2C2C35),
  );
}
