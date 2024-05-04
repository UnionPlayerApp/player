import 'package:flutter/material.dart';
import 'package:union_player_app/common/ui/app_colors.dart';

import 'text_styles.dart';

// *** light themes ***

ThemeData appThemeLight() {
  final base = ThemeData.light(useMaterial3: false);
  return base.copyWith(
    // colors section
    dividerColor: AppColors.platinum,
    scaffoldBackgroundColor: AppColors.white,
    // themes section
    appBarTheme: _appBarTheme(base.appBarTheme),
    bottomNavigationBarTheme: _appBottomNavigationBarTheme(base.bottomNavigationBarTheme),
    iconTheme: _appIconTheme(base.iconTheme),
    progressIndicatorTheme: _appProgressIndicatorTheme(base.progressIndicatorTheme),
    radioTheme: _appRadioTheme(base.radioTheme),
    snackBarTheme: _appSnackBarTheme(base.snackBarTheme),
    textTheme: _appTextTheme(base.textTheme),
  );
}

IconThemeData _appIconTheme(IconThemeData base) => base.copyWith(
      color: AppColors.white,
    );

SnackBarThemeData _appSnackBarTheme(SnackBarThemeData base) => base.copyWith(
      backgroundColor: AppColors.blueGreen,
    );

ProgressIndicatorThemeData _appProgressIndicatorTheme(ProgressIndicatorThemeData base) => base.copyWith(
      color: AppColors.blueGreen,
      linearTrackColor: AppColors.gray,
    );

RadioThemeData _appRadioTheme(RadioThemeData base) => base.copyWith(
      fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.celadonBlue;
        } else {
          return AppColors.blackOlive;
        }
      }),
    );

BottomNavigationBarThemeData _appBottomNavigationBarTheme(BottomNavigationBarThemeData base) => base.copyWith(
      selectedItemColor: AppColors.celadonBlue,
      unselectedItemColor: AppColors.blackOlive,
    );

TextTheme _appTextTheme(TextTheme base) => base.copyWith(
      bodySmall: TextStyles.regular16BlackOlive,
      labelSmall: TextStyles.regular16White,
      labelMedium: TextStyles.regular22White,
      titleSmall: TextStyles.bold16BlackOlive,
      titleMedium: TextStyles.bold20BlackOlive,
    );

AppBarTheme _appBarTheme(AppBarTheme base) => base.copyWith(
      backgroundColor: AppColors.white,
      elevation: 0.0,
      titleSpacing: 0.0,
      titleTextStyle: TextStyles.bold20BlackOlive,
    );

// *** dark themes ***

ThemeData appThemeDark() {
  final base = appThemeLight();
  return base.copyWith(
    brightness: Brightness.dark,
    // color section
    dialogBackgroundColor: AppColors.jungleGreen,
    dividerColor: AppColors.blackOlive,
    scaffoldBackgroundColor: AppColors.jungleGreen,
    // themes section
    appBarTheme: _appBarThemeDark(base.appBarTheme),
    bottomAppBarTheme: _appBottomAppBarThemeDark(base.bottomAppBarTheme),
    bottomNavigationBarTheme: _appBottomNavigationBarThemeDark(base.bottomNavigationBarTheme),
    iconTheme: _appIconThemeDark(base.iconTheme),
    progressIndicatorTheme: _appProgressIndicatorThemeDark(base.progressIndicatorTheme),
    textTheme: _appTextThemeDark(base.textTheme),
  );
}

IconThemeData _appIconThemeDark(IconThemeData base) => base.copyWith(
      color: AppColors.cultured,
    );

AppBarTheme _appBarThemeDark(AppBarTheme base) => base.copyWith(
      backgroundColor: AppColors.jungleGreen,
      titleTextStyle: base.titleTextStyle!.copyWith(color: AppColors.cultured),
    );

BottomAppBarTheme _appBottomAppBarThemeDark(BottomAppBarTheme base) => base.copyWith(
      color: AppColors.jungleGreen,
    );

BottomNavigationBarThemeData _appBottomNavigationBarThemeDark(BottomNavigationBarThemeData base) => base.copyWith(
      selectedItemColor: AppColors.blueGreen,
      unselectedItemColor: AppColors.auroMetalSaurus,
    );

ProgressIndicatorThemeData _appProgressIndicatorThemeDark(ProgressIndicatorThemeData base) => base.copyWith(
      linearTrackColor: AppColors.cultured,
    );

TextTheme _appTextThemeDark(TextTheme base) => base.copyWith(
      bodySmall: base.bodySmall!.copyWith(color: AppColors.cultured),
      labelSmall: base.labelSmall!.copyWith(color: AppColors.cultured),
      labelMedium: base.labelMedium!.copyWith(color: AppColors.cultured),
      titleSmall: base.titleSmall!.copyWith(color: AppColors.cultured),
      titleMedium: base.titleMedium!.copyWith(color: AppColors.cultured),
    );
