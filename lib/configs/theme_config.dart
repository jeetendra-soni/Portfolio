import 'package:flutter/material.dart';

/// AppTheme manages the visual identity of the application.
/// It uses Material 3, ColorScheme.fromSeed, and component-level theming
/// to ensure a consistent and scalable UI across Light and Dark modes.
class AppTheme {
  // Brand Colors
  static const Color primary = Colors.orange;
  static const Color secondary = Color(0xFF00ACC1);

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
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      secondary: secondary,
      surface: isDark ? darkSurface : Colors.white,
      background: isDark ? darkBackground : const Color(0xFFF8FAFC),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: colorScheme.background,

      // --- AppBar Theme ---
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: isDark ? darkBackground.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
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
          foregroundColor: colorScheme.onPrimary,
        ).copyWith(
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: colorScheme.primary),
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
        labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
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

      // --- Typography ---
      textTheme: _buildTextTheme(colorScheme, screenWidth),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme, double width) {
    final bool isLargeScreen = width > 1024;
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: isLargeScreen ? 64 : 48,
        fontWeight: FontWeight.w900,
        color: colorScheme.onBackground,
        letterSpacing: -1.5,
      ),
      headlineLarge: TextStyle(
        fontSize: isLargeScreen ? 40 : 32,
        fontWeight: FontWeight.bold,
        color: colorScheme.onBackground,
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        height: 1.6,
        color: colorScheme.onBackground.withOpacity(0.8),
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        height: 1.5,
        color: colorScheme.onBackground.withOpacity(0.6),
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
  // This helper function remains for compatibility with your current lib/main.dart
  return AppTheme.createTheme(
    brightness: Brightness.light, 
    screenWidth: width,
  );
}