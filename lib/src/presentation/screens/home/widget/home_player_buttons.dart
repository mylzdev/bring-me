import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/button/elevated_gradient_button.dart';
import '../../../../core/common/widgets/button/outline_gradient_button.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../controllers/home_controller/home_controller.dart';
import '../../../controllers/qr_scanner_controller/qr_scanner_binding.dart';
import '../../../controllers/qr_scanner_controller/qr_scanner_controller.dart';
import 'home_bottom_sheet.dart';

class THomePlayButtons extends GetView<QrScannerController> {
  const THomePlayButtons({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    QrScannerBinding().dependencies();
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: TOutlineGradientButton(
            text: 'SINGLE GAME',
            onPressed: () {
              THomeBottomSheet.show(
                controller: homeController,
                title: 'Single Player',
                onPressed: () => homeController.askForCameraPermission(
                  callback: () => homeController.playSinglePlayer(),
                ),
              );
            },
          ),
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: Divider(color: TColors.darkGrey)),
            Text('OR', style: Theme.of(context).textTheme.titleLarge)
                .marginSymmetric(horizontal: TSizes.md),
            const Expanded(
              child: Divider(
                color: TColors.darkGrey,
              ),
            ),
          ],
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        SizedBox(
          width: double.maxFinite,
          child: TGradientElevatedButton(
            text: 'CREATE ROOM',
            onPressed: () => THomeBottomSheet.show(
              controller: homeController,
              title: 'Create Room',
              maxPlayerVisible: true,
              onPressed: homeController.createRoom,
            ),
          ),
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        SizedBox(
          width: double.maxFinite,
          child: TGradientElevatedButton(
            text: 'JOIN ROOM',
            onPressed: () {
              THomeBottomSheet.show(
                controller: homeController,
                title: 'Join Room',
                joinTextFieldVisible: false,
                qrVisible: true,
                onPressed: () => homeController.joinRoomViaCode(),
              );
            },
          ),
        ),
      ],
    );
  }
}
