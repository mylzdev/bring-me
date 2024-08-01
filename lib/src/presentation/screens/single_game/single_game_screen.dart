import 'package:bring_me/src/core/common/widgets/text/gradient_text.dart';
import 'package:bring_me/src/core/utils/helpers/helper_functions.dart';
import 'package:bring_me/src/presentation/controllers/single_game_controller/single_game_binding.dart';
import 'package:bring_me/src/presentation/controllers/single_game_controller/single_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/appbar/appbar.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/enums.dart';
import '../../../core/config/sizes.dart';
import 'widget/game_footer.dart';
import 'widget/game_loader.dart';

class GameScreen extends GetView<SingleGameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SingleGameBinding().dependencies();
    return Scaffold(
      appBar: TAppbar(
        title: Obx(
          () => Text(
            THelperFunctions.getHuntLocation(controller.huntLocation.value),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(TSizes.sm),
            decoration: BoxDecoration(
                color: TColors.darkContainer,
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd)),
            child: Row(
              children: [
                Obx(
                  () => Text('Score: ${controller.score.value}',
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Obx(
          () => Column(
            children: [
              Visibility(
                visible: controller.gameState.value == GameState.progress,
                child: Text('Items left: ${controller.itemLeft.value}'),
              ),
              const Spacer(),
              switch (controller.gameState.value) {
                GameState.initial =>
                  const TGameLoader(title: 'Generating Items...'),
                GameState.progress => TGameProgress(gameController: controller),
                GameState.ended => const SizedBox()
              },
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TSingleGameFooter(controller: controller),
    );
  }
}

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
