import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_app/app_page.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';
import 'package:union_player_app/utils/widgets/info_page.dart';
import 'package:union_player_app/utils/localizations/app_localizations_delegate.dart';
import 'package:union_player_app/utils/widgets/loading_page.dart';

class InitPage extends StatefulWidget {
  InitPage({Key? key}) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  late AppLogger _logger;
  late AudioPlayer _player;
  late SystemData _systemData;

  @override
  void initState() {
    super.initState();

    _logger = get<AppLogger>();
    _player = get<AudioPlayer>();
    _systemData = get<SystemData>();
  }

  Future _initSystemData() async {
    try {
      await Firebase.initializeApp();
    } catch (error) {
      throw Exception("Firebase initialize error: $error");
    }

    late CollectionReference collection;

    try {
      collection = FirebaseFirestore.instance.collection('system_data');
    } catch (error) {
      throw Exception("System data read error: $error");
    }

    try {
      DocumentSnapshot doc = await collection.doc("email_data").get();
      _systemData.setEmailData(doc);
    } catch (error) {
      throw Exception("Email data read error: $error");
    }

    try {
      DocumentSnapshot doc = await collection.doc("xml_data").get();
      _systemData.setXmlData(doc);
    } catch (error) {
      throw Exception("XML data read error: $error");
    }

    try {
      DocumentSnapshot doc = await collection.doc("about_data").get();
      _systemData.setAboutData(doc);
    } catch (error) {
      throw Exception("About data read error: $error");
    }

    try {
      DocumentSnapshot doc = await collection.doc("stream_data").get();
      _systemData.setStreamData(doc);
    } catch (error) {
      throw Exception("Stream data read error: $error");
    }
  }

  Future _initPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    _logger.logDebug(_systemData.streamData.streamMedium);

    final _source =
        AudioSource.uri(Uri.parse(_systemData.streamData.streamMedium));
    try {
      await _player.setAudioSource(_source);
    } catch (error) {
      _logger.logError("Audio stream load error", error);
    }
  }

  Future _initApp() async => Future.wait([_initSystemData()])
      .then((v) {
        _logger.logDebug("init System data success");
        _initPlayer()
            .then((value) => _logger.logDebug("init Player success"))
            .catchError((e) => _handleInitError("init Player error", e));
      })
      .catchError((e) => _handleInitError("init Player error", e));

  FutureOr<Null> _handleInitError(String msg, dynamic error) {
    _logger.logError(msg, error);
    // throw Exception("App initialisation error");
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
    _logger.close();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _initApp(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          late Widget homePage;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              homePage = getWithParam<InfoPage, List<String>>([
                "Ошибка запуска приложения",
                "К сожалению, сейчас нет возможности запустить приложение.",
                "Специалисты уже работают над устранением проблемы.",
                "Попробуйте запустить приложение позже.",
                "Приносим извинения за предоставленные неудобства!"
              ]);
            } else {
              homePage = BlocProvider(
                  create: (context) => get<AppBloc>(), child: get<AppPage>());
            }
          } else {
            homePage = getWithParam<LoadingPage, String>("App initializing...");
          }
          return _createAppPage(homePage);
        },
      );

  Widget _createAppPage(Widget homePage) {
    return ScreenUtilInit(
        designSize: Size(prototypeDeviceWidth, prototypeDeviceHeight),
        builder: () => MaterialApp(
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
              localeResolutionCallback:
                  (Locale? locale, Iterable<Locale> supportedLocales) {
                for (Locale supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode ||
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              title: 'Union Radio Player',
              // theme: ThemeData(primarySwatch: Colors.blueGrey),
              theme: buildUnionRadioTheme(),
              home: AudioServiceWidget(child: homePage),
            ));
  }
}
