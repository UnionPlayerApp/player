import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:koin/koin.dart';
import 'package:union_player_app/di/di.dart';
import 'package:union_player_app/screen_init/init_page.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

import 'screen_init/init_page.dart';
import 'utils/localizations/app_localizations_delegate.dart';
import 'utils/ui/app_theme.dart';

void main() {
  startKoin((app) {
    app.printLogger(level: Level.debug);
    app.module(appModule);
  });

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
      const AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en', 'US'),
      const Locale('ru', 'RU'),
      const Locale('be', 'BY'),
    ],
    localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale?.languageCode ||
            supportedLocale.countryCode == locale?.countryCode) {
          return supportedLocale;
        }
      }
      return supportedLocales.first;
    },
    onGenerateTitle: (context) => translate(StringKeys.app_title, context),
    theme: createAppTheme(),
    home: InitPage(),
  ));
}
