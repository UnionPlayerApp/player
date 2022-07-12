import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/shared_preferences.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AudioHandler _audioHandler;

  late final StreamSubscription _customSubscription;
  late final StreamSubscription _playerSubscription;
  late final StreamSubscription _queueSubscription;

  AppBloc(this._audioHandler, bool isPlaying)
      : super(AppState(0, DEFAULT_IS_PLAYING, DEFAULT_AUDIO_QUALITY_ID, false)) {
    on<AppFabEvent>(_onFab);
    on<AppNavEvent>(_onNav);
    on<AppPlayerEvent>(_onPlayer);
    on<AppScheduleEvent>(_onSchedule);
    on<AppAudioQualitySelectorEvent>(_onAudioQualitySelector);
    on<AppAudioQualityButtonEvent>(_onAudioQualityButton);
    on<AppAudioQualityInitEvent>(_onAudioQualityInit);

    _customSubscription = _audioHandler.customEvent.listen((error) => _onCustomEvent(error));
    _queueSubscription = _audioHandler.queue.listen((queue) => _onQueueEvent(queue));
    _playerSubscription = _audioHandler.playbackState.listen((state) => _onPlaybackEvent(state));

    _readAudioQualityIdFromSharedPreferences();

    if (isPlaying) {
      _audioHandler.play();
    } else {
      _audioHandler.pause();
    }
  }

  FutureOr<void> _onFab(AppFabEvent event, Emitter<AppState> emitter) {
    if (_audioHandler.playbackState.value.playing) {
      _audioHandler.pause();
    } else {
      _audioHandler.play();
    }
  }

  FutureOr<void> _onNav(AppNavEvent event, Emitter<AppState> emitter) {
    final newState = state.copyWith(navIndex: event.navIndex);
    emitter(newState);
  }

  FutureOr<void> _onPlayer(AppPlayerEvent event, Emitter<AppState> emitter) {
    final newState = state.copyWith(playingState: event.playingState);
    emitter(newState);
  }

  FutureOr<void> _onSchedule(AppScheduleEvent event, Emitter<AppState> emitter) {
    late AppState newState;

    if (event.items == null || event.items!.length < 2) {
      newState = state.copyWith(isScheduleLoaded: false);
    } else {
      final presentItem = event.items![0];
      final nextItem = event.items![1];
      newState = state.copyWith(
          isScheduleLoaded: true,
          presentArtist: presentItem.artist ?? "",
          presentTitle: presentItem.title,
          nextArtist: nextItem.artist ?? "",
          nextTitle: nextItem.title);
    }

    emitter(newState);
  }

  FutureOr<void> _onAudioQualitySelector(AppAudioQualitySelectorEvent event, Emitter<AppState> emitter) {
    final newState = state.copyWith(isAudioQualitySelectorOpen: !state.isAudioQualitySelectorOpen);
    emitter(newState);
  }

  FutureOr<void> _onAudioQualityButton(AppAudioQualityButtonEvent event, Emitter<AppState> emitter) {
    _doAudioQualityChanged(event.audioQualityId);
    final newState = state.copyWith(isAudioQualitySelectorOpen: false, audioQualityId: event.audioQualityId);
    emitter(newState);
  }

  FutureOr<void> _onAudioQualityInit(AppAudioQualityInitEvent event, Emitter<AppState> emitter) {
    final newState = state.copyWith(audioQualityId: event.audioQualityId);
    emitter(newState);
  }

  void _onCustomEvent(error) {
    add(AppScheduleEvent(null));
  }

  void _onQueueEvent(List<MediaItem>? queue) {
    if (queue == null) {
      add(AppScheduleEvent(null));
    } else if (queue.isEmpty) {
      add(AppScheduleEvent(null));
    } else {
      add(AppScheduleEvent(queue));
    }
  }

  void _onPlaybackEvent(PlaybackState state) {
    add(AppPlayerEvent(state.playing));
    writeBoolToSharedPreferences(KEY_IS_PLAYING, state.playing);
  }

  @override
  Future<void> close() async {
    _customSubscription.cancel();
    _playerSubscription.cancel();
    _queueSubscription.cancel();
    super.close();
  }

  void _doAudioQualityChanged(int audioQualityId) {
    Map<String, dynamic> params = {
      KEY_AUDIO_QUALITY: audioQualityId,
      KEY_IS_PLAYING: _audioHandler.playbackState.value.playing,
    };
    _audioHandler
        .customAction(ACTION_SET_AUDIO_QUALITY, params)
        .then((value) => writeIntToSharedPreferences(KEY_AUDIO_QUALITY, audioQualityId));
  }

  void _readAudioQualityIdFromSharedPreferences() async {
    readIntFromSharedPreferences(KEY_AUDIO_QUALITY)
        .then((audioQualityId) => _onSharedPreferencesReadSuccess(audioQualityId))
        .catchError((error) => _onSharedPreferencesReadError(error));
  }

  _onSharedPreferencesReadSuccess(int? audioQualityId) {
    add(AppAudioQualityInitEvent(audioQualityId ?? DEFAULT_AUDIO_QUALITY_ID));
  }

  _onSharedPreferencesReadError(error) {
    log("shared preferences read error: $error", name: LOG_TAG);
  }

