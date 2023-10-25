import 'dart:ui';
import 'package:flutter/material.dart';

final bool isDark = true;

abstract class LightColors {

}

abstract class DarkColors {
  static const backgroundMain1 = Color(0xFF0E51A7);
  static const backgroundMain2 = Color(0xFF274D7E);
  static const backgroundMain3 = Color(0xFF05326D);
  static const backgroundMain4 = Color(0xFF4282D3);
  static const backgroundMain5 = Color(0xFF6997D3);
  static const backgroundNeutral = Color(0xFFECECEC);

  static const secondary1 = Color(0xFF2A17B1);
  static const secondary2 = Color(0xFF392E85);
  static const secondary3 = Color(0xFF150873);
  static const secondary4 = Color(0xFF5D4BD8);
  static const secondary5 = Color(0xFF7D71D8);

  static const accent1 = Color(0xFF00A67C);
  static const accent2 = Color(0xFF1F7C65);
  static const accent3 = Color(0xFF006C51);
  static const accent4 = Color(0xFF35D2AB);
  static const accent5 = Color(0xFF5FD2B5);

  static const textMain = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFD7D7D7);
  static const textFaded = Color(0xFF797979);
  static const textInfo1 = Color(0xFFA66600);
  static const textInfo2 = Color(0xFFBF8830);
}

abstract class AppColors {
  static Color backgroundMain1 = isDark ? DarkColors.backgroundMain1 : Color(0xFF0E51A7);
  static Color backgroundMain2 = isDark ? DarkColors.backgroundMain2 : Color(0xFF274D7E);
  static Color backgroundMain3 = isDark ? DarkColors.backgroundMain3 : Color(0xFF05326D);
  static Color backgroundMain4 = isDark ? DarkColors.backgroundMain4 : Color(0xFF4282D3);
  static Color backgroundMain5 = isDark ? DarkColors.backgroundMain5 : Color(0xFF6997D3);
  static Color backgroundNeutral = isDark ? DarkColors.backgroundNeutral : Color(0xFFECECEC);

  static Color secondary1 = isDark ? DarkColors.secondary1 : Color(0xFF2A17B1);
  static Color secondary2 = isDark ? DarkColors.secondary2 : Color(0xFF392E85);
  static Color secondary3 = isDark ? DarkColors.secondary3 : Color(0xFF150873);
  static Color secondary4 = isDark ? DarkColors.secondary4 : Color(0xFF5D4BD8);
  static Color secondary5 = isDark ? DarkColors.secondary5 : Color(0xFF7D71D8);

  static Color accent1 = isDark ? DarkColors.accent1 : Color(0xFF00A67C);
  static Color accent2 = isDark ? DarkColors.accent2 : Color(0xFF1F7C65);
  static Color accent3 = isDark ? DarkColors.accent3 : Color(0xFF006C51);
  static Color accent4 = isDark ? DarkColors.accent4 : Color(0xFF35D2AB);
  static Color accent5 = isDark ? DarkColors.accent5 : Color(0xFF5FD2B5);

  static Color textMain = isDark ? DarkColors.textMain : Color(0xFFFFFFFF);
  static Color textSecondary = isDark ? DarkColors.textSecondary : Color(0xFFD7D7D7);
  static Color textFaded = isDark ? DarkColors.textFaded : Color(0xFFD7D7D7);
  static Color textInfo1 = isDark ? DarkColors.textInfo1 : Color(0xFFA66600);
  static Color textInfo2 = isDark ? DarkColors.textInfo2 : Color(0xFFBF8830);
}




/// Reference to the application theme.
abstract class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  /// Light theme and its settings.
  static ThemeData light() => ThemeData(
      brightness: Brightness.dark,
      hintColor: DarkColors.textMain,
      visualDensity: visualDensity,
      scaffoldBackgroundColor: DarkColors.backgroundMain1,
      cardColor: DarkColors.backgroundMain4,
      primaryTextTheme: const TextTheme(
        titleLarge: TextStyle(color: DarkColors.textMain),
        titleMedium: TextStyle(color: DarkColors.textMain),
        titleSmall: TextStyle(color: DarkColors.textSecondary),
      ),
      iconTheme: const IconThemeData(color: DarkColors.textSecondary)
  );

  /// Dark theme and its settings.
  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    hintColor: DarkColors.textMain,
    visualDensity: visualDensity,
    scaffoldBackgroundColor: DarkColors.backgroundMain1,
    cardColor: DarkColors.backgroundMain4,
    primaryTextTheme: const TextTheme(
      titleLarge: TextStyle(color: DarkColors.textMain),
      titleMedium: TextStyle(color: DarkColors.textMain),
      titleSmall: TextStyle(color: DarkColors.textMain),
    ),
    iconTheme: const IconThemeData(color: DarkColors.textSecondary)
  );
}