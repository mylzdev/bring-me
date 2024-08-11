import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../config/colors.dart';
import '../../../config/lottie.dart';
import '../../../config/sizes.dart';
import '../../shapes/custom_shape.dart';

class TCustomHeader extends StatelessWidget {
  const TCustomHeader({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TCustomCurvedShapes(),
      child: Container(
        color: TColors.dark,
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              LottieAsset.gemini,
              height: 60.h,
              width: 60.w,
            ),
            SizedBox(height: TSizes.spaceBtwItems),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: TSizes.sm),
            Text(
              subTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .apply(color: TColors.darkGrey),
            ),
            SizedBox(height: TSizes.spaceBtwSections * 1.5),
          ],
        ),
      ),
    );
  }
}
