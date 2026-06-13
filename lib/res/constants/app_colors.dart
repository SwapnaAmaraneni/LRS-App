import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF184751);
  static const Color appBarColor = Color(0xff184941);
  static const primaryColorDark = Color(0xFF10404b);
  static const themeColor = Color(0xFF218f60);
  static const primaryColorLight = Color(0xFF5472D3);
  static const accentColor = Color(0xFF00B0FF);
  static const dividerColor = Color(0xFFBDBDBD);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const grey = Colors.grey;
  static const transparent = Color(0x00000000);
  static const fontBg = Color(0xffffcc00);
  static const red = Color.fromARGB(255, 250, 4, 4);
  static const warningColor = Color(0xffffcc80);
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF0D47A1,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF42A5F7),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
  static SweepGradient gradient = const SweepGradient(
    colors: [
      Color(0xff0f274c),
      AppColors.themeColor,
      Color(0xff0f274c),
      Color(0xFF15334f),
      AppColors.themeColor,
      Color(0xFF224750),
      AppColors.primaryColorDark,
      Color(0xff21484f),
      AppColors.themeColor,
    ],
  );
  static SweepGradient uploadDocGradient = const SweepGradient(
    colors: [Colors.black, Colors.grey],
  );
  static const appNameFontColor = Color(0xffffd17b);
  //write your color here or pick it from the flutter colors
}
