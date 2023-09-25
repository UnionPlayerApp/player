import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:union_player_app/screen_settings/settings_event.dart';
import 'package:union_player_app/screen_settings/settings_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/shared_preferences.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';

import '../utils/enums/string_keys.dart';
import '../utils/core/locale_utils.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    int langId = defaultLanguageType,
    int startPlayingId = defaultStartPlayingType,
    int themeId = defaultThemeType,
  }) : super(SettingsState(langId, startPlayingId, themeId)) {
    on<SettingsEventSharedPreferencesRead>(_onSharedPreferencesRead);
    on<SettingsEventTheme>(_onTheme);
    on<SettingsEventLang>(_onLang);
    on<SettingsEventStartPlaying>(_onStartPlaying);
    _readStateFromSharedPreferences();
  }

  FutureOr<void> _onSharedPreferencesRead(SettingsEventSharedPreferencesRead event, Emitter<SettingsState> emitter) {
    final newState = SettingsState(event.langId, event.startPlayingId, event.themeId);
    emitter(newState);
  }

  FutureOr<void> _onTheme(SettingsEventTheme event, Emitter<SettingsState> emitter) async {
    await writeIntToSharedPreferences(keyTheme, event.themeId);
    setThemeById(event.themeId);
    final newState = state.copyWith(themeKey: event.themeId);
    emitter(newState);
  }

  FutureOr<void> _onLang(SettingsEventLang event, Emitter<SettingsState> emitter) async {
    await writeIntToSharedPreferences(keyLanguage, event.langId);
    final newLocale = getLocaleByLanguageType(event.langId);
    Get.updateLocale(newLocale);
    final newState = state.copyWith(langKey: event.langId);
    emitter(newState);
  }

  FutureOr<void> _onStartPlaying(SettingsEventStartPlaying event, Emitter<SettingsState> emitter) {
    _doStartPlayingChanged(event.startPlayingId);
    final newState = state.copyWith(startPlayingKey: event.startPlayingId, snackBarKey: StringKeys.empty);
    emitter(newState);
  }

  void _doStartPlayingChanged(int startPlayingId) {
    writeIntToSharedPreferences(keyStartPlaying, startPlayingId);
  }

  void _readStateFromSharedPreferences() async {
    Future.wait([
      readIntFromSharedPreferences(keyLanguage),
      readIntFromSharedPreferences(keyStartPlaying),
      readIntFromSharedPreferences(keyTheme),
    ])
        .then((params) => _onSharedPreferencesReadSuccess(params))
        .catchError((error) => _onSharedPreferencesReadError(error));
  }

  _onSharedPreferencesReadSuccess(List<int?> params) {
    assert(params.length == 3);
    final int langId = params[0] ?? defaultLanguageType;
    final int startPlayingId = params[1] ?? defaultStartPlayingType;
    final int themeId = params[2] ?? defaultThemeType;
    add(SettingsEventSharedPreferencesRead(langId, startPlayingId, themeId));
  }

  _onSharedPreferencesReadError(error) {
    debugPrint("shared preferences read error: $error");
  }
}
