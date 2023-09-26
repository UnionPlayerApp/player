import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AudioHandler _audioHandler;

  late final StreamSubscription _customSubscription;

  AppBloc(this._audioHandler, bool isPlaying) : super(AppState.defaultState()) {
    on<AppNavEvent>(_onNav);
    on<AppCustomEvent>(_onCustomEvent);

    _customSubscription = _audioHandler.customEvent.listen((error) => add(
          AppCustomEvent(error: error),
        ));
  }


  @override
  Future<void> close() async {
    _customSubscription.cancel();
    super.close();
  }

  FutureOr<void> _onNav(AppNavEvent event, Emitter<AppState> emitter) {
    final newState = state.copyWith(navType: event.navType);
    emitter(newState);
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

  FutureOr<void> _onCustomEvent(AppCustomEvent event, Emitter<AppState> emitter) {
    final newState = state.copyWith(message: event.error);
    emitter(newState);
  }
}
