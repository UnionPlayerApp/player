import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/constants/constants.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AudioPlayer _player;
  final AppLogger _logger;

  AppBloc(this._player, this._logger) : super(AppState(0, false)) {
    Timer.periodic(Duration(seconds: PLAYER_BUFFER_CHECK_DURATION),
        (Timer t) => _checkForBufferLoading());

    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      _logger.logError("Audio player playback error", e);
      _waitForConnection();
    });
  }

  int _idChannel = 1;
  int _lastPositionChecked = 0;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppNavPressedEvent) {
      yield AppState(event.navIndex, state.isPlaying);
    }
    if (event is AppFabPressedEvent) {
      state.isPlaying ? _player.play() : _player.pause();
      yield AppState(state.navIndex, !state.isPlaying);
    }
  }

  Future<void> _checkForBufferLoading() async {
    if (!await internetConnectionCheck() ||
        !_player.playing ||
        _player.position.inSeconds - _lastPositionChecked < PLAYER_BUFFER_UNCHECKABLE_DURATION) {
      return;
    }
    final _bufferCapacity =
        _player.bufferedPosition.inSeconds - _player.position.inSeconds;

    if (_bufferCapacity > PLAYER_BUFFER_HIGH_CAPACITY) {
      switch (_idChannel) {
        case 0:
          _switchStream(STREAM_MED_URL,1);
          break;
        case 1:
          _switchStream(STREAM_HIGH_URL,2);
          break;
      }
      _lastPositionChecked = _player.position.inSeconds;
      return;
    }

    if (_bufferCapacity < PLAYER_BUFFER_LOW_CAPACITY) {
      switch (_idChannel) {
        case 2:
          _switchStream(STREAM_MED_URL,1);
          break;
        case 1:
          _switchStream(STREAM_LOW_URL,0);
          break;
      }
      _lastPositionChecked = _player.position.inSeconds;
    }
  }

  _switchStream(String newStreamUrl, int newStreamId) {
    _idChannel = newStreamId;
    _waitForConnection();
  }

  Future<void> _waitForConnection() async {
    while (await internetConnectionCheck() == false) {
      Future.delayed(Duration(seconds: INTERNET_CONNECTION_CHECK_DURATION));
      _logger.logError("No internet connection", null);
    }
    try {
      switch(_idChannel){
        case 0:
          final _newSource = AudioSource.uri(Uri.parse(STREAM_LOW_URL));
          await _player.setAudioSource(_newSource);
          break;
        case 1:
          final _newSource = AudioSource.uri(Uri.parse(STREAM_MED_URL));
          await _player.setAudioSource(_newSource);
          break;
        case 2:
          final _newSource = AudioSource.uri(Uri.parse(STREAM_HIGH_URL));
          await _player.setAudioSource(_newSource);
          break;
      }
    } catch (error) {
      _logger.logError("Player set audio source error", error);
    }
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
}
