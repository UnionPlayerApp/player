import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:union_player_app/common/core/extensions.dart';

import '../constants/constants.dart';
import '../ui/app_colors.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoSize = 125.r;
    final isBrightnessLight = Theme.of(context).brightness.isLight;
    final diskName = isBrightnessLight ? AppImages.imDisk3 : AppImages.imDiskDark3;
    final logoColor = isBrightnessLight ? null : AppColors.cultured;
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(AppImages.imRadioLogo, width: logoSize, height: logoSize, color: logoColor),
        Image.asset(diskName, scale: ScreenUtil().scale),
      ],
    );
  }
}
