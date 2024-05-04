import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:union_player_app/common/constants/constants.dart';
import 'package:union_player_app/common/core/extensions.dart';

import '../ui/app_colors.dart';
import '../ui/font_sizes.dart';

class ProgressPage extends StatelessWidget {
  final String _version;

  const ProgressPage({required String version}) : _version = version;

  @override
  Widget build(BuildContext context) {
    final circleSize = 200.r;
    final imageSize = 150.r;
    final imageColor = Theme.of(context).brightness.isLight ? null : AppColors.cultured;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: circleSize,
              height: circleSize,
              child: CircularProgressIndicator(
                strokeWidth: 6.r,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          Center(child: Image.asset(logoImage, width: imageSize, height: imageSize, color: imageColor)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("FontSize.px15 => ${FontSizes.px15}"),
                  Text("FontSize.px16 => ${FontSizes.px16}"),
                  Text("FontSize.px20 => ${FontSizes.px20}"),
                  Text("FontSize.px22 => ${FontSizes.px22}"),
                  Text("_version => \"$_version\""),
                  Text("style, color    => ${Theme.of(context).textTheme.titleSmall?.color}"),
                  Text("style, fontSize => ${Theme.of(context).textTheme.titleSmall?.fontSize}"),
                  Text(_version, style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
