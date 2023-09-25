import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'font_sizes.dart';

class TextStyles {
  static const white22w400 = TextStyle(
    color: AppColors.white,
    fontFamily: 'Open Sans',
    fontSize: FontSizes.px22,
    fontWeight: FontWeight.w400,
  );

  static const screenTitle20px = TextStyle(
    color: AppColors.blackOlive,
    fontFamily: 'Open Sans',
    fontSize: FontSizes.px20,
    fontWeight: FontWeight.w700,
  );

  static const screenTitle16px = TextStyle(
    color: AppColors.blackOlive,
    fontFamily: 'Open Sans',
    fontSize: FontSizes.px16,
    fontWeight: FontWeight.w700,
  );

  static const screenContent = TextStyle(
    color: AppColors.blackOlive,
    fontFamily: 'Open Sans',
    fontSize: FontSizes.px16,
    fontWeight: FontWeight.w400,
  );

  static const popupContent = TextStyle(
    color: AppColors.darkLiver,
    fontFamily: "Roboto",
    fontSize: FontSizes.px16,
    fontWeight: FontWeight.w400,
  );

  static const popupButton = TextStyle(
    color: AppColors.darkLiver,
    fontFamily: "Roboto",
    fontSize: FontSizes.px16,
    fontWeight: FontWeight.w500,
  );

  static const popupTitle = TextStyle(
    color: AppColors.darkLiver,
    fontFamily: "Roboto",
    fontSize: FontSizes.px16,
    fontWeight: FontWeight.w700,
  );
}
