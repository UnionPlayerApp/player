import 'package:audio_session/audio_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/loading_page.dart';
import 'package:union_player_app/utils/info_page.dart';

class AppPage extends StatefulWidget {
  AppPage({Key? key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  late AppLogger _logger;
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();

    _logger = get<AppLogger>();
    _player = get<AudioPlayer>();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final _source = AudioSource.uri(Uri.parse(STREAM_URL));
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    try {
      await _player.setAudioSource(_source);
    } catch (error) {
      _logger.e("Audio stream load error", error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  // @override
  // Widget build(BuildContext context) => FutureBuilder(
  //       future: _initialization,
  //       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //         if (snapshot.hasError) {
  //           _logger.logDebug("App initialization error: ${snapshot.error}");
  //           return createAppPage(getWithParam<InfoPage, String>(snapshot.error.toString()));
  //         }
  //
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           return createAppPage(get<MainPage>());
  //         }
  //
  //         return createAppPage(get<LoadingPage>());
  //       },
  //     );

  @override
  Widget build(BuildContext context) {
    final strings = ["Заголовок ошибки", "Текст ошибки", "Еще один текст ошибки", "И еще один текст ошибки"];
    final title = "Инициализация приложения";
    return createAppPage(getWithParam<LoadingPage, String>(title));
  }

  Widget createAppPage(Widget homePage) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Union Radio Player',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: homePage,
      );
}
