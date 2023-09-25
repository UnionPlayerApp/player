import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:union_player_app/di/di.dart';
import 'package:union_player_app/providers/shared_preferences_manager.dart';
import 'package:union_player_app/screen_init/init_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/enums/string_keys.dart';
import 'package:union_player_app/utils/core/shared_preferences.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';

import 'utils/debug/app_bloc_observer.dart';
import 'utils/localizations/app_localizations_delegate.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    _initLocator();

    final packageInfo = await PackageInfo.fromPlatform();
    final themeMode = GetIt.I.get<SPManager>().readThemeMode();

    if (kDebugMode) {
      Bloc.observer = AppBlocObserver();
    }

    runApp(_app(packageInfo, themeMode));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

void _initLocator() {
  BindingModule.providesTools();
  BindingModule.providesBlocs();
  BindingModule.providesPages();
}

Widget _app(PackageInfo packageInfo, ThemeMode themeMode) {
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
    onGenerateTitle: (context) => translate(StringKeys.appTitle, context),
    theme: appThemeLight(),
    darkTheme: appThemeDark(),
    themeMode: themeMode,
    home: InitPage(packageInfo: packageInfo),
  );
}
