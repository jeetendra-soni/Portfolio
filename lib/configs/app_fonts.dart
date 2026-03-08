import 'package:flutter/material.dart';

/// AppFonts provides centralized access to the local font assets.
/// 
/// Ensure all .ttf files are downloaded and placed in 'assets/fonts/'.
class AppFonts {
  AppFonts._();

  static String interFamily = 'Inter';
  static String rowdiesFamily = 'Rowdies';
  static String josefinSansFamily = 'JosefinSans';
  static String dancingScriptFamily = 'DancingScript';
  static String crimsonProFamily = 'CrimsonPro';
  static String aclonicaFamily = 'Aclonica';



  static TextStyle _baseStyle({
    required String family,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle inter({double? fontSize, FontWeight? fontWeight, Color? color, double? letterSpacing, double? height}) {
    return _baseStyle(family: interFamily, fontSize: fontSize, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height);
  }

  static TextStyle rowdies({double? fontSize, FontWeight? fontWeight, Color? color, double? letterSpacing, double? height}) {
    return _baseStyle(family: rowdiesFamily, fontSize: fontSize, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height);
  }

  static TextStyle josefinSans({double? fontSize, FontWeight? fontWeight, Color? color, double? letterSpacing, double? height}) {
    return _baseStyle(family: josefinSansFamily, fontSize: fontSize, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height);
  }

  static TextStyle dancingScript({double? fontSize, FontWeight? fontWeight, Color? color, double? letterSpacing, double? height}) {
    return _baseStyle(family: dancingScriptFamily, fontSize: fontSize, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height);
  }

  static TextStyle crimsonPro({double? fontSize, FontWeight? fontWeight, Color? color, double? letterSpacing, double? height}) {
    return _baseStyle(family: crimsonProFamily, fontSize: fontSize, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height);
  }

  static TextStyle aclonica({double? fontSize, FontWeight? fontWeight, Color? color, double? letterSpacing, double? height}) {
    return _baseStyle(family: aclonicaFamily, fontSize: fontSize, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing, height: height);
  }

  /// Global TextTheme using Inter as the primary body font.
  static TextTheme interTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: inter(fontWeight: FontWeight.w900, color: colorScheme.onBackground),
      displayMedium: inter(fontWeight: FontWeight.w800, color: colorScheme.onBackground),
      headlineLarge: inter(fontWeight: FontWeight.bold, color: colorScheme.onBackground),
      headlineMedium: inter(fontWeight: FontWeight.bold, color: colorScheme.onBackground),
      titleLarge: inter(fontWeight: FontWeight.w700, color: colorScheme.onBackground),
      bodyLarge: inter(height: 1.6, color: colorScheme.onBackground.withOpacity(0.85)),
      bodyMedium: inter(height: 1.5, color: colorScheme.onBackground.withOpacity(0.7)),
      labelLarge: inter(fontWeight: FontWeight.w600, letterSpacing: 1.1),
    );
  }
}