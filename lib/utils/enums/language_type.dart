import 'dart:ui';

import 'package:get/get.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/enums/string_keys.dart';

enum LanguageType {
  system,
  ru,
  by,
  us,
}

const _languageSystem = 0;
const _languageRU = 1;
const _languageBY = 2;
const _languageUS = 3;

const _languageDefault = _languageSystem;
const _languageDefaultLabelKey = StringKeys.settingsLangSystem;

const _mapType2Int = {
  LanguageType.system: _languageSystem,
  LanguageType.ru: _languageRU,
  LanguageType.by: _languageBY,
  LanguageType.us: _languageUS,
};

const _mapType2StringKeys = {
  LanguageType.system: StringKeys.settingsLangSystem,
  LanguageType.ru: StringKeys.settingsLangRU,
  LanguageType.by: StringKeys.settingsLangBY,
  LanguageType.us: StringKeys.settingsLangUS,
};

const _mapInt2Type = {
  _languageSystem: LanguageType.system,
  _languageRU: LanguageType.ru,
  _languageBY: LanguageType.by,
  _languageUS: LanguageType.us,
};

extension LanguageTypeExtension on LanguageType {
  int get integer => _mapType2Int[this] ?? _languageDefault;

  StringKeys get labelKey => _mapType2StringKeys[this] ?? _languageDefaultLabelKey;

  Locale get locale {
    switch (this) {
      case LanguageType.ru:
        return localeRU;
      case LanguageType.by:
        return localeBY;
      case LanguageType.us:
        return localeUS;
      case LanguageType.system:
        return Get.deviceLocale ?? localeUS;
    }
  }

  bool get isSystem => this == LanguageType.system;
}

extension LanguageIntExtension on int {
  LanguageType get languageType => _mapInt2Type[this] ?? defaultLanguageType;
}
