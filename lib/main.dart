import 'package:flutter/material.dart';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

const LOG_TAG = "UPA -> ";
const STREAM_URL = "http://78.155.222.238:8010/souz_radio";

late AudioPlayer _player = AudioPlayer();
late Logger logger = Logger();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Union Radio Player',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MainPage(title: 'Union Player Home Page'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _source = AudioSource.uri(Uri.parse(STREAM_URL));

  String _stateString01 = "Play / Pause";
  String _stateString02 = "Loading / Buffering / Completed / Ready ";

  void _playerStartStop() {
    if (_player.processingState == ProcessingState.ready) {
      if (_player.playing) {
        _player.pause();
      } else {
        _player.play();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      showError("A stream error occurred", e);
    });
    try {
      await _player.setAudioSource(_source);
    } catch (e) {
      showError("Stream load error happens", e);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  AppBar createAppBar() => AppBar(
        title: Text(widget.title),
      );

  Text createStateRow1() {
    return Text(
      _stateString01,
      style: Theme.of(context).textTheme.bodyText2,
    );
  }

  Text createStateRow2() => Text(
        _stateString02,
        style: Theme.of(context).textTheme.bodyText2,
      );

  FloatingActionButton createFAB() => FloatingActionButton(
        onPressed: _playerStartStop,
        tooltip: 'Increment',
        child: Icon(Icons.play_arrow_rounded),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[createStateRow1(), createStateRow2()],
          ),
        ),
        floatingActionButton:
            createFAB() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  void showError(String msg, Object error) {
    logger.d("$LOG_TAG $msg: $error");
  }
}
