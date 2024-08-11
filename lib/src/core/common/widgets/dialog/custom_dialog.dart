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
  }) {
    Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: TColors.darkContainer,
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      onWillPop: () async => false,
      content: Column(
        children: [
          Container(
            padding: EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              color: TColors.primary,
              borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
            ),
            child: Lottie.asset(lottie),
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
    );
  }

  static void close() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
