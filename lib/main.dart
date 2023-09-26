import 'dart:async';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:union_player_app/di/di.dart';
import 'package:union_player_app/screen_init/init_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/enums/string_keys.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';

import 'utils/debug/app_bloc_observer.dart';
import 'utils/localizations/app_localizations_delegate.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await _initLocator();

      final packageInfo = await PackageInfo.fromPlatform();

      if (kDebugMode) {
        Bloc.observer = AppBlocObserver();
      }

      runApp(_app(packageInfo: packageInfo));
    },
    (error, stack) => kReleaseMode
        ? FirebaseCrashlytics.instance.recordError(error, stack)
        : log("Flutter error", error: error, stackTrace: stack, name: logName),
  );
}

Future<void> _initLocator() async {
  BindingModule.providesTools();
  BindingModule.providesBlocs();
  BindingModule.providesPages();
  return GetIt.I.allReady().then((_) => BindingModule.initAsyncSingletons());
}

Widget _app({required PackageInfo packageInfo}) {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent, // status bar is used for CustomAppBar
    statusBarBrightness: Brightness.light, // for iOS => icons are dark
    statusBarIconBrightness: Brightness.dark, // for Android => icons are dark
  ));
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
    home: InitPage(packageInfo: packageInfo),
  );
}
