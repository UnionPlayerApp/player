import 'package:audio_session/audio_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/app/app_screen.dart';
import 'package:union_player_app/navigation/bottom_navigation_bloc.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/info_page.dart';
import 'package:union_player_app/utils/loading_page.dart';

class AppPage extends StatefulWidget {
  AppPage({Key? key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  late AppLogger _logger;
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();

    _logger = get<AppLogger>();
    _player = get<AudioPlayer>();
  }

  Future _initPlayer() async {
    final _source = AudioSource.uri(Uri.parse(STREAM_URL));
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    try {
      await _player.setAudioSource(_source);
    } catch (error) {
      _logger.logError("Audio stream load error", error);
    }
  }

  Future _initApp() async => Future.wait([
        _initPlayer()
            .then((v) => _logger.logDebug("init Player success"))
            .catchError((e) => _handleInitError("init Player error", e)),
        Firebase.initializeApp()
            .then((v) => _logger.logDebug("init Firebase success"))
            .catchError((e) => _handleInitError("init Firebase error", e))
      ]);

  void _handleInitError(String msg, dynamic error) {
    _logger.logError(msg, error);
    throw Exception("App initialisation error");
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
                   create: (context) => get<BottomNavigationBloc>(),
                   child: get<AppScreen>());
              //homePage = get<AppScreen>();
            }
          } else {
            homePage = getWithParam<LoadingPage, String>("App initializing...");
          }
          return _createAppPage(homePage);
        },
      );

  Widget _createAppPage(Widget homePage) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Union Radio Player',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: homePage,
      );
}
