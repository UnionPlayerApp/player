import 'package:union_player_app/utils/enums/language_type.dart';
import 'package:union_player_app/utils/enums/string_keys.dart';

import 'settings_popup.dart';

class LanguagePopup extends SettingsPopup<LanguageType> {
  LanguagePopup({required LanguageType initialValue})
      : super(
          titleKey: StringKeys.settingsLangLabel,
          currentValue: initialValue,
          values: [
            LanguageType.ru,
            LanguageType.by,
            LanguageType.us,
            LanguageType.system,
          ],
          keys: [
            StringKeys.settingsLangRU,
            StringKeys.settingsLangBY,
            StringKeys.settingsLangUS,
            StringKeys.settingsLangSystem,
          ],
        );
}
