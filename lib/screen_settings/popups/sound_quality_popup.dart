import 'package:union_player_app/common/enums/sound_quality_type.dart';
import 'package:union_player_app/common/enums/string_keys.dart';

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
