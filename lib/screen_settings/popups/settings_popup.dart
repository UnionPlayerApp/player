import 'package:flutter/material.dart';
import 'package:union_player_app/common/enums/string_keys.dart';
import 'package:union_player_app/common/widgets/common_dialog.dart';
import 'package:union_player_app/common/widgets/common_radio_list.dart';

import '../../common/widgets/common_text_button.dart';

abstract class SettingsPopup<T> {
  T currentValue;
  final List<StringKeys> keys;
  final List<T> values;
  final StringKeys titleKey;

  SettingsPopup({
    required this.titleKey,
    required this.currentValue,
    required this.values,
    required this.keys,
  });

  Future<T?> show(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (context) => CommonDialog(
        context,
        titleKey: titleKey,
        content: _content(context),
        actions: [
          CommonTextButton(
            context,
            onPressed: () => Navigator.of(context).pop(currentValue),
            textKey: StringKeys.buttonOk,
          ),
          CommonTextButton(
            context,
            onPressed: () => Navigator.of(context).pop(),
            textKey: StringKeys.buttonCancel,
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          return CommonRadioList<T>(
            keys: keys,
            values: values,
            groupValue: currentValue,
            onChanged: (value) => _onChanged(value, setState),
          );
        },
      );

  void _onChanged(T? value, StateSetter setState) {
    setState(() {
      currentValue = value ?? currentValue;
    });
  }
}
