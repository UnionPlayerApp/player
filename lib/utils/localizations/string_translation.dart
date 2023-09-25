import 'package:flutter/cupertino.dart';

import '../enums/string_keys.dart';
import 'app_localizations.dart';

String translate(StringKeys key, BuildContext context) {
  String stringKey =
      key.toString().substring(11, key.toString().length); // Здесь 11 - это кол-во символов в "StringKeys."
  String? translatedString = AppLocalizations.of(context)?.translate(stringKey);
  return translatedString ?? "NOT FOUND";
}
