import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';

import '../enums/string_keys.dart';

const Duration _snackBarDefaultDuration = Duration(seconds: 2);

void showSnackBar(
  BuildContext context, {
  StringKeys? messageKey,
  String? messageText,
  Duration duration = _snackBarDefaultDuration,
}) {
  final text = messageKey != null ? translate(messageKey, context) : messageText;

  if (text == null) {
    return;
  }

  final content = Row(children: [
    const Icon(Icons.info_rounded),
    SizedBox(width: 6.w),
    Flexible(
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ]);

  final snackBar = SnackBar(
    content: content,
    duration: duration,
    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
