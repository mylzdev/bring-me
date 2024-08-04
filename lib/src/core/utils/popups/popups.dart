import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../config/colors.dart';

class TPopup {
  static bool _isSnackbarOpen = false;

  static void customToast(
      {required String message, Duration? duration, Color? backgroundColor}) {
    _isSnackbarOpen = true;
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: duration ?? const Duration(milliseconds: 1500),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: backgroundColor ?? TColors.darkContainer,
          ),
          child: Center(
            child: Text(
              message,
              style: Theme.of(Get.context!).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  static void successSnackbar({required String title, String message = ''}) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: TColors.primary,
      icon: const Icon(Iconsax.check, color: TColors.white),
    );
  }

  static void warningSnackbar({required String title, String message = ''}) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.orange,
      icon: const Icon(Iconsax.warning_2, color: TColors.white),
    );
  }

  static void errorSnackbar({required String title, String message = ''}) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: const Icon(Iconsax.warning_2, color: TColors.white),
    );
  }

  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required Icon icon,
  }) {
    if (_isSnackbarOpen) {
      return;
    }

    _isSnackbarOpen = true;

    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 1500),
      margin: const EdgeInsets.all(10),
      icon: icon,
    ).future.then((_) {
      _isSnackbarOpen = false;
    });
  }
}
