import 'package:equatable/equatable.dart';

import '../utils/enums/string_keys.dart';

class SettingsState extends Equatable {
  final StringKeys langKey;
  final StringKeys snackBarKey;
  final StringKeys soundQualityKey;
  final StringKeys startPlayingKey;
  final StringKeys themeKey;

  const SettingsState({
    required this.langKey,
    required this.soundQualityKey,
    required this.startPlayingKey,
    required this.themeKey,
    this.snackBarKey = StringKeys.empty,
  });

  factory SettingsState.default() => SettingsState(langKey: langKey, soundQualityKey: soundQualityKey, startPlayingKey: startPlayingKey, themeKey: themeKey,)

  @override
  List<Object?> get props => [langKey, soundQualityKey, startPlayingKey, themeKey, snackBarKey];

  SettingsState copyWith({
    StringKeys? langKey,
    StringKeys? soundQualityKey,
    StringKeys? startPlayingKey,
    StringKeys? themeKey,
    StringKeys? snackBarKey,
  }) =>
      SettingsState(
        langKey: langKey ?? this.langKey,
        soundQualityKey: soundQualityKey ?? this.soundQualityKey,
        startPlayingKey: startPlayingKey ?? this.startPlayingKey,
        themeKey: themeKey ?? this.themeKey,
        snackBarKey: snackBarKey ?? this.snackBarKey,
      );
}
