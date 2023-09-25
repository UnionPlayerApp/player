import 'package:union_player_app/utils/enums/settings_item_type.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class SettingsItemTapEvent extends SettingsEvent {
  final SettingsItemType itemType;

  const SettingsItemTapEvent({required this.itemType});
}

class SettingsEventSharedPreferencesRead extends SettingsEvent {
  final int langId;
  final int startPlayingId;
  final int themeId;

  const SettingsEventSharedPreferencesRead(this.langId, this.startPlayingId, this.themeId);
}
