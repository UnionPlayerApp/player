import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:union_player_app/common/enums/string_keys.dart';

import '../localizations/string_translation.dart';

class CommonDialog extends AlertDialog {
  CommonDialog(
    BuildContext context, {
    required StringKeys titleKey,
    required Widget content,
    required List<Widget> actions,
  }) : super(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.r)),
          ),
          insetPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          title: Text(translate(titleKey, context), style: Theme.of(context).textTheme.titleSmall),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: content,
          ),
          actions: actions,
          titlePadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
          actionsPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        );
}
