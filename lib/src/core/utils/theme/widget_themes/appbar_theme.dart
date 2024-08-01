import 'package:flutter/material.dart';

import '../../../config/colors.dart';
import '../../../config/sizes.dart';

class TAppBarTheme{
  TAppBarTheme._();

  static final darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: TColors.black, size: TSizes.iconMd),
    actionsIconTheme: IconThemeData(color: TColors.white, size: TSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: TSizes.fontSizeLg, fontWeight: FontWeight.w600, color: TColors.white),
  );
}