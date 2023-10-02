import 'package:flutter/material.dart';
import 'package:union_player_app/common/ui/app_colors.dart';

import 'text_styles.dart';

// *** light themes ***

ThemeData appThemeLight() {
  final base = ThemeData.light();
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
          return AppColors.lapisLazuli;
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
      centerTitle: true,
      backgroundColor: AppColors.white,
      elevation: 0.0,
    );

// *** dark themes ***

ThemeData appThemeDark() {
  final base = appThemeLight();
  return base.copyWith(
    dialogBackgroundColor: AppColors.gray,
    scaffoldBackgroundColor: AppColors.gray,
    // themes section
    appBarTheme: _appBarThemeDark(base.appBarTheme),
    bottomAppBarTheme: _appBottomAppBarThemeDark(base.bottomAppBarTheme),
    bottomNavigationBarTheme: _appBottomNavigationBarThemeDark(base.bottomNavigationBarTheme),
    progressIndicatorTheme: _appProgressIndicatorThemeDark(base.progressIndicatorTheme),
  );
}

AppBarTheme _appBarThemeDark(AppBarTheme base) => base.copyWith(
      backgroundColor: AppColors.gray,
    );

BottomAppBarTheme _appBottomAppBarThemeDark(BottomAppBarTheme base) => base.copyWith(
      color: AppColors.gray,
    );

BottomNavigationBarThemeData _appBottomNavigationBarThemeDark(BottomNavigationBarThemeData base) => base.copyWith(
      selectedItemColor: AppColors.celadonBlue,
      unselectedItemColor: AppColors.blackOlive,
    );

ProgressIndicatorThemeData _appProgressIndicatorThemeDark(ProgressIndicatorThemeData base) => base.copyWith(
      linearTrackColor: AppColors.blackOlive.withOpacity(0.8),
    );