import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/common/widgets/avatar/avatar.dart';
import '../../../../core/common/widgets/container/custom_container.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../controllers/player_controller/player_controller.dart';
import '../../../controllers/room_controller/room_controller.dart';

class RoomQR {
  static void show(RoomController controller) {
    Get.dialog(
      Dialog(
        child: TCustomContainer(
          height: Get.height * 0.5,
          width: Get.width * 0.5,
          padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -70,
                child: TAvatar(
                  height: 100.h,
                  width: 100.h,
                  backgroundColor: const Color(0xff090C15),
                  avatar: PlayerController.instance.playerAvatar,
                ),
              ),
              QrImageView(
                data: controller.roomID,
                version: QrVersions.auto,
                gapless: true,
                eyeStyle: const QrEyeStyle(
                  color: TColors.secondary,
                  eyeShape: QrEyeShape.circle,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                    color: TColors.primary,
                    dataModuleShape: QrDataModuleShape.circle),
              ),
              Positioned(
                bottom: 30.h,
                child: Text(
                  '@${controller.playerName}',
                  style: Get.theme.textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
