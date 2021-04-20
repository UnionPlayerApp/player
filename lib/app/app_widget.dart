import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/di/app_module.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();

    startKoin((app) {
      app.printLogger(level: Level.debug);
      app.module(appModule);
    });

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
      final logger = get<Logger>();
      logger.error("Audio stream load error: $error");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = get<MainBloc>();
    final mainPage = get<MainPage>();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Union Radio Player',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: BlocProvider(
          create: (context) => mainBloc,
          child: mainPage,
        )
    );
  }
}
