import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:union_player_app/screen_settings/settings_bloc.dart';
import 'package:union_player_app/screen_settings/settings_event.dart';
import 'package:union_player_app/screen_settings/settings_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/widgets/snack_bar.dart';

import '../utils/enums/settings_item_type.dart';
import '../utils/enums/string_keys.dart';
import '../utils/dimensions/dimensions.dart';
import '../utils/ui/text_styles.dart';

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
        _themeWidget(context, state),
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

  Widget _sectionTitle(BuildContext context, {required StringKeys key}) => Text(
        translate(key, context),
        style: TextStyles.screenTitle20px,
      );

  Widget _soundQualityWidget(BuildContext context, SettingsState state) => _settingsItemWidget(
        context,
        labelKey: StringKeys.settingsQualityLabel,
        valueKey: state.soundQualityKey,
        itemType: SettingsItemType.soundQuality,
      );

  Widget _startPlayingWidget(BuildContext context, SettingsState state) => _settingsItemWidget(
        context,
        labelKey: StringKeys.settingsStartPlayingLabel,
        valueKey: state.startPlayingKey,
        itemType: SettingsItemType.startPlaying,
      );

  Widget _themeWidget(BuildContext context, SettingsState state) => _settingsItemWidget(
        context,
        labelKey: StringKeys.settingsThemeLabel,
        valueKey: state.themeKey,
        itemType: SettingsItemType.theme,
      );

  Widget _languageWidget(BuildContext context, SettingsState state) => _settingsItemWidget(context,
      labelKey: StringKeys.settingsLangLabel, valueKey: state.langKey, itemType: SettingsItemType.language);

  Widget _settingsItemWidget(
    BuildContext context, {
    required StringKeys labelKey,
    required StringKeys valueKey,
    required SettingsItemType itemType,
  }) {
    return InkWell(
      onTap: () => context.read<SettingsBloc>().add(SettingsItemTapEvent(itemType: itemType)),
      child: Row(
        children: [
          Text(translate(labelKey, context), style: TextStyles.screenContent),
          const Spacer(),
          Text(translate(valueKey, context), style: TextStyles.screenContent),
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
            Text(translate(labelKey, context), style: TextStyles.screenContent),
            const Spacer(),
            SvgPicture.asset(AppIcons.icArrowForward),
          ],
        ),
      );

  Widget _divider() => Divider(height: listViewDividerHeight);
}
