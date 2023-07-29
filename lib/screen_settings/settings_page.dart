import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_settings/settings_bloc.dart';
import 'package:union_player_app/screen_settings/settings_event.dart';
import 'package:union_player_app/screen_settings/settings_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/widgets/snack_bar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (builderContext, state) => _createWidget(builderContext, state),
      bloc: get<SettingsBloc>(),
    );
  }

  Widget _createWidget(BuildContext context, SettingsState state) {
    if (state.snackBarKey != StringKeys.empty) {
      Future.microtask(() => showSnackBar(context, state.snackBarKey));
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createWidgetTheme(context, state),
        _createWidgetStartPlaying(context, state),
        _createWidgetLang(context, state),
      ],
    );
  }

  Widget _createWidgetTheme(BuildContext context, SettingsState state) => _createRow(
        _createLabel(context, StringKeys.settingsThemeLabel),
        _createButton(
          context,
          [
            StringKeys.settingsThemeLight,
            StringKeys.settingsThemeDark,
            StringKeys.settingsThemeSystem,
          ],
          [
            themeLight,
            themeDark,
            themeSystem,
          ],
          state.theme,
          (int? value) => get<SettingsBloc>().add(SettingsEventTheme(value ?? defaultThemeId)),
        ),
      );

  Widget _createWidgetStartPlaying(BuildContext context, SettingsState state) => _createRow(
        _createLabel(context, StringKeys.settingsStartPlayingLabel),
        _createButton(
          context,
          [
            StringKeys.settingsStartPlayingStart,
            StringKeys.settingsStartPlayingStop,
            StringKeys.settingsStartPlayingLast,
          ],
          [
            startPlayingStart,
            startPlayingStop,
            startPlayingLast,
          ],
          state.startPlaying,
          (int? value) => get<SettingsBloc>().add(SettingsEventStartPlaying(value ?? defaultStartPlayingId)),
        ),
      );

  Widget _createWidgetLang(BuildContext context, SettingsState state) => _createRow(
        _createLabel(context, StringKeys.settingsLangLabel),
        _createButton(
          context,
          [
            StringKeys.settingsLangSystem,
            StringKeys.settingsLangRU,
            StringKeys.settingsLangBY,
            StringKeys.settingsLangUS,
          ],
          [
            langSystem,
            langRU,
            langBY,
            langUS,
          ],
          state.lang,
          (int? value) => get<SettingsBloc>().add(SettingsEventLang(value ?? defaultLangId)),
        ),
      );

  Widget _createRow(Widget label, Widget button) {
    final labelContainer = Container(
      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: label,
    );
    return Row(children: [labelContainer, button]);
  }

  Widget _createLabel(BuildContext context, StringKeys key) {
    final text = translate(key, context);
    return Text(text, style: Theme.of(context).textTheme.bodyText2, overflow: TextOverflow.ellipsis);
  }

  Widget _createButton(
    BuildContext context,
    List<StringKeys> keys,
    List<int> values,
    int selectedItem,
    Function(int?) onChanged,
  ) {
    assert(keys.length == values.length);
    assert(selectedItem < values.length);

    final items = List<DropdownMenuItem<int>>.empty(growable: true);

    keys.asMap().forEach((index, key) {
      items.add(DropdownMenuItem(value: values[index], child: Text(translate(key, context))));
    });

    final textStyle = Theme.of(context).textTheme.bodyText1;
    final textColor = textStyle?.color;

    return DropdownButton<int>(
      value: selectedItem,
      icon: Icon(Icons.arrow_downward_rounded, color: textColor),
      iconSize: 24,
      elevation: 16,
      style: textStyle,
      underline: Container(height: 2, color: textColor),
      onChanged: onChanged,
      items: items,
    );
  }
}
