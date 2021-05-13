import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const Duration _snackBarDefaultDuration = Duration(seconds: 2);

void showSnackBar(BuildContext context, String msg,
    {Duration duration = _snackBarDefaultDuration}) {
  final snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: Colors.blueGrey,
    duration: duration,
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
