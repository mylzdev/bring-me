import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/colors.dart';
import '../../../config/sizes.dart';

class TTooltipTheme {
  TTooltipTheme._();

  static TooltipThemeData darkTooltipTheme = TooltipThemeData(
    textStyle: GoogleFonts.poppins().copyWith(
      fontSize: 12.0.sp,
      fontWeight: FontWeight.normal,
      color: TColors.light,
    ),
    decoration: BoxDecoration(
      color: TColors.darkContainer,
      borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
    ),
  );
}
