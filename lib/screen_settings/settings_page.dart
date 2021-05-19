import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createRow(
          _createLabel(context, StringKeys.settings_theme_label),
          _createButton(context, [
            StringKeys.settings_theme_light,
            StringKeys.settings_theme_dark,
            StringKeys.settings_theme_system,
          ]),
        ),
        _createRow(
          _createLabel(context, StringKeys.settings_quality_label),
          _createButton(context, [
            StringKeys.settings_quality_low,
            StringKeys.settings_quality_medium,
            StringKeys.settings_quality_high,
            StringKeys.settings_quality_auto,
          ]),
        ),
        _createRow(
          _createLabel(context, StringKeys.settings_start_playing_label),
          _createButton(context, [
            StringKeys.settings_start_playing_start,
            StringKeys.settings_start_playing_stop,
            StringKeys.settings_start_playing_last,
          ]),
        ),
        _createRow(
          _createLabel(context, StringKeys.settings_lang_label),
          _createButton(context, [
            StringKeys.settings_lang_ru,
            StringKeys.settings_lang_be,
            StringKeys.settings_lang_en,
            StringKeys.settings_lang_system,
          ]),
        ),
      ],
    );
  }

  Widget _createRow(Widget label, Widget button) {
    final labelContainer = Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      child: label,
    );
    return Row(children: [labelContainer, button]);
  }

  Widget _createLabel(BuildContext context, StringKeys key) {
    final text = translate(key, context);
    return Text(text,
        style: TextStyle(fontSize: titleFontSize),
        overflow: TextOverflow.ellipsis);
  }

  Widget _createButton(BuildContext context, List<StringKeys> keys) {
    final items =
        keys.map((key) => translate(key, context)).toList(growable: false);
    return new DropdownButton<String>(
      value: items[0],
      icon: const Icon(Icons.arrow_downward_rounded),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        //TODO: функцию обработки нужно передавать сюда параметром
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
