import 'package:flutter/material.dart';

class CommonRadioButton<T> extends StatelessWidget {
  final String text;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  const CommonRadioButton({
    required this.text,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20.0,
          height: 20.0,
          child: Radio<T>(
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 20.0),
        Text(text),
      ],
    );
  }
}
