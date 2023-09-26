import 'package:flutter/material.dart';
import 'package:union_player_app/utils/enums/string_keys.dart';

import '../localizations/string_translation.dart';
import '../ui/text_styles.dart';

class CommonTextButton extends TextButton {
  CommonTextButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required StringKeys textKey,
  }) : super(
          onPressed: onPressed,
          child: Text(translate(textKey, context), style: TextStyles.popupButton),
        );
}
