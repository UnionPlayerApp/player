import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_player_app/screen_settings/settings_event.dart';
import 'package:union_player_app/screen_settings/settings_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(
      {int audioQualityId: DEFAULT_AUDIO_QUALITY_ID,
      int langId: DEFAULT_LANG_ID,
      int startPlayingId: DEFAULT_START_PLAYING_ID,
      int themeId: DEFAULT_THEME_ID})
      : super(SettingsState(audioQualityId, langId, startPlayingId, themeId)) {
    _readStateFromSharedPreferences();
  }

  @override
  Stream<SettingsState> mapEventToState(event) async* {
    late final SettingsState newState;
    if (event is SettingsEventSharedPreferencesRead) {
      newState = SettingsState(event.audioQualityId, event.langId, event.startPlayingId, event.themeId);
    } else if (event is SettingsEventTheme) {
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
    _writeIntToSharedPreferences(KEY_THEME, themeId);
  }

  void _doLangChanged(int langId) {
    _writeIntToSharedPreferences(KEY_LANG, langId);
  }

  void _doAudioQualityChanged(int audioQualityId) {
    Map<String, dynamic> params = {
      KEY_AUDIO_QUALITY: audioQualityId,
      KEY_IS_PLAYING: AudioService.playbackState.playing,
    };
    AudioService.customAction(PLAYER_TASK_ACTION_SET_AUDIO_QUALITY, params);
    _writeIntToSharedPreferences(KEY_AUDIO_QUALITY, audioQualityId);
  }

  void _doStartPlayingChanged(int startPlayingId) {
    _writeIntToSharedPreferences(KEY_START_PLAYING, startPlayingId);
  }

  Future<int?> _readIntFromSharedPreferences(String key) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? value = sp.getInt(key);
    return value;
  }

  void _writeIntToSharedPreferences(String key, int value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt(key, value);
  }

  void _readStateFromSharedPreferences() async {
    Future.wait([
      _readIntFromSharedPreferences(KEY_AUDIO_QUALITY),
      _readIntFromSharedPreferences(KEY_LANG),
      _readIntFromSharedPreferences(KEY_START_PLAYING),
      _readIntFromSharedPreferences(KEY_THEME),
    ])
        .then((params) => _onSharedPreferencesReadSuccess(params))
        .catchError((error) => _onSharedPreferencesReadError(error));
  }

  _onSharedPreferencesReadSuccess(List<int?> params) {
    assert(params.length == 4);
    final int audioQualityId = params[0] ?? DEFAULT_AUDIO_QUALITY_ID;
    final int langId = params[1] ?? DEFAULT_LANG_ID;
    final int startPlayingId = params[2] ?? DEFAULT_START_PLAYING_ID;
    final int themeId = params[3] ?? DEFAULT_THEME_ID;
    add(SettingsEventSharedPreferencesRead(audioQualityId, langId, startPlayingId, themeId));
  }

  _onSharedPreferencesReadError(error) {
    log("shared preferences read error: $error", name: LOG_TAG);
  }
}
