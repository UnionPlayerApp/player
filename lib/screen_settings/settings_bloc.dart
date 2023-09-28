import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:union_player_app/screen_settings/settings_event.dart';
import 'package:union_player_app/screen_settings/settings_state.dart';
import 'package:union_player_app/common/enums/language_type.dart';
import 'package:union_player_app/common/enums/settings_changing_result.dart';
import 'package:union_player_app/common/enums/sound_quality_type.dart';
import 'package:union_player_app/common/enums/start_playing_type.dart';
import 'package:union_player_app/common/enums/string_keys.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/system_data/system_data.dart';
import '../providers/shared_preferences_manager.dart';
import '../common/constants/constants.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const _emailScheme = 'mailto';
  static const _emailSubject = 'subject';

  final AudioHandler _audioHandler;
  final SPManager _spManager;
  final SystemData _systemData;

  SettingsBloc(this._audioHandler, this._spManager, this._systemData) : super(SettingsState.defaultState()) {
    on<SettingsInitEvent>(_onInit);
    on<SettingsChangedEvent>(_onChanged);
    on<SettingsContactUsEvent>(_onContactUs);

    add(SettingsInitEvent());
  }

  @override
  Future<void> close() async {
    debugPrint("CHPL => close()");
    return super.close();
  }

  FutureOr<void> _onInit(_, Emitter<SettingsState> emitter) {
    final newState = SettingsState(
      language: _spManager.readLanguageType(),
      soundQuality: _spManager.readSoundQualityType(),
      startPlaying: _spManager.readStartPlayingType(),
      themeMode: _spManager.readThemeMode(),
    );
    emitter(newState);
  }

  FutureOr<void> _onChanged(SettingsChangedEvent event, Emitter<SettingsState> emitter) async {
    final result = await _setChanges(event.value);
    switch (result) {
      case SettingsChangingResult.successWithInit:
        add(SettingsInitEvent());
        return;
      case SettingsChangingResult.successWithoutInit:
        return;
      case SettingsChangingResult.error:
        emitter(state.copyWith(snackBarKey: StringKeys.anyError));
        return;
    }
  }

  Future<SettingsChangingResult> _setChanges(dynamic value) {
    switch (value.runtimeType) {
      case LanguageType:
        return _setLanguage(value);
      case SoundQualityType:
        return _setSoundQuality(value);
      case StartPlayingType:
        return _setStartPlaying(value);
      case ThemeMode:
        return _setThemeMode(value);
      default:
        return Future.value(SettingsChangingResult.error);
    }
  }

  Future<SettingsChangingResult> _setSoundQuality(SoundQualityType value) {
    final params = {
      keySoundQuality: value.integer,
      keyIsPlaying: _audioHandler.playbackState.value.playing,
    };
    return Future.wait([
      _spManager.writeSoundQualityType(value),
      _audioHandler.customAction(actionSetSoundQuality, params),
    ]).then(
      (results) => results[0] as bool ? SettingsChangingResult.successWithInit : SettingsChangingResult.error,
    );
  }

  Future<SettingsChangingResult> _setLanguage(LanguageType value) {
    return Future.wait([
      _spManager.writeLanguageType(value),
      Get.updateLocale(value.locale),
    ]).then(
      (results) => results[0] as bool ? SettingsChangingResult.successWithoutInit : SettingsChangingResult.error,
    );
  }

  Future<SettingsChangingResult> _setStartPlaying(StartPlayingType value) {
    return _spManager
        .writeStartPlayingType(value)
        .then((result) => result ? SettingsChangingResult.successWithInit : SettingsChangingResult.error);
  }

  Future<SettingsChangingResult> _setThemeMode(ThemeMode value) {
    Get.changeThemeMode(value);
    return _spManager
        .writeThemeMode(value)
        .then((result) => result ? SettingsChangingResult.successWithInit : SettingsChangingResult.error);
  }

  FutureOr<void> _onContactUs(SettingsContactUsEvent event, Emitter<SettingsState> emitter) {
    final path = _systemData.emailData.mailingList.join(",");
    final query = "$_emailSubject=${event.subject}";
    final url = Uri(scheme: _emailScheme, path: path, query: query);
    launchUrl(url);
  }
}
