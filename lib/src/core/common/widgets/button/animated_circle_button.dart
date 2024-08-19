import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/config/colors.dart';
import '../../../../presentation/controllers/player_controller/player_controller.dart';
import '../../../utils/logging/logger.dart';

class TAnimatedCircleButton extends StatelessWidget {
  const TAnimatedCircleButton({
    super.key,
    required this.controller,
    required this.onTap,
    this.icon,
  });

  final VoidCallback onTap;
  final IconData? icon;
  final TempController controller;

  @override
  Widget build(BuildContext context) {
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

class TempController extends GetxController {
  static TempController get instance => Get.find();

  final _playerController = PlayerController.instance;
  final isTap = false.obs;
  final tempAvatarIndex = 0.obs;
  final tempUsernameController = TextEditingController();

  @override
  void onInit() {
    tempAvatarIndex.value = _playerController.avatarIndex.value;
    tempUsernameController.text = _playerController.playername;
    super.onInit();
  }

  void isButtonTapped() => isTap.value = !isTap.value;

  Future<void> updateAvatar() async {
    try {
      await _playerController.updatePlayerAvatar(tempAvatarIndex.value);
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }
  
  Future<void> updateName() async {
    try {
      await _playerController.updatePlayerName(tempUsernameController.text);
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }
}
