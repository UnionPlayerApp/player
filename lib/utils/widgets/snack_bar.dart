import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';

const Duration _snackBarDefaultDuration = Duration(seconds: 2);

void showSnackBar(BuildContext context, String msg,
    {Duration duration = _snackBarDefaultDuration}) {
  final content = Row(children: [
    const Icon(
      Icons.info_rounded,
      color: colorOnPrimary,
    ),
    Container(
      child: Text(msg),
      margin: EdgeInsets.only(left: 6.0),
    ),
  ]);
  final snackBar = SnackBar(
    content: content,
    backgroundColor: primaryColor,
    duration: duration,
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
