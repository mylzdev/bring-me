import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/text/gradient_text.dart';
import '../../../../core/config/enums.dart';
import '../../../../core/config/sizes.dart';
import '../../../controllers/single_game_controller/single_game_controller.dart';
import 'single_game_loader.dart';

class TGameProgress extends StatelessWidget {
  const TGameProgress({
    super.key,
    required this.gameController,
  });

  final SingleGameController gameController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          switch (gameController.itemHuntStatus.value) {
            ItemHuntStatus.initial => Container(
                padding: EdgeInsets.all(TSizes.md),
                width: double.maxFinite,
                child: Center(
                  child: TGradientText(
                    gameController.currentitem,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(letterSpacingDelta: 2.sp),
                  ),
                ),
              ),
            ItemHuntStatus.validationInProgress =>
              const TGameLoader(title: 'Validating Image'),
            ItemHuntStatus.validationFailure => const Column(
                children: [
                  Text('Failed'),
                ],
              ),
            ItemHuntStatus.validationSuccess => const Column(
                children: [
                  Text('Success'),
                ],
              ),
          },
        ],
      ),
    );
  }
}
