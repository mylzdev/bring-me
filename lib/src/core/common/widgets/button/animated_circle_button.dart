import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/config/colors.dart';

class TAnimatedCircleButton extends StatelessWidget {
  const TAnimatedCircleButton({
    super.key,
    required this.onTap,
    this.icon,
  });

  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TCircleButtonController());
    return GestureDetector(
      onTapDown: (_) => controller.isButtonTapped(),
      onTap: onTap,
      onTapCancel: () => controller.isButtonTapped(),
      child: Obx(
        () => AnimatedContainer(
          height: 90.h,
          duration: Durations.short4,
          padding: EdgeInsets.all(
            controller.isTap.value ? 5.h : 18.h,
          ),
          decoration: const BoxDecoration(
            color: TColors.secondary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon ?? Ionicons.arrow_forward,
            size: 30.h,
          ),
        ),
      ),
    );
  }
}

class TCircleButtonController extends GetxController {
  static TCircleButtonController get instance => Get.find();
  final isTap = false.obs;

  void isButtonTapped() => isTap.value = !isTap.value;
}
