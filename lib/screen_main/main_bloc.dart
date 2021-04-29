import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';
import 'package:union_player_app/utils/app_logger.dart';
const STREAM_LOW_URL = "http://78.155.222.238:8010/souz_radio_64.mp3";
const STREAM_MED_URL = "http://78.155.222.238:8010/souz_radio_128.mp3";
const STREAM_HIGH_URL = "http://78.155.222.238:8010/souz_radio_192.mp3";


class MainBloc extends Bloc<MainEvent, MainState> {
  final AppLogger _logger;
  final AudioPlayer _player;


  String _currentUrl = "http://78.155.222.238:8010/souz_radio_128.mp3";

  MainBloc(this._player, this._logger)
      : super(MainState("Stop", "Initialising")) {
    Timer.periodic(Duration(seconds: 3), (Timer t) => _checkForBufferLoading());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          _waitForConnection();
        });
  }


  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is PlayPauseFabPressed) {
      yield* _mapPlayPauseFabPressedToState();
      return;
    }

    if (event is PlayerStateChangedToBuffering) {
      yield* _mapPlayerStateChangedBufferingToState(event.isPlaying);
      return;
    }
    if (event is PlayerStateChangedToCompleted) {
      yield* _mapPlayerStateChangedCompletedToState(event.isPlaying);
      return;
    }
    if (event is PlayerStateChangedToIdle) {
      yield* _mapPlayerStateChangedIdleToState(event.isPlaying);
      return;
    }
    if (event is PlayerStateChangedToLoading) {
      yield* _mapPlayerStateChangedLoadingToState(event.isPlaying);
      return;
    }
    if (event is PlayerStateChangedToReady) {
      yield* _mapPlayerStateChangedReadyToState(event.isPlaying);
      return;
    }
    _logger.logError(
        "Unknown event may be from user, may be from player",
        ArgumentError("Unknown event may be from user, may be from player")
    );
  }

  Future<void> _checkForBufferLoading() async {
    if (await internetConnectionCheck() && _player.playing && _player.position.inSeconds > 5) {
      if (_player.bufferedPosition.inSeconds - _player.position.inSeconds > 15) {
        switch (_currentUrl) {
          case STREAM_LOW_URL:
            _currentUrl = STREAM_MED_URL;
            _waitForConnection();
            break;
          case STREAM_MED_URL:
            _currentUrl = STREAM_HIGH_URL;
            _waitForConnection();
            break;
        }
      }
      else
      if (_player.bufferedPosition.inSeconds - _player.position.inSeconds < 2) {
        switch (_currentUrl) {
          case STREAM_HIGH_URL:
            _currentUrl = STREAM_MED_URL;
            _waitForConnection();
            break;
          case STREAM_MED_URL:
            _currentUrl = STREAM_LOW_URL;
            _waitForConnection();
            break;
        }
      }
    }
  }

  Future<void> _waitForConnection() async {
    try {
      while (await internetConnectionCheck() == false) {
        Future.delayed(Duration(seconds: 1));
      }

      final _newSource = AudioSource.uri(Uri.parse(_currentUrl));
      await _player.setAudioSource(_newSource);
    } catch (e) {}
  }

  Future<bool> internetConnectionCheck() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return false;
    }
    try {
      final result = await InternetAddress.lookup('google.com');
      return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }


  Stream<MainState> _mapPlayPauseFabPressedToState() async* {
    String stateStr01 = state.stateStr01;

    if (_player.processingState == ProcessingState.ready) {
      stateStr01 = _createStateStr01(!_player.playing);
    }

    yield MainState(stateStr01, state.stateStr02);
  }

  Stream<MainState> _mapPlayerStateChangedBufferingToState(
      bool isPlaying) async* {
    yield MainState(state.stateStr01, "Buffering");
  }

  Stream<MainState> _mapPlayerStateChangedCompletedToState(
      bool isPlaying) async* {
    yield MainState(state.stateStr01, "Completed");
  }

  Stream<MainState> _mapPlayerStateChangedLoadingToState(
      bool isPlaying) async* {
    yield MainState(state.stateStr01, "Loading");
  }

  Stream<MainState> _mapPlayerStateChangedIdleToState(bool isPlaying) async* {
    yield MainState(state.stateStr01, "Idle");
  }

  Stream<MainState> _mapPlayerStateChangedReadyToState(bool isPlaying) async* {
    yield MainState(state.stateStr01, "Ready");
  }

  String _createStateStr01(bool isPlaying) =>
      isPlaying ? "Play" : "Stop";
}
