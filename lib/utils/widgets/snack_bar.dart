import 'package:flutter/material.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';

const Duration _snackBarDefaultDuration = Duration(seconds: 2);

void showSnackBar(BuildContext context, StringKeys stringKey, {Duration duration = _snackBarDefaultDuration}) {
  final content = Row(children: [
    const Icon(
      Icons.info_rounded,
      color: colorOnPrimary,
    ),
    const SizedBox(width: 6.0),
    Text(translate(stringKey, context)),
  ]);
  final snackBar = SnackBar(
    content: content,
    backgroundColor: primaryColor,
    duration: duration,
    padding: const EdgeInsets.all(8.0),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
