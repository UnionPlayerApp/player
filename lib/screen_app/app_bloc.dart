import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AudioPlayer _player;

  AppBloc(this._player) : super(AppState(0, false));

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
}
