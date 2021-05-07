import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/constants/constants.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AudioPlayer _player;
  final AppLogger _logger;
  final SystemData _systemData;
  late String _currentUrl;

  AppBloc(this._player, this._logger, this._systemData)
      : super(AppState(0, false, ProcessingState.idle)) {
    Timer.periodic(Duration(seconds: PLAYER_BUFFER_CHECK_DURATION),
        (Timer t) => _checkForBufferLoading());

    _player.playbackEventStream.listen((event) {
      // nothing
    }, onError: (Object e, StackTrace stackTrace) {
      _logger.logError("Audio player playback error", e);
      _waitForConnection();
    });

    _player.playerStateStream.listen((playerState) {
      add(AppPlayerStateEvent(
          playerState.playing, playerState.processingState));
    });

    _currentUrl = _systemData.streamData.streamMiddle;
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppFabPressedEvent) {
      _player.playing ? _player.pause() : _player.play();
    }
    if (event is AppNavPressedEvent) {
      yield AppState(event.navIndex, state.playingState, state.processingState);
    }
    if (event is AppPlayerStateEvent) {
      yield AppState(state.navIndex, event.playingState, event.processingState);
    }
  }

  Future<void> _checkForBufferLoading() async {
    if (!await internetConnectionCheck() ||
        !_player.playing ||
        _player.position.inSeconds < PLAYER_BUFFER_UNCHECKABLE_DURATION) {
      return;
    }

    final _bufferCapacity =
        _player.bufferedPosition.inSeconds - _player.position.inSeconds;

    if (_bufferCapacity > PLAYER_BUFFER_HIGH_CAPACITY) {
      if (_currentUrl == _systemData.streamData.streamLow) {
        _switchStream(_systemData.streamData.streamMiddle);
        return;
      }
      if (_currentUrl == _systemData.streamData.streamMiddle) {
        _switchStream(_systemData.streamData.streamHi);
        return;
      }
      return;
    }

    if (_bufferCapacity < PLAYER_BUFFER_LOW_CAPACITY) {
      if (_currentUrl == _systemData.streamData.streamHi) {
        _switchStream(_systemData.streamData.streamMiddle);
        return;
      }
      if (_currentUrl == _systemData.streamData.streamMiddle) {
        _switchStream(_systemData.streamData.streamLow);
        return;
      }
      return;
    }
  }

  _switchStream(String newStreamUrl) {
    _logger.logDebug("switch stream to $newStreamUrl");
    _currentUrl = newStreamUrl;
    _waitForConnection();
  }

  Future<void> _waitForConnection() async {
    while (await internetConnectionCheck() == false) {
      Future.delayed(Duration(seconds: INTERNET_CONNECTION_CHECK_DURATION));
      _logger.logError("No internet connection", null);
    }

    try {
      final _newSource = AudioSource.uri(Uri.parse(_currentUrl));
      await _player.setAudioSource(_newSource);
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
