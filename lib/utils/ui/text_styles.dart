import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'font_sizes.dart';

class TextStyles {
  static const _regular = FontWeight.w400;
  static const _bold = FontWeight.w700;

  static final regular16BlackOlive = GoogleFonts.openSans(
    color: AppColors.blackOlive,
    fontSize: FontSizes.px16,
    fontWeight: _regular,
  );

  static final regular16White = GoogleFonts.openSans(
    color: AppColors.white,
    fontSize: FontSizes.px16,
    fontWeight: _regular,
  );

  static final regular22White = GoogleFonts.openSans(
    color: AppColors.white,
    fontSize: FontSizes.px22,
    fontWeight: _regular,
  );

  static final bold16BlackOlive = GoogleFonts.openSans(
    color: AppColors.blackOlive,
    fontSize: FontSizes.px16,
    fontWeight: _bold,
  );

  static final bold20BlackOlive = GoogleFonts.openSans(
    color: AppColors.blackOlive,
    fontSize: FontSizes.px20,
    fontWeight: _bold,
  );
}
