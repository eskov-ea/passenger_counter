import 'dart:ui';
import 'package:flutter/material.dart';


abstract class LightColors {

}

abstract class DarkColors {
  static const backgroundMain1 = Color(0xFF0E51A7);
  static const backgroundMain2 = Color(0xFF274D7E);
  static const backgroundMain3 = Color(0xFF05326D);
  static const backgroundMain4 = Color(0xFF4282D3);
  static const backgroundMain5 = Color(0xFF6997D3);

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
  static const textInfo1 = Color(0xFFA66600);
  static const textInfo2 = Color(0xFFBF8830);
}


/// Reference to the application theme.
abstract class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  /// Light theme and its settings.
  // static ThemeData light() => ThemeData(
  //   brightness: Brightness.light,
  //   hintColor: accentColor,
  //   visualDensity: visualDensity,
  //   // textTheme:
  //   //     GoogleFonts.mulishTextTheme().apply(bodyColor: AppColors.textDark),
  //   backgroundColor: LightColors.background,
  //   scaffoldBackgroundColor: LightColors.background,
  //   cardColor: LightColors.card,
  //   primaryTextTheme: const TextTheme(
  //     headline6: TextStyle(color: AppColors.textDark),
  //   ),
  //   iconTheme: const IconThemeData(color: AppColors.iconDark),
  // );

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
      titleSmall: TextStyle(color: DarkColors.textSecondary),
    ),
    iconTheme: const IconThemeData(color: DarkColors.textSecondary)
  );
}