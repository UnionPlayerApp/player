import 'package:equatable/equatable.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class SettingsState extends Equatable {
  final int audioQuality;
  final int lang;
  final int startPlaying;
  final int theme;
  final StringKeys snackBarKey;

  const SettingsState(this.audioQuality, this.lang, this.startPlaying, this.theme,
      {this.snackBarKey: StringKeys.empty});

  @override
  List<Object?> get props => [audioQuality, lang, startPlaying, theme, snackBarKey];

  SettingsState copyWith(
          {int? newAudioQuality,
          int? newLang,
          int? newStartPlaying,
          int? newTheme,
          StringKeys? newSnackBarKey}) =>
      SettingsState(
          newAudioQuality ?? audioQuality, newLang ?? lang, newStartPlaying ?? startPlaying, newTheme ?? theme,
          snackBarKey: newSnackBarKey ?? snackBarKey);
}
