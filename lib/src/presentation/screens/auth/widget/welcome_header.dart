import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/config/lottie.dart';

class TWelcomeHeader extends StatelessWidget {
  const TWelcomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: kToolbarHeight * 2,
          child: Lottie.asset(
            LottieAsset.gemini,
            height: 100.h,
            width: 100.w,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: kToolbarHeight * 1,
          child: Lottie.asset(
            LottieAsset.lines,
            reverse: true,
            height: 230.h,
            width: 230.w,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
