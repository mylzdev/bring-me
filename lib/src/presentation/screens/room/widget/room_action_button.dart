import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../controllers/room_controller/room_controller.dart';

class TRoomActionButton extends StatelessWidget {
  const TRoomActionButton({
    super.key,
    required this.controller,
  });

  final RoomController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => controller.onPlayReadyTapped(),
      onTap: () => controller.isRoomLeader
          ? controller.startGame()
          : controller.setReady(),
      onTapCancel: controller.onPlayReadyTapped,
      child: Obx(
        () => AnimatedContainer(
          height: 90.h,
          duration: Durations.short4,
          padding: EdgeInsets.all(
            controller.isPlayReadyTapped.value ? TSizes.sm : 20.h,
          ),
          decoration: const BoxDecoration(
              color: TColors.secondary, shape: BoxShape.circle),
          child: Icon(
            controller.isRoomLeader ? Ionicons.play : Ionicons.checkmark,
            size: 30.h,
          ),
        ),
      ),
    );
  }
}
