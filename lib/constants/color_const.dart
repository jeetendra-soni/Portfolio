import 'dart:math';

import 'package:flutter/material.dart';

class AppColor{
  static Color randomShadowColor() {
    final random = Random();

    switch (random.nextInt(9)) {
      case 0:
        return Color(0xFF02569B);
      case 1:
        return Color(0xFF0175C2);
      case 2:
        return Color(0xFF673AB7);
      case 3:
        return Color(0xFF4CAF50);
      case 4:
        return Color(0xFF009688);
      case 5:
        return Color(0xFF3F51B5);
      case 6:
        return Color(0xFFE91E63);
      case 7:
        return Color(0xFFFFCA28);
      case 8:
        return Color(0xFF607D8B);
      default:
        return Color(0xFF3DDC84);
    }
  }
}