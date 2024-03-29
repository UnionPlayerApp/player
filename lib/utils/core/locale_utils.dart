import 'dart:io';
import 'dart:ui';

import '../constants/constants.dart';

Locale getLocaleById(int id) {
  switch (id) {
    case langRU:
      return localeRU;
    case langBY:
      return localeBY;
    case langUS:
      return localeUS;
    default:
      return _systemLocale();
  }
}

Locale _systemLocale() {
  final localeCodes = Platform.localeName.split("_");
  final languageCode = localeCodes[0];
  final countryCode = localeCodes.length > 1 ? localeCodes[1] : null;
  return Locale(languageCode, countryCode);
}
