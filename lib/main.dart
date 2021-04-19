import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/app/app_widget.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/di/app_module.dart';
import 'package:koin/koin.dart';

import 'app/app_bloc.dart';

void main() {
  startKoin((app) {
    app.module(appModule);
  });

  // runApp(MyApp());

  // runApp(BlocProvider(
  //   create: (context) => AppBloc(),
  //   child: AppWidget(),
  // ));
}

class App extends StatefulWidget {
  App(Key key) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with ScopeStateMixin {
  late Logger _logger;
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _logger = get();
    _player = get();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final _source = AudioSource.uri(Uri.parse(STREAM_URL));
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    try {
      await _player.setAudioSource(_source);
    } catch (e) {
      _logger.log(Level.error, "Player init error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Union Radio Player',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: BlocProvider(
          create: (context) => MainBloc(),
          child: MainPage(title: 'Union Player Home Page')),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Union Radio Player',
//       theme: ThemeData(
//         primarySwatch: Colors.blueGrey,
//       ),
//       home: BlocProvider(
//           create: (context) => MainBloc(),
//           child: MainPage(title: 'Union Player Home Page')
//       ),
//     );
//   }
// }
