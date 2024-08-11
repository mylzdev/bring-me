import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/button/elevated_gradient_button.dart';
import '../../../../core/common/widgets/button/outline_gradient_button.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../controllers/home_controller/home_controller.dart';
import 'home_bottom_sheet.dart';

class THomePlayButtons extends StatelessWidget {
  const THomePlayButtons({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: TOutlineGradientButton(
            text: 'SINGLE GAME',
            onPressed: () {
              THomeBottomSheet.show(
                controller: controller,
                title: 'Single Player',
                onPressed: controller.playSinglePlayer,
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
              controller: controller,
              title: 'Create Room',
              maxPlayerVisible: true,
              onPressed: controller.createRoom,
            ),
          ),
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        SizedBox(
          width: double.maxFinite,
          child: TGradientElevatedButton(
            text: 'JOIN ROOM',
            onPressed: () => THomeBottomSheet.show(
              controller: controller,
              title: 'Join Room',
              contentVisible: false,
              onPressed: () => controller.joinRoom(),
            ),
          ),
        ),
      ],
    );
  }
}
