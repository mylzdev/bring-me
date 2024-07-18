import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';
import '../helpers/helper_functions.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, {bool canPop = false}) {
    showDialog(
      useSafeArea: false,
      barrierColor: THelperFunctions.isDarkMode(Get.context!)
          ? TColors.dark.withOpacity(0.5)
          : TColors.light.withOpacity(0.5),
      context: Get.overlayContext!, // overlay settings
      builder: (_) => PopScope(
        canPop: canPop,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator.adaptive(),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text(
                  text,
                  style: Theme.of(Get.context!).textTheme.titleLarge,
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
