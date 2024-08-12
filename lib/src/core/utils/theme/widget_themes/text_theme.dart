import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/colors.dart';

/// Custom Class for Light & Dark Text Themes
class TTextTheme {
  TTextTheme._(); // To avoid creating instances

  /// Customizable Dark Text Theme
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.playfair().copyWith(fontSize: 54.0.sp, fontWeight: FontWeight.normal, color: TColors.light),
    displayMedium: GoogleFonts.playfair().copyWith(fontSize: 48.0.sp, fontWeight: FontWeight.normal, color: TColors.light),
    displaySmall: GoogleFonts.playfair().copyWith(fontSize: 40.0.sp, fontWeight: FontWeight.normal, color: TColors.light),

    headlineLarge: GoogleFonts.poppins().copyWith(fontSize: 32.0.sp, fontWeight: FontWeight.bold, color: TColors.light),
    headlineMedium: GoogleFonts.poppins().copyWith(fontSize: 24.0.sp, fontWeight: FontWeight.bold, color: TColors.light),
    headlineSmall: GoogleFonts.poppins().copyWith(fontSize: 18.0.sp, fontWeight: FontWeight.normal, color: TColors.light),

    titleLarge: GoogleFonts.poppins().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w600, color: TColors.light),
    titleMedium: GoogleFonts.poppins().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w500, color: TColors.light),
    titleSmall: GoogleFonts.poppins().copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.w400, color: TColors.light),

    bodyLarge: GoogleFonts.poppins().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: TColors.light),
    bodyMedium: GoogleFonts.poppins().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.normal, color: TColors.light),
    bodySmall: GoogleFonts.poppins().copyWith(fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: TColors.light.withOpacity(0.5)),

    labelLarge: GoogleFonts.poppins().copyWith(fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: TColors.light),
    labelMedium: GoogleFonts.poppins().copyWith(fontSize: 12.0.sp, fontWeight: FontWeight.normal, color: TColors.light.withOpacity(0.5)),
  );
}
