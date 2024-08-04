import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/common/widgets/text/gradient_text.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/lottie.dart';
import '../../../../core/config/sizes.dart';

class TMultiGameHeaderContent extends StatelessWidget {
  const TMultiGameHeaderContent({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.shouldUseLottie = false,
    this.isCheck = true,
  });

  final String title;
  final String subtitle;
  final bool shouldUseLottie;
  final bool isCheck;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !shouldUseLottie,
      replacement: OverflowBox(
        maxHeight: 180.h,
        child: Lottie.asset(
          height: double.maxFinite,
          isCheck ? LottieAsset.check : LottieAsset.error,
          fit: BoxFit.contain,
          repeat: false,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: title != '',
            child: Column(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: TColors.white.withOpacity(0.8),
                      ),
                ),
                SizedBox(height: TSizes.xs),
              ],
            ),
          ),
          TGradientText(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .apply(letterSpacingDelta: 2.sp),
          )
        ],
      ),
    );
  }
}
