import 'package:bring_me/src/core/common/widgets/button/elevated_gradient_button.dart';
import 'package:bring_me/src/core/common/widgets/button/outline_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../controllers/home_controller/home_controller.dart';
import 'home_bottom_sheet.dart';

class THomeMultiplayerBottomSheet {
  static void show(HomeController controller) {
    Get.bottomSheet(
      enableDrag: false,
      backgroundColor: TColors.dark,
      Container(
        height: ScreenUtil.defaultSize.height * 0.28,
        width: double.maxFinite,
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            TOutlineGradientButton(
              text: 'Join Room',
              onPressed: () => THomeBottomSheet.show(
                controller: controller,
                title: 'Join Room',
                contentVisible: false,
                onPressed: () => controller.joinRoom(),
              ),
            ),
            SizedBox(height: TSizes.spaceBtwItems),
            SizedBox(
              width: double.maxFinite,
              child: TGradientElevatedButton(
                text: 'Create Room',
                onPressed: () {
                  controller.isSinglePlayer.value = false;
                  THomeBottomSheet.show(
                    controller: controller,
                    title: 'Create Room',
                    maxPlayerVisible: true,
                    onPressed: controller.createRoom,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
