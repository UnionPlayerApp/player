import 'dart:io';
import 'dart:ui';

import 'package:union_player_app/utils/enums/language_type.dart';

import '../constants/constants.dart';

Locale getLocaleByLanguageType(LanguageType languageType) {
  switch (languageType) {
    case LanguageType.ru:
      return localeRU;
    case LanguageType.by:
      return localeBY;
    case LanguageType.us:
      return localeUS;
    case LanguageType.system:
      return _systemLocale();
  }
}

Locale _systemLocale() {
  final localeCodes = Platform.localeName.split("_");
  final languageCode = localeCodes[0];
  final countryCode = localeCodes.length > 1 ? localeCodes[1] : null;
  return Locale(languageCode, countryCode);
}