// Future<void> _checkForBufferLoading() async {
//   if (!await internetConnectionCheck() ||
//       !_player.playing ||
//       _player.position.inSeconds - _lastPositionChecked <
//           PLAYER_BUFFER_UNCHECKABLE_DURATION) {
//     return;
//   }
//   final _bufferCapacity =
//       _player.bufferedPosition.inSeconds - _player.position.inSeconds;
//
//   if (_bufferCapacity > PLAYER_BUFFER_HIGH_CAPACITY) {
//     switch (_currentStreamId) {
//       case ID_STREAM_LOW:
//         _switchStream(ID_STREAM_MEDIUM);
//         break;
//       case ID_STREAM_MEDIUM:
//         _switchStream(ID_STREAM_HIGH);
//         break;
//     }
//     _lastPositionChecked = _player.position.inSeconds;
//     return;
//   }
//
//   if (_bufferCapacity < PLAYER_BUFFER_LOW_CAPACITY) {
//     switch (_currentStreamId) {
//       case ID_STREAM_HIGH:
//         _switchStream(ID_STREAM_MEDIUM);
//         break;
//       case ID_STREAM_MEDIUM:
//         _switchStream(ID_STREAM_LOW);
//         break;
//     }
//     _lastPositionChecked = _player.position.inSeconds;
//   }
// }

// _switchStream(int newStreamId) {
//   _currentStreamId = newStreamId;
//   _waitForConnection();
// }

// Future<void> _waitForConnection() async {
//   while (await internetConnectionCheck() == false) {
//     _logger.logError(
//         "No internet connection. Waiting $INTERNET_CONNECTION_CHECK_DURATION seconds for next check",
//         null);
//     await Future.delayed(
//         const Duration(seconds: INTERNET_CONNECTION_CHECK_DURATION));
//   }
//   try {
//     switch (_currentStreamId) {
//       case ID_STREAM_LOW:
//         final _newSource =
//             AudioSource.uri(Uri.parse(_systemData.streamData.streamLow));
//         await _player.setAudioSource(_newSource);
//         break;
//       case ID_STREAM_MEDIUM:
//         final _newSource =
//             AudioSource.uri(Uri.parse(_systemData.streamData.streamMedium));
//         await _player.setAudioSource(_newSource);
//         break;
//       case ID_STREAM_HIGH:
//         final _newSource =
//             AudioSource.uri(Uri.parse(_systemData.streamData.streamHigh));
//         await _player.setAudioSource(_newSource);
//         break;
//     }
//   } catch (error) {
//     _logger.logError("Player set audio source error", error);
//   }
// }

// Future<bool> internetConnectionCheck() async {
//   final connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult != ConnectivityResult.mobile &&
//       connectivityResult != ConnectivityResult.wifi) {
//     return false;
//   }
//   try {
//     final result = await InternetAddress.lookup('google.com');
//     return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
//   } on SocketException catch (_) {
//     return false;
//   }
// }
}
