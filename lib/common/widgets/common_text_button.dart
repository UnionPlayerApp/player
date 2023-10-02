import 'package:flutter/material.dart';
import 'package:union_player_app/common/enums/string_keys.dart';

import '../localizations/string_translation.dart';

class CommonTextButton extends TextButton {
  CommonTextButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required StringKeys textKey,
  }) : super(
          onPressed: onPressed,
          child: Text(translate(textKey, context), style: Theme.of(context).textTheme.bodySmall),
        );
}
