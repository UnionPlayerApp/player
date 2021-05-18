import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/constants/constants.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final IScheduleRepository _repository;
  final AudioPlayer _player;
  final AppLogger _logger;
  final SystemData _systemData;
  int _lastPositionChecked = 0;
  int _currentStreamId = ID_STREAM_MEDIUM;
  final List<StreamSubscription> _subscriptions = List.empty(growable: true);

  AppBloc(this._repository, this._player, this._logger, this._systemData)
      : super(AppState(0, false, ProcessingState.idle)) {
    Timer.periodic(Duration(seconds: PLAYER_BUFFER_CHECK_DURATION),
        (Timer t) => _checkForBufferLoading());

    log("AppBloc() => repository subscribe invoke", name: LOG_TAG);
    _subscriptions.add(_repository.stream().listen((state) {
      if (state is ScheduleRepositoryLoadSuccessState) {
        log("repository.stream().listen() => Load SUCCESS ${state.items.length} items",
            name: LOG_TAG);
        add(AppScheduleEvent(state.items));
      }
      if (state is ScheduleRepositoryLoadErrorState) {
        log("repository.stream().listen() => Load ERROR ${state.error}",
            name: LOG_TAG);
        add(AppScheduleEvent(null));
      }
    }));

    log("AppBloc() => player.playbackEventStream subscribe invoke",
        name: LOG_TAG);
    _subscriptions.add(_player.playbackEventStream.listen((event) {
      // nothing
    }, onError: (Object e, StackTrace stackTrace) {
      _logger.logError("Audio player playback error", e);
      _waitForConnection();
    }));

    log("AppBloc() => player.playbackStateStream subscribe invoke",
        name: LOG_TAG);
    _subscriptions.add(_player.playerStateStream.listen((playerState) {
      log("AppBloc() => player.playbackStateStream.listen() => playerState = $playerState",
          name: LOG_TAG);
      add(AppPlayerEvent(playerState.playing, playerState.processingState));
    }));
  }

  @override
  Future<void> close() async {
    _subscriptions.forEach((subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    super.close();
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppFabEvent) {
      _player.playing ? _player.pause() : _player.play();
    }

    if (event is AppNavEvent) {
      yield AppState(event.navIndex, state.playingState, state.processingState,
          isScheduleLoaded: state.isScheduleLoaded,
          presentTitle: state.presentTitle,
          presentArtist: state.presentArtist,
          nextTitle: state.nextTitle,
          nextArtist: state.nextArtist);
    }

    if (event is AppPlayerEvent) {
      yield AppState(state.navIndex, event.playingState, event.processingState,
          isScheduleLoaded: state.isScheduleLoaded,
          presentTitle: state.presentTitle,
          presentArtist: state.presentArtist,
          nextTitle: state.nextTitle,
          nextArtist: state.nextArtist);
    }

    if (event is AppScheduleEvent) {
      if (event.items == null || event.items!.length < 2) {
        yield AppState(
            state.navIndex, state.playingState, state.processingState);
      } else {
        final presentItem = event.items![0];
        final nextItem = event.items![1];
        yield AppState(
            state.navIndex, state.playingState, state.processingState,
            isScheduleLoaded: true,
            presentArtist: presentItem.artist,
            presentTitle: presentItem.title,
            nextArtist: nextItem.artist,
            nextTitle: nextItem.title);
      }
    }
  }

  Future<void> _checkForBufferLoading() async {
    if (!await internetConnectionCheck() ||
        !_player.playing ||
        _player.position.inSeconds - _lastPositionChecked <
            PLAYER_BUFFER_UNCHECKABLE_DURATION) {
      return;
    }
    final _bufferCapacity =
        _player.bufferedPosition.inSeconds - _player.position.inSeconds;

    if (_bufferCapacity > PLAYER_BUFFER_HIGH_CAPACITY) {
      switch (_currentStreamId) {
        case ID_STREAM_LOW:
          _switchStream(ID_STREAM_MEDIUM);
          break;
        case ID_STREAM_MEDIUM:
          _switchStream(ID_STREAM_HIGH);
          break;
      }
      _lastPositionChecked = _player.position.inSeconds;
      return;
    }

    if (_bufferCapacity < PLAYER_BUFFER_LOW_CAPACITY) {
      switch (_currentStreamId) {
        case ID_STREAM_HIGH:
          _switchStream(ID_STREAM_MEDIUM);
          break;
        case ID_STREAM_MEDIUM:
          _switchStream(ID_STREAM_LOW);
          break;
      }
      _lastPositionChecked = _player.position.inSeconds;
    }
  }

  _switchStream(int newStreamId) {
    _currentStreamId = newStreamId;
    _waitForConnection();
  }

  Future<void> _waitForConnection() async {
    while (await internetConnectionCheck() == false) {
      _logger.logError(
          "No internet connection. Waiting $INTERNET_CONNECTION_CHECK_DURATION seconds for next check",
          null);
      await Future.delayed(
          const Duration(seconds: INTERNET_CONNECTION_CHECK_DURATION));
    }
    try {
      switch (_currentStreamId) {
        case ID_STREAM_LOW:
          final _newSource =
              AudioSource.uri(Uri.parse(_systemData.streamData.streamLow));
          await _player.setAudioSource(_newSource);
          break;
        case ID_STREAM_MEDIUM:
          final _newSource =
              AudioSource.uri(Uri.parse(_systemData.streamData.streamMedium));
          await _player.setAudioSource(_newSource);
          break;
        case ID_STREAM_HIGH:
          final _newSource =
              AudioSource.uri(Uri.parse(_systemData.streamData.streamHigh));
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
