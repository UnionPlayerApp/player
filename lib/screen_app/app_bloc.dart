import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {

  late final StreamSubscription _customSubscription;
  late final StreamSubscription _playerSubscription;
  late final StreamSubscription _queueSubscription;

  AppBloc()
      : super(AppState(0, false)) {

    // Timer.periodic(Duration(seconds: PLAYER_BUFFER_CHECK_DURATION),
    //     (Timer t) => _checkForBufferLoading());

    _customSubscription = AudioService.customEventStream.listen((error) => _onCustomEvent(error));
    _queueSubscription = AudioService.queueStream.listen((queue) => _onQueueEvent(queue));
    _playerSubscription = AudioService.playbackStateStream.listen((state) => _onPlaybackEvent(state));
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

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppFabEvent) {
      FirebaseCrashlytics.instance.crash();
      if (AudioService.playbackState.playing) {
        AudioService.pause();
      } else {
        AudioService.play();
      }
    } else if (event is AppNavEvent) {
      yield AppState(event.navIndex, state.playingState, //state.processingState,
          isScheduleLoaded: state.isScheduleLoaded,
          presentTitle: state.presentTitle,
          presentArtist: state.presentArtist,
          nextTitle: state.nextTitle,
          nextArtist: state.nextArtist);
    } else if (event is AppPlayerEvent) {
      yield AppState(state.navIndex, event.playingState, //event.processingState,
          isScheduleLoaded: state.isScheduleLoaded,
          presentTitle: state.presentTitle,
          presentArtist: state.presentArtist,
          nextTitle: state.nextTitle,
          nextArtist: state.nextArtist);
    } else if (event is AppScheduleEvent) {
      if (event.items == null || event.items!.length < 2) {
        yield AppState(state.navIndex, state.playingState, ); //state.processingState);
      } else {
        final presentItem = event.items![0];
        final nextItem = event.items![1];
        yield AppState(state.navIndex, state.playingState, //state.processingState,
            isScheduleLoaded: true,
            presentArtist: presentItem.artist ?? "",
            presentTitle: presentItem.title,
            nextArtist: nextItem.artist ?? "",
            nextTitle: nextItem.title);
      }
    }
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