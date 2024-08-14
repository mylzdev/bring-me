import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../config/lottie.dart';
import '../../config/sizes.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, {bool canPop = false}) {
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.black87,
      context: Get.overlayContext!,
      builder: (_) => PopScope(
        canPop: canPop,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  LottieAsset.gemini,
                  height: TSizes.iconLg * 2,
                  width: TSizes.iconLg * 2,
                ),
                SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  '$text...',
                  style: Theme.of(Get.context!).textTheme.titleLarge!.apply(letterSpacingDelta: 1.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
