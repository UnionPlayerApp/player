import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:union_player_app/common/enums/string_keys.dart';
import 'package:union_player_app/common/widgets/common_radio_button.dart';

import '../localizations/string_translation.dart';

class CommonRadioList<T> extends StatelessWidget {
  final List<StringKeys> keys;
  final List<T> values;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  const CommonRadioList({
    required this.keys,
    required this.values,
    required this.groupValue,
    required this.onChanged,
  })  : assert(keys.length == values.length, "Keys and Values should have the same length"),
        super();

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    final lastIndex = keys.length - 1;
    for (var index = 0; index < keys.length; index++) {
      children.add(
        CommonRadioButton(
          text: translate(keys[index], context),
          value: values[index],
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      );
      if (index < lastIndex) {
        children.add(SizedBox(height: 20.h));
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
