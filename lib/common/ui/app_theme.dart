import 'package:flutter/material.dart';
import 'package:union_player_app/common/ui/app_colors.dart';

import 'text_styles.dart';

ThemeData appThemeLight() {
  final base = ThemeData.light();
  return base.copyWith(
    // colors section
    dividerColor: AppColors.platinum,
    scaffoldBackgroundColor: AppColors.white,
    // themes section
    appBarTheme: _appBarTheme(base.appBarTheme),
    bottomNavigationBarTheme: _appBottomNavigationBarTheme(base.bottomNavigationBarTheme),
    radioTheme: _appRadioTheme(base.radioTheme),
    textTheme: _appTextTheme(base.textTheme),
  );
}

RadioThemeData _appRadioTheme(RadioThemeData base) {
  return base.copyWith(
    fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.lapisLazuli;
      } else {
        return AppColors.blackOlive;
      }
    }),
  );
}

BottomNavigationBarThemeData _appBottomNavigationBarTheme(BottomNavigationBarThemeData base) {
  return base.copyWith(
    selectedItemColor: AppColors.celadonBlue,
    unselectedItemColor: AppColors.blackOlive,
  );
}

TextTheme _appTextTheme(TextTheme base) {
  return base.copyWith(
    bodySmall: TextStyles.regular16BlackOlive,
    labelSmall: TextStyles.regular16White,
    labelMedium: TextStyles.regular22White,
    titleSmall: TextStyles.bold16BlackOlive,
    titleMedium: TextStyles.bold20BlackOlive,
  );
}

AppBarTheme _appBarTheme(AppBarTheme base) {
  return base.copyWith(
    centerTitle: true,
    backgroundColor: AppColors.white,
    elevation: 0.0,
  );
}

ThemeData appThemeDark() => appThemeLight().copyWith();
