import 'package:flutter/cupertino.dart';
import 'package:union_player_app/utils/widgets/common_radio_button.dart';

class CommonRadioList<T> extends StatelessWidget {
  final List<String> texts;
  final List<T> values;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  const CommonRadioList({
    required this.texts,
    required this.values,
    required this.groupValue,
    required this.onChanged,
  })  : assert(texts.length == values.length, "Texts and Values have different lengths"),
        super();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<CommonRadioButton<T>>.generate(
        texts.length,
        (index) => CommonRadioButton(
          text: texts[index],
          value: values[index],
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
