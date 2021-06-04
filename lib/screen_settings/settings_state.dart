import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final int audioQuality;
  final int lang;
  final int startPlaying;
  final int theme;

  const SettingsState(this.audioQuality, this.lang, this.startPlaying, this.theme);

  @override
  List<Object?> get props => [audioQuality, lang, startPlaying, theme];

  SettingsState copyWith({int? newAudioQuality, int? newLang, int? newStartPlaying, int? newTheme}) => SettingsState(
      newAudioQuality ?? audioQuality, newLang ?? lang, newStartPlaying ?? startPlaying, newTheme ?? theme);
}
