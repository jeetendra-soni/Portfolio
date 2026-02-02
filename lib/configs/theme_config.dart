import 'package:flutter/material.dart';

/// Breakpoints (common industry standard)
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
}

/// Mobile Theme
final ThemeData mobileTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), bodyLarge: TextStyle(fontSize: 16), bodyMedium: TextStyle(fontSize: 14), bodySmall: TextStyle(fontSize: 12)),
);

/// Tablet Theme
final ThemeData tabletTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), bodyLarge: TextStyle(fontSize: 18), bodyMedium: TextStyle(fontSize: 16), bodySmall: TextStyle(fontSize: 14)),
);

/// Desktop Theme
final ThemeData desktopTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: Colors.blue,
  scaffoldBackgroundColor: Colors.grey.shade50,
  textTheme: const TextTheme(headlineLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.bold), headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), bodyLarge: TextStyle(fontSize: 20), bodyMedium: TextStyle(fontSize: 18), bodySmall: TextStyle(fontSize: 16)),
);

/// Theme selector
ThemeData getResponsiveTheme(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width >= AppBreakpoints.tablet) {
    return desktopTheme;
  } else if (width >= AppBreakpoints.mobile) {
    return tabletTheme;
  } else {
    return mobileTheme;
  }
}
