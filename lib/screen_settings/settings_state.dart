import 'package:equatable/equatable.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class SettingsState extends Equatable {
  final int lang;
  final int startPlaying;
  final int theme;
  final StringKeys snackBarKey;

  const SettingsState(this.lang, this.startPlaying, this.theme, {this.snackBarKey = StringKeys.empty});

  @override
  List<Object?> get props => [lang, startPlaying, theme, snackBarKey];

  SettingsState copyWith({int? newLang, int? newStartPlaying, int? newTheme, StringKeys? newSnackBarKey}) =>
      SettingsState(newLang ?? lang, newStartPlaying ?? startPlaying, newTheme ?? theme,
          snackBarKey: newSnackBarKey ?? snackBarKey);
}
