import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:union_player_app/screen_settings/popups/language_popup.dart';
import 'package:union_player_app/screen_settings/popups/settings_popup.dart';
import 'package:union_player_app/screen_settings/popups/sound_quality_popup.dart';
import 'package:union_player_app/screen_settings/popups/start_playing_popup.dart';
import 'package:union_player_app/screen_settings/popups/theme_mode_popup.dart';
import 'package:union_player_app/screen_settings/settings_bloc.dart';
import 'package:union_player_app/screen_settings/settings_state.dart';
import 'package:union_player_app/common/constants/constants.dart';
import 'package:union_player_app/common/enums/language_type.dart';
import 'package:union_player_app/common/enums/sound_quality_type.dart';
import 'package:union_player_app/common/enums/start_playing_type.dart';
import 'package:union_player_app/common/enums/theme_mode.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';
import 'package:union_player_app/common/widgets/snack_bar.dart';

import '../common/dimensions/dimensions.dart';
import '../common/enums/string_keys.dart';
import '../common/ui/app_colors.dart';
import '../common/ui/text_styles.dart';
import 'settings_event.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (builderContext, state) => _createWidget(builderContext, state),
    );
  }

  Widget _createWidget(BuildContext context, SettingsState state) {
    if (state.snackBarKey != StringKeys.empty) {
      Future.microtask(() => showSnackBar(context, messageKey: state.snackBarKey));
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._settingsSection(context, state),
        ..._otherSection(context, state),
      ],
    );
  }

  List<Widget> _settingsSection(BuildContext context, SettingsState state) => [
        _sectionTitle(context, key: StringKeys.settings),
        _soundQualityWidget(context, state),
        _divider(),
        _startPlayingWidget(context, state),
        _divider(),
        _themeModeWidget(context, state),
        _divider(),
        _languageWidget(context, state),
      ];

  List<Widget> _otherSection(BuildContext context, SettingsState state) => [
        _sectionTitle(context, key: StringKeys.other),
        _contactUsWidget(context),
        _divider(),
        _aboutRadioWidget(context),
        _divider(),
        _aboutAppWidget(context),
      ];

  Widget _sectionTitle(BuildContext context, {required StringKeys key}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40.0),
    child: Text(
          translate(key, context),
          style: TextStyles.bold20BlackOlive,
        ),
  );

  Widget _soundQualityWidget(BuildContext context, SettingsState state) => _settingsItemWidget<SoundQualityType>(
        context,
        labelKey: StringKeys.settingsQualityLabel,
        valueKey: state.soundQuality.labelKey,
        popup: SoundQualityPopup(initialValue: state.soundQuality),
      );

  Widget _startPlayingWidget(BuildContext context, SettingsState state) => _settingsItemWidget<StartPlayingType>(
        context,
        labelKey: StringKeys.settingsStartPlayingLabel,
        valueKey: state.startPlaying.labelKey,
        popup: StartPlayingPopup(initialValue: state.startPlaying),
      );

  Widget _themeModeWidget(BuildContext context, SettingsState state) => _settingsItemWidget<ThemeMode>(
        context,
        labelKey: StringKeys.settingsThemeLabel,
        valueKey: state.themeMode.labelKey,
        popup: ThemeModePopup(initialValue: state.themeMode),
      );

  Widget _languageWidget(BuildContext context, SettingsState state) => _settingsItemWidget<LanguageType>(
        context,
        labelKey: StringKeys.settingsLangLabel,
        valueKey: state.language.labelKey,
        popup: LanguagePopup(initialValue: state.language),
      );

  Widget _settingsItemWidget<T>(
    BuildContext context, {
    required StringKeys labelKey,
    required StringKeys valueKey,
    required SettingsPopup<T> popup,
  }) {
    return InkWell(
      onTap: () => popup.show(context).then(
            (value) => value != null ? context.read<SettingsBloc>().add(SettingsChangedEvent<T>(value: value)) : {},
          ),
      child: Row(
        children: [
          Text(translate(labelKey, context), style: TextStyles.regular16BlackOlive),
          const Spacer(),
          Text(translate(valueKey, context), style: TextStyles.regular16BlackOlive),
        ],
      ),
    );
  }

  Widget _contactUsWidget(BuildContext context) => _otherItemWidget(
        context,
        labelKey: StringKeys.write,
        onTap: () => debugPrint("write"),
      );

  Widget _aboutRadioWidget(BuildContext context) => _otherItemWidget(
        context,
        labelKey: StringKeys.aboutRadio,
        onTap: () => debugPrint("aboutRadio"),
      );

  Widget _aboutAppWidget(BuildContext context) => _otherItemWidget(
        context,
        labelKey: StringKeys.aboutApp,
        onTap: () => debugPrint("aboutApp"),
      );

  Widget _otherItemWidget(
    BuildContext context, {
    required StringKeys labelKey,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Text(translate(labelKey, context), style: TextStyles.regular16BlackOlive),
            const Spacer(),
            SvgPicture.asset(AppIcons.icArrowForward),
          ],
        ),
      );

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    child: Divider(height: listViewDividerHeight, color: AppColors.platinum),
  );
}
