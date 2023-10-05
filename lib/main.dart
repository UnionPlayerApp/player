import 'dart:async';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:union_player_app/common/constants/constants.dart';
import 'package:union_player_app/common/dimensions/dimensions.dart';
import 'package:union_player_app/common/enums/string_keys.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';
import 'package:union_player_app/common/ui/app_theme.dart';
import 'package:union_player_app/di/di.dart';

import 'common/debug/app_bloc_observer.dart';
import 'common/localizations/app_localizations_delegate.dart';
import 'common/routes.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await _initLocator();

      final packageInfo = GetIt.I.get<PackageInfo>();

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
  final routes = GetIt.I.get<Routes>();
  return ScreenUtilInit(
    designSize: const Size(prototypeDeviceWidth, prototypeDeviceHeight),
    builder: (context, child) => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        try {
          return supportedLocales.firstWhere((supportedLocale) =>
              supportedLocale.languageCode == locale?.languageCode ||
              supportedLocale.countryCode == locale?.countryCode);
        } catch (_) {
          return defaultLocale;
        }
      },
      onGenerateTitle: (context) => translate(StringKeys.appTitle, context),
      theme: appThemeLight(),
      darkTheme: appThemeDark(),
      home: child,
      routes: routes.getRoutes(),
    ),
    child: routes.initialPage(packageInfo: packageInfo),
  );
}
