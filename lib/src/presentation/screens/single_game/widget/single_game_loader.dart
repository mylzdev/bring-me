import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/config/lottie.dart';
import '../../../../core/config/sizes.dart';

class TGameLoader extends StatelessWidget {
  const TGameLoader({
    super.key,
    this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(LottieAsset.gemini, height: TSizes.iconLg * 2),
        SizedBox(height: TSizes.md),
        title != null
            ? Text(
                title!,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .apply(letterSpacingDelta: 1.sp),
              )
            : const SizedBox(),
      ],
    );
  }
}
