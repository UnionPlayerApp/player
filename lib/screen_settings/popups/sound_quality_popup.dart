import 'package:union_player_app/utils/enums/sound_quality_type.dart';
import 'package:union_player_app/utils/enums/string_keys.dart';

import 'settings_popup.dart';

class SoundQualityPopup extends SettingsPopup<SoundQualityType> {
  SoundQualityPopup({required SoundQualityType initialValue})
      : super(
          titleKey: StringKeys.settingsQualityLabel,
          currentValue: initialValue,
          values: [
            SoundQualityType.low,
            SoundQualityType.medium,
            SoundQualityType.high,
          ],
          keys: [
            StringKeys.settingsQualityLow,
            StringKeys.settingsQualityMedium,
            StringKeys.settingsQualityHigh,
          ],
        );
}
