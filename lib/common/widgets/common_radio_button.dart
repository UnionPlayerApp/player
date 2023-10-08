import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final size = 20.r;
    return InkWell(
      child: Row(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Radio<T>(
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: value,
              groupValue: groupValue,
              onChanged: null,
            ),
          ),
          SizedBox(width: 20.w),
          Text(text, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      onTap: () => onChanged(value),
    );
  }
}
