import 'package:flutter/material.dart';

import '../../../config/colors.dart';
import '../../../config/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class TOutlinedButtonTheme {
  TOutlinedButtonTheme._(); //To avoid creating instances

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: TColors.light,
      side: const BorderSide(color: TColors.primary),
      textStyle: const TextStyle(color: TColors.textWhite, fontWeight: FontWeight.w600),
      padding: EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.buttonRadius)),
    ),
  );
}
