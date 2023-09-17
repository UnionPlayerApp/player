import 'package:flutter/material.dart';

class CommonDialog extends AlertDialog {
  CommonDialog(
    BuildContext context, {
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) : super(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          insetPadding: const EdgeInsets.all(16.0),
          title: Text(title),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: content,
          ),
          actions: actions,
          titlePadding: const EdgeInsets.all(20.0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          actionsPadding: const EdgeInsets.all(20.0),
        );
}
