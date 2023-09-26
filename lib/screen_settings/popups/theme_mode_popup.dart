import 'package:flutter/material.dart';
import 'package:union_player_app/utils/enums/string_keys.dart';

import 'settings_popup.dart';

class ThemeModePopup extends SettingsPopup<ThemeMode> {
  ThemeModePopup({required ThemeMode initialValue})
      : super(
          titleKey: StringKeys.settingsThemeLabel,
          currentValue: initialValue,
          values: [
            ThemeMode.light,
            ThemeMode.dark,
            ThemeMode.system,
          ],
          keys: [
            StringKeys.settingsThemeLight,
            StringKeys.settingsThemeDark,
            StringKeys.settingsThemeSystem,
          ],
        );
}
