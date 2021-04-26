import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/utils/AppLogger.dart';

import 'main_event.dart';
import 'main_state.dart';

const STREAM_URL = "http://78.155.222.238:8010/souz_radio_192.mp3";

class MainBloc extends Bloc<MainEvent, MainState> {
  late AppLogger _logger;
  late AudioPlayer _player;

  MainBloc(this._player, this._logger)
      : super(MainState("Stopping", "Initialising", Icons.play_arrow_rounded)) {
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _player.playerStateStream.listen((playerState) {
      switch (playerState.processingState) {
        case ProcessingState.idle:
          add(PlayerStateChangedToIdle(playerState.playing));
          break;
        case ProcessingState.loading:
          add(PlayerStateChangedToLoading(playerState.playing));
          break;
        case ProcessingState.buffering:
          add(PlayerStateChangedToBuffering(playerState.playing));
          break;
        case ProcessingState.ready:
          add(PlayerStateChangedToReady(playerState.playing));
          break;
        case ProcessingState.completed:
          add(PlayerStateChangedToCompleted(playerState.playing));
          break;
      }
    });

    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      _showError("Audio stream error: $e", Error());
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

  Stream<MainState> _mapPlayPauseFabPressedToState() async* {
    String stateStr01 = state.stateStr01;
    IconData iconData = state.iconData;

    if (_player.processingState == ProcessingState.ready) {
      stateStr01 = _createStateStr01(!_player.playing);
      iconData = _createIconData(!_player.playing);
      _setPlayerMode(!_player.playing);
    }

    yield MainState(stateStr01, state.stateStr02, iconData);
  }

  Stream<MainState> _mapPlayerStateChangedBufferingToState(
      bool isPlaying) async* {
    yield MainState(state.stateStr01, "Buffering", _createIconData(isPlaying));
  }

  Stream<MainState> _mapPlayerStateChangedCompletedToState(
      bool isPlaying) async* {
    yield MainState(state.stateStr01, "Completed", _createIconData(isPlaying));
  }

  Stream<MainState> _mapPlayerStateChangedLoadingToState(
      bool isPlaying) async* {
    yield MainState(state.stateStr01, "Loading", _createIconData(isPlaying));
  }

  Stream<MainState> _mapPlayerStateChangedIdleToState(bool isPlaying) async* {
    yield MainState(state.stateStr01, "Idle", _createIconData(isPlaying));
  }

  Stream<MainState> _mapPlayerStateChangedReadyToState(bool isPlaying) async* {
    yield MainState(state.stateStr01, "Ready", _createIconData(isPlaying));
  }

  void _setPlayerMode(bool isPlaying) =>
      isPlaying ? _player.play() : _player.pause();

  String _createStateStr01(bool isPlaying) => isPlaying ? "Playing" : "Stopping";

  IconData _createIconData(bool isPlaying) =>
      isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded;

  //TODO: нужно понять, вызывается ли этот метод автоматом,
  //TODO: или нужно сделать вызов явно
  @override
  Future<void> close() async {
    _player.playbackEventStream.listen(null);
    _player.playerStateStream.listen(null);
    super.close();
  }

  //TODO: нужно сделать отображение ошибок на экране
  void _showError(String msg, Error error) {
    _logger.logError(msg, error);
  }
}
