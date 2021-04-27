import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';
import 'package:union_player_app/utils/app_logger.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final AppLogger _logger;
  final AudioPlayer _player;

  MainBloc(this._player, this._logger)
      : super(MainState("Stop", "Initialising"));

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
