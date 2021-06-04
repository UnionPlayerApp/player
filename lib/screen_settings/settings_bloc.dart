import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_player_app/screen_settings/settings_event.dart';
import 'package:union_player_app/screen_settings/settings_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(DEFAULT_AUDIO_QUALITY_ID, DEFAULT_LANG_ID, DEFAULT_START_PLAYING_ID, DEFAULT_THEME_ID));

  // SettingsBloc.fromSharedPreferences(SharedPreferences sp) {
  //
  // }

  @override
  Stream<SettingsState> mapEventToState(event) async* {
    late final SettingsState newState;
    if (event is SettingsEventTheme) {
      _doThemeChanged(event.themeId);
      newState = state.copyWith(newTheme: event.themeId);
    } else if (event is SettingsEventLang) {
      _doLangChanged(event.langId);
      newState = state.copyWith(newLang: event.langId);
    } else if (event is SettingsEventAudioQuality) {
      _doAudioQualityChanged(event.audioQualityId);
      newState = state.copyWith(newAudioQuality: event.audioQualityId);
    } else if (event is SettingsEventStartPlaying) {
      _doStartPlayingChanged(event.startPlayingId);
      newState = state.copyWith(newStartPlaying: event.startPlayingId);
    } else {
      log("SettingsBloc -> mapEventToState -> unknown event type $event", name: LOG_TAG);
      return;
    }
    yield newState;
  }

  void _doThemeChanged(int themeId) {

  }

  void _doLangChanged(int langId) {

  }

  void _doAudioQualityChanged(int audioQualityId) {

  }

  void _doStartPlayingChanged(int startPlayingId) {

  }
}