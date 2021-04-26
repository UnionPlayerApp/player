import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/blocs/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:union_player_app/ui/app_screen.dart';
import 'package:union_player_app/ui/pages/screen_main/main_bloc.dart';
import 'package:union_player_app/utils/AppLogger.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();

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
      final _logger = get<AppLogger>();
      _logger.e("Audio stream load error", error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationBloc = get<BottomNavigationBloc>();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Union Radio Player',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: BlocProvider(
          create: (context) => bottomNavigationBloc,
          child: get<AppScreen>(),
        )
    );
  }
}
