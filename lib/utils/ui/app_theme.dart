import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:union_player_app/utils/core/extensions.dart';

import '../constants/constants.dart';

ThemeData appThemeLight() {
  final baseThemeData = ThemeData.light();
  return baseThemeData.copyWith(
    appBarTheme: _appBarTheme(baseThemeData.appBarTheme),
    bannerTheme: _appBannerTheme(baseThemeData.bannerTheme),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: secondaryColor,
      colorScheme: _appColorScheme.copyWith(secondary: secondaryColor),
      textTheme: ButtonTextTheme.normal,
    ),
    cardColor: surfaceColor,
    colorScheme: _appColorScheme.copyWith(secondary: secondaryColor),
    primaryColor: primaryColor,
    primaryColorDark: primaryDarkColor,
    primaryColorLight: primaryLightColor,
    scaffoldBackgroundColor: scaffoldBackgroundColorLight,
    textTheme: _appTextTheme(baseThemeData.textTheme),
  );
}

ThemeData appThemeDark() => ThemeData.dark().copyWith(
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
      colorScheme: _appColorSchemeDark,
      scaffoldBackgroundColor: scaffoldBackgroundColorDark,
    );

TextTheme _appTextTheme(TextTheme base) {
  return base.apply(
    fontFamily: 'Rubik',
  );
}

MaterialBannerThemeData _appBannerTheme(MaterialBannerThemeData base) {
  return base.copyWith(
    backgroundColor: primaryLightColor,
    contentTextStyle: const TextStyle(color: colorOnSecondaryWithAlfa),
  );
}

AppBarTheme _appBarTheme(AppBarTheme base) {
  return base.copyWith(centerTitle: true);
}

const _appColorScheme = ColorScheme(
  primary: primaryColor,
  secondary: secondaryColor,
  surface: surfaceColor,
  background: scaffoldBackgroundColorLight,
  error: errorColor,
  onPrimary: scaffoldBackgroundColorLight,
  onSecondary: scaffoldBackgroundColorLight,
  onSurface: secondaryDarkColor,
  onBackground: colorOnBackgroundLight,
  onError: colorOnPrimary,
  brightness: Brightness.light,
);

final _appColorSchemeDark = _appColorScheme.copyWith(onBackground: colorOnBackgroundDark);

const primaryColor = Color(0xFF003e8d);
const primaryDarkColor = Color(0xFF00195f);
const primaryLightColor = Color(0xFF4b68be);

const secondaryColor = Color(0xFFe8000a);
const secondaryDarkColor = Color(0xFFad0000);
const secondaryLightColor = Color(0xFFff5539);

const errorColor = Color(0xFFC5032B);

const colorOnPrimary = Colors.white;
const colorOnSecondary = Colors.white;
const colorOnBackgroundLight = Colors.black;
const colorOnBackgroundDark = Colors.grey;
const colorOnSecondaryWithAlfa = Color(0xCEFFFFFF);

const scaffoldBackgroundColorLight = Color(0xFFF1F1F1);
const scaffoldBackgroundColorDark = Color(0xff616161);

const surfaceColor = Colors.white;

const defaultLetterSpacing = 0.03;

void setThemeById(int themeId) {
  setIcAudioQuality(themeId);
  Get.changeThemeMode(themeId.toThemeMode);
}

const redCarminePink = Color(0xFFEA4C46);
const redBegonia = Color(0xFFF07470);
const yellowBanana = Color(0xFFFFDD3C);
const yellowCorn = Color(0xFFFFEA61);
const greenApple = Color(0xFF57C84D);
const greenPastel = Color(0xFF83D475);

const redColors = [redCarminePink, redBegonia];
const yellowColors = [yellowBanana, yellowCorn];
const greenColors = [greenApple, greenPastel];