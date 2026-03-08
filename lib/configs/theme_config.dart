import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/configs/app_fonts.dart';

/// AppTheme manages the visual identity of the application.
/// It uses Material 3, ColorScheme.fromSeed, and local fonts
/// to ensure a premium, modern, and professional UI.
class AppTheme {
  static const Color primary = Colors.orangeAccent;
  // Brand Colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color secondaryCyan = Color(0xFF00ACC1);

  // Surface Colors for Dark Mode
  static const Color darkBackground = Color(0xFF030014);
  static const Color darkSurface = Color(0xFF0F172A);

  /// Generates the theme based on brightness and screen width.
  static ThemeData createTheme({
    required Brightness brightness,
    required double screenWidth,
  }) {
    final isDark = brightness == Brightness.dark;

    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: brightness,
      primary: primaryBlue,
      secondary: secondaryCyan,
      surface: isDark ? darkSurface : Colors.white,
      background: isDark ? darkBackground : const Color(0xFFF8FAFC),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: colorScheme.background,

      // --- Font Configuration ---
      // We use local 'Inter' font via AppFonts.
      textTheme: AppFonts.interTextTheme(colorScheme),

      // --- AppBar Theme ---
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: isDark ? darkBackground.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground,
        ),
        iconTheme: IconThemeData(color: colorScheme.onBackground),
      ),

      // --- Card Theme ---
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        color: colorScheme.surface,
      ),

      // --- Button Themes ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: AppFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: colorScheme.primary),
          textStyle: AppFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      // --- Floating Action Button ---
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // --- Input Decoration (TextFields) ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.black26 : Colors.grey.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: AppFonts.inter(color: colorScheme.onSurface.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),

      // --- Drawer Theme ---
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }
}

class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
}

ThemeData getResponsiveTheme(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return AppTheme.createTheme(
    brightness: Brightness.light, 
    screenWidth: width,
  );
}