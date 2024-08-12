import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../config/colors.dart';
import '../../../config/sizes.dart';
import '../button/elevated_gradient_button.dart';
import '../button/outline_gradient_button.dart';

class CustomDialog {
  static void show({
    VoidCallback? onRetry,
    VoidCallback? onContinue,
    required String title,
    String subtitle = '',
    required String lottie,
    bool dismissable = false,
    bool hideActionButtons = true,
    Color? lottieBackgroundColor,
    double? lottieSize,
  }) {
    Get.defaultDialog(
      barrierDismissible: dismissable,
      backgroundColor: TColors.darkContainer,
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      onWillPop: () async => dismissable,
      content: Column(
        children: [
          Container(
            padding: EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              color: lottieBackgroundColor ?? TColors.primary,
              borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
            ),
            child: Lottie.asset(lottie, height: lottieSize),
          ),
          SizedBox(height: TSizes.spaceBtwItems),
          Text(
            title,
            style: Get.textTheme.titleLarge,
          ),
          SizedBox(height: TSizes.spaceBtwItems / 2),
          Visibility(
            visible: subtitle != '',
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
          ),
          Visibility(
            visible: hideActionButtons,
            child: Column(
              children: [
                SizedBox(height: TSizes.spaceBtwItems / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: TOutlineGradientButton(
                        text: 'Retry',
                        onPressed: onRetry,
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: TGradientElevatedButton(
                        text: 'Continue',
                        onPressed: onContinue,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void showOnLeaveDialog({
    VoidCallback? onLeavePressed,
    required String title,
    required String subtitle,
  }) async {
    await Get.defaultDialog(
      title: title,
      middleText: subtitle,
      contentPadding: EdgeInsets.all(TSizes.defaultSpace),
      titlePadding: EdgeInsets.only(top: TSizes.defaultSpace),
      confirm: ElevatedButton(
        onPressed: onLeavePressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: TColors.error,
            padding: EdgeInsets.zero,
            side: BorderSide.none),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: const Text('Leave'),
        ),
      ),
      // Cancel button
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  static void close() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
