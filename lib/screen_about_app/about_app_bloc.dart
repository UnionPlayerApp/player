import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/model/system_data/system_data.dart';

import 'about_app_event.dart';
import 'about_app_state.dart';

class AboutAppBloc extends Bloc<AboutAppEvent, AboutAppState> {
  final SystemData _systemData;

  AboutAppBloc(this._systemData) : super(const AboutAppLoadingState()) {
    on<AboutAppInitEvent>(_onInitial);

    add(const AboutAppInitEvent());
  }

  FutureOr<void> _onInitial(AboutAppInitEvent event, Emitter<AboutAppState> emitter) {}
}
