import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_settings/settings_bloc.dart';
import 'package:union_player_app/screen_settings/settings_event.dart';
import 'package:union_player_app/screen_settings/settings_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext pageContext) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) => _createWidget(context, state),
      bloc: get<SettingsBloc>(),
    );
  }

  Widget _createWidget(BuildContext context, SettingsState state) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createWidgetTheme(context, state),
        _createWidgetAudioQuality(context, state),
        _createWidgetStartPlaying(context, state),
        _createWidgetLang(context, state),
      ],
    );
  }

  Widget _createWidgetTheme(BuildContext context, SettingsState state) => _createRow(
        _createLabel(context, StringKeys.settings_theme_label),
        _createButton(
          context,
          [StringKeys.settings_theme_light, StringKeys.settings_theme_dark, StringKeys.settings_theme_system],
          [THEME_LIGHT, THEME_DARK, THEME_SYSTEM],
          state.theme,
          (int? value) => get<SettingsBloc>().add(SettingsEventTheme(value ?? DEFAULT_THEME_ID)),
        ),
      );

  Widget _createWidgetAudioQuality(BuildContext context, SettingsState state) => _createRow(
        _createLabel(context, StringKeys.settings_quality_label),
        _createButton(
          context,
          [StringKeys.settings_quality_low, StringKeys.settings_quality_medium, StringKeys.settings_quality_high],
          [AUDIO_QUALITY_LOW, AUDIO_QUALITY_MEDIUM, AUDIO_QUALITY_HIGH],
          state.audioQuality,
          (int? value) => get<SettingsBloc>().add(SettingsEventAudioQuality(value ?? DEFAULT_AUDIO_QUALITY_ID)),
        ),
      );

  Widget _createWidgetStartPlaying(BuildContext context, SettingsState state) => _createRow(
        _createLabel(context, StringKeys.settings_start_playing_label),
        _createButton(
          context,
          [
            StringKeys.settings_start_playing_start,
            StringKeys.settings_start_playing_stop,
            StringKeys.settings_start_playing_last,
          ],
          [START_PLAYING_START, START_PLAYING_STOP, START_PLAYING_LAST],
          state.startPlaying,
          (int? value) => get<SettingsBloc>().add(SettingsEventStartPlaying(value ?? DEFAULT_START_PLAYING_ID)),
        ),
      );

  Widget _createWidgetLang(BuildContext context, SettingsState state) => _createRow(
        _createLabel(context, StringKeys.settings_lang_label),
        _createButton(
          context,
          [
            StringKeys.settings_lang_system,
            StringKeys.settings_lang_ru,
            StringKeys.settings_lang_be,
            StringKeys.settings_lang_en,
          ],
          [LANG_SYSTEM, LANG_RU, LANG_BE, LANG_EN],
          state.lang,
          (int? value) => get<SettingsBloc>().add(SettingsEventLang(value ?? DEFAULT_LANG_ID)),
        ),
      );

  Widget _createRow(Widget label, Widget button) {
    final labelContainer = Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      child: label,
    );
    return Row(children: [labelContainer, button]);
  }

  Widget _createLabel(BuildContext context, StringKeys key) {
    final text = translate(key, context);
    return Text(text, style: TextStyle(fontSize: titleFontSize), overflow: TextOverflow.ellipsis);
  }

  Widget _createButton(
      BuildContext context, List<StringKeys> keys, List<int> values, int selectedItem, Function(int?) onChanged) {
    assert(keys.length == values.length);
    assert(selectedItem < values.length);

    final items = List<DropdownMenuItem<int>>.empty(growable: true);

    keys.asMap().forEach((index, key) {
      items.add(DropdownMenuItem(child: Text(translate(key, context)), value: values[index]));
    });

    return new DropdownButton<int>(
      value: selectedItem,
      icon: const Icon(Icons.arrow_downward_rounded),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: onChanged,
      items: items,
    );
  }
}
