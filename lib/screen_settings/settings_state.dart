import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:union_player_app/common/constants/constants.dart';
import 'package:union_player_app/common/enums/language_type.dart';
import 'package:union_player_app/common/enums/sound_quality_type.dart';
import 'package:union_player_app/common/enums/start_playing_type.dart';

import '../common/enums/string_keys.dart';

class SettingsState extends Equatable {
  final LanguageType language;
  final SoundQualityType soundQuality;
  final StartPlayingType startPlaying;
  final ThemeMode themeMode;
  final StringKeys snackBarKey;

  const SettingsState({
    required this.language,
    required this.soundQuality,
    required this.startPlaying,
    required this.themeMode,
    this.snackBarKey = StringKeys.empty,
  });

  factory SettingsState.defaultState() => const SettingsState(
        language: defaultLanguageType,
        soundQuality: defaultSoundQualityType,
        startPlaying: defaultStartPlayingType,
        themeMode: defaultThemeMode,
      );

  @override
  List<Object?> get props => [language, soundQuality, startPlaying, themeMode, snackBarKey];

  SettingsState copyWith({
    LanguageType? language,
    SoundQualityType? soundQuality,
    StartPlayingType? startPlaying,
    ThemeMode? themeMode,
    StringKeys? snackBarKey,
  }) =>
      SettingsState(
        language: language ?? this.language,
        soundQuality: soundQuality ?? this.soundQuality,
        startPlaying: startPlaying ?? this.startPlaying,
        themeMode: themeMode ?? this.themeMode,
        snackBarKey: snackBarKey ?? this.snackBarKey,
      );
}
