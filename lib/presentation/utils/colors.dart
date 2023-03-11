import 'package:flutter/material.dart';

class AppColors {
  static const Color scrim = Colors.black26;

  static const Color dashboardBlack = Color(0xFF1D1D1D);

  static const Color backgroundColor = Color(0xFFF6F6FB);

  static const Color whiteColor = Color(0xFFFFFFFF);

  static const Color dashboardOrange = Color(0xBFFF7500);

  static const Color red = Color(0xFFDA100B);
  static const Color scaffold_bg = Color(0xFFFBFBFB);
  static const Color avatar_ring = Color(0xFFF7F8F9);

  static const Color label = Color(0xFF6E7191);
  static const Color outline = Color(0xFFD9DBE9);
  static const Color hint = Color(0xFFA0A3BD);
  static const Color input_bg = Color(0xFFF9F9F9);

  static const Color off_white = Color(0xFFFCFCFC);

  static const Color buttonText = Color(0xFF898989);

  static const Color text = Color(0xFF14142B);

  static const Color offset = Color(0x14323247);

  static const Color green = Color(0xFF2ACB7F);
  static const Color yellow = Color(0xFFFFC83E);
  static const Color blue = Color(0xFF1DCBEF);
  static const Color purple = Color(0xFF40196C);

  // static const MaterialColor primary = Colors.green;

  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFf8f5fd),
      100: Color(0xFFf2eafa),
      200: Color(0xFFd7c1f1),
      300: Color(0xFFbd97e7),
      400: Color(0xFFa26edd),
      500: Color(_primaryValue),
      600: Color(0xFF6e2bba),
      700: Color(0xFF562291),
      800: Color(0xFF3d1868),
      900: Color(0xFF250e3e),
    },
  );
  static const int _primaryValue = 0xFF40196C;
}
