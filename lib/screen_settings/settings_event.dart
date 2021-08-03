class SettingsEvent {}

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

class SettingsEventSharedPreferencesRead extends SettingsEvent {
  final int langId;
  final int startPlayingId;
  final int themeId;

  SettingsEventSharedPreferencesRead(this.langId, this.startPlayingId, this.themeId);
}
