import 'package:flutter/material.dart';

import '../constants/constants.dart';

const _themeSystem = 0;
const _themeLight = 1;
const _themeDark = 2;

const _themeDefault = _themeSystem;

const _mapType2Int = {
  ThemeMode.system: _themeSystem,
  ThemeMode.light: _themeLight,
  ThemeMode.dark: _themeDark,
};

const _mapInt2Type = {
  _themeSystem: ThemeMode.system,
  _themeLight: ThemeMode.light,
  _themeDark: ThemeMode.dark,
};

extension ThemeModeExtension on ThemeMode {
  int get integer => _mapType2Int[this] ?? _themeDefault;
}

extension ThemeModeIntExtension on int {
  ThemeMode get themeMode => _mapInt2Type[this] ?? defaultThemeMode;
}
