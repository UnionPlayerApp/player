class SettingsEvent {}

class SettingsEventAudioQuality extends SettingsEvent {
  final int audioQualityId;

  SettingsEventAudioQuality(this.audioQualityId);
}

class SettingsEventLang extends SettingsEvent {
  final int langId;

  SettingsEventLang(this.langId);
}

class SettingsEventStartPlaying extends SettingsEvent {
  final int startPlayingId;

  SettingsEventStartPlaying(this.startPlayingId);
}

class SettingsEventTheme extends SettingsEvent {
  final int themeId;

  SettingsEventTheme(this.themeId);
}
