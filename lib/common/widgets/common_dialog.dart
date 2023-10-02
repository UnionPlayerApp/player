import 'package:flutter/material.dart';
import 'package:union_player_app/common/enums/string_keys.dart';

import '../localizations/string_translation.dart';

class CommonDialog extends AlertDialog {
  CommonDialog(
    BuildContext context, {
    required StringKeys titleKey,
    required Widget content,
    required List<Widget> actions,
  }) : super(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          insetPadding: const EdgeInsets.all(16.0),
          title: Text(translate(titleKey, context), style: Theme.of(context).textTheme.titleSmall),
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