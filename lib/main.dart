import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:koin/koin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:union_player_app/di/di.dart';
import 'package:union_player_app/screen_init/init_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

import 'utils/localizations/app_localizations_delegate.dart';
import 'utils/ui/app_theme.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    _initLocator();

    final packageInfo = await PackageInfo.fromPlatform();

    runApp(_app(packageInfo));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

void _initLocator() {
  startKoin((app) {
    const level = kDebugMode ? Level.debug : Level.none;
    app.printLogger(level: level);
    app.module(appModule);
  });
}

Widget _app(PackageInfo packageInfo) {
  return GetMaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      AppLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: supportedLocales,
    localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale?.languageCode ||
            supportedLocale.countryCode == locale?.countryCode) {
          return supportedLocale;
        }
      }
      return supportedLocales.first;
    },
    onGenerateTitle: (context) => translate(StringKeys.app_title, context),
    theme: createAppTheme(),
    home: InitPage(packageInfo: packageInfo),
  );
}