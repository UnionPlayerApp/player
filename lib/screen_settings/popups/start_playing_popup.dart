import 'package:union_player_app/utils/enums/start_playing_type.dart';
import 'package:union_player_app/utils/enums/string_keys.dart';

import 'settings_popup.dart';

class StartPlayingPopup extends SettingsPopup<StartPlayingType> {
  StartPlayingPopup({required StartPlayingType initialValue})
      : super(
          titleKey: StringKeys.settingsStartPlayingLabel,
          currentValue: initialValue,
          values: [
            StartPlayingType.start,
            StartPlayingType.stop,
            StartPlayingType.last,
          ],
          keys: [
            StringKeys.settingsStartPlayingStart,
            StringKeys.settingsStartPlayingStop,
            StringKeys.settingsStartPlayingLast,
          ],
        );
}
