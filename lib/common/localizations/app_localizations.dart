import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:union_player_app/common/core/typedefs.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations);

  JsonMapString? _localizedStrings;

  Future<bool> load() => rootBundle.loadString('assets/localizations/${locale.languageCode}.json').then((jsonString) {
        try {
          final jsonMap = json.decode(jsonString) as JsonMap;
          _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
          debugPrint("localizations load success");
          return true;
        } catch (error) {
          debugPrint("localizations load error: $error");
          _localizedStrings = null;
          return false;
        }
      }).onError((error, _) {
        debugPrint("localizations load error: $error");
        return false;
      });

  String translate(String key) =>
      _localizedStrings != null ? _localizedStrings![key] ?? "NOT FOUND" : "localizations don't load";
}
