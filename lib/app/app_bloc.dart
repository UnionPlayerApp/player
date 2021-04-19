import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/app/app_event.dart';
import 'package:union_player_app/app/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {

  AppBloc(AppState initialState) : super(initialState);

  // AppBloc() : super(AppState(
  //     AudioPlayer()
  // ));

  @override
  Stream<AppState> mapEventToState(AppEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

}