import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  late final StreamSubscription _appBlocStreamSubscription;

  MainBloc(AppBloc appBloc)
      : super(MainState("Stop", "Idle")) {
    _appBlocStreamSubscription = appBloc.stream.listen((appState) {
      add(MainEvent(appState.playingState, appState.processingState));
    });
  }

  @override
  Future<void> close() {
    _appBlocStreamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    final stateStr01 = event.playingState ? "Play" : "Stop";

    var stateStr02 = "Unknown player processing state";

    switch (event.processingState) {
      case ProcessingState.idle:
        stateStr02 = "Idle";
        break;
      case ProcessingState.loading:
        stateStr02 = "Loading";
        break;
      case ProcessingState.buffering:
        stateStr02 = "Buffering";
        break;
      case ProcessingState.ready:
        stateStr02 = "Ready";
        break;
      case ProcessingState.completed:
        stateStr02 = "Completed";
        break;
    }

    yield MainState(stateStr01, stateStr02);
  }
}
