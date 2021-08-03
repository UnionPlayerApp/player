import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/screen_settings/settings_event.dart';
import 'package:union_player_app/screen_settings/settings_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/shared_preferences.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(
      {int langId: DEFAULT_LANG_ID, int startPlayingId: DEFAULT_START_PLAYING_ID, int themeId: DEFAULT_THEME_ID})
      : super(SettingsState(langId, startPlayingId, themeId)) {
    _readStateFromSharedPreferences();
  }

  @override
  Stream<SettingsState> mapEventToState(event) async* {
    late final SettingsState newState;
    if (event is SettingsEventSharedPreferencesRead) {
      newState = SettingsState(event.langId, event.startPlayingId, event.themeId);
    } else if (event is SettingsEventTheme) {
      _doThemeChanged(event.themeId);
      newState = state.copyWith(newTheme: event.themeId, newSnackBarKey: StringKeys.will_made_next_release);
    } else if (event is SettingsEventLang) {
      _doLangChanged(event.langId);
      newState = state.copyWith(newLang: event.langId, newSnackBarKey: StringKeys.will_made_next_release);
    } else if (event is SettingsEventStartPlaying) {
      _doStartPlayingChanged(event.startPlayingId);
      newState = state.copyWith(newStartPlaying: event.startPlayingId, newSnackBarKey: StringKeys.empty);
    } else {
      log("SettingsBloc -> mapEventToState -> unknown event type $event", name: LOG_TAG);
      return;
    }
    yield newState;
  }

  void _doThemeChanged(int themeId) {
    writeIntToSharedPreferences(KEY_THEME, themeId);
  }

  void _doLangChanged(int langId) {
    writeIntToSharedPreferences(KEY_LANG, langId);
  }

  void _doStartPlayingChanged(int startPlayingId) {
    writeIntToSharedPreferences(KEY_START_PLAYING, startPlayingId);
  }

  void _readStateFromSharedPreferences() async {
    Future.wait([
      readIntFromSharedPreferences(KEY_LANG),
      readIntFromSharedPreferences(KEY_START_PLAYING),
      readIntFromSharedPreferences(KEY_THEME),
    ])
        .then((params) => _onSharedPreferencesReadSuccess(params))
        .catchError((error) => _onSharedPreferencesReadError(error));
  }

  _onSharedPreferencesReadSuccess(List<int?> params) {
    assert(params.length == 3);
    final int langId = params[0] ?? DEFAULT_LANG_ID;
    final int startPlayingId = params[1] ?? DEFAULT_START_PLAYING_ID;
    final int themeId = params[2] ?? DEFAULT_THEME_ID;
    add(SettingsEventSharedPreferencesRead(langId, startPlayingId, themeId));
  }

  _onSharedPreferencesReadError(error) {
    log("shared preferences read error: $error", name: LOG_TAG);
  }
}
