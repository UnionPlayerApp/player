import 'package:union_player_app/utils/constants/constants.dart';

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

const _mapType2Int = {
  LanguageType.system: _languageSystem,
  LanguageType.ru: _languageRU,
  LanguageType.by: _languageBY,
  LanguageType.us: _languageUS,
};

const _mapInt2Type = {
  _languageSystem: LanguageType.system,
  _languageRU: LanguageType.ru,
  _languageBY: LanguageType.by,
  _languageUS: LanguageType.us,
};

extension LanguageTypeExtension on LanguageType {
  int get integer => _mapType2Int[this] ?? _languageDefault;
}

extension LanguageIntExtension on int {
  LanguageType get languageType => _mapInt2Type[this] ?? defaultLanguageType;
}
