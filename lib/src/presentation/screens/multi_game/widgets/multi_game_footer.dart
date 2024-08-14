import 'package:flutter/material.dart';

import '../../../../core/common/widgets/button/elevated_gradient_button.dart';
import '../../../../core/config/enums.dart';
import '../../../../core/config/sizes.dart';
import '../../../controllers/room_controller/room_controller.dart';

class TMultiGameFooter extends StatelessWidget {
  const TMultiGameFooter({
    super.key,
    required this.controller,
  });

  final RoomController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child: Visibility(
        visible: controller.roomInfo.value.gameState == GameState.progress,
        replacement: TGradientElevatedButton(
          onPressed: () => controller.quitRoom(),
          text: 'Continue',
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => controller.skipItem(),
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: TSizes.md)),
              child: const Text('Skip'),
            ),
            SizedBox(width: TSizes.spaceBtwItems),
            ElevatedButton(
              onPressed: () => controller.validateImage(),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: TSizes.md)),
              child: const Text('Take Photo'),
            )
          ],
        ),
      ),
    );
  }
}
