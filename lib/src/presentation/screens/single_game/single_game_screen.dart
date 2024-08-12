import 'package:bring_me/src/core/utils/helpers/helper_functions.dart';
import 'package:bring_me/src/presentation/controllers/single_game_controller/single_game_binding.dart';
import 'package:bring_me/src/presentation/controllers/single_game_controller/single_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/appbar/appbar.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/enums.dart';
import '../../../core/config/sizes.dart';
import 'widget/single_game_footer.dart';
import 'widget/single_game_loader.dart';
import 'widget/single_game_progress.dart';

class GameScreen extends GetView<SingleGameController> {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SingleGameBinding().dependencies();
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => controller.onLeaveGame(),
      child: Scaffold(
        appBar: TAppbar(
          title: Obx(
            () => Text(
              THelperFunctions.getHuntLocation(controller.huntLocation.value),
              style: Theme.of(context).textTheme.headlineSmall,
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
                  child: Text(
                    'Items left: ${controller.itemLeft.value}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Spacer(),
                switch (controller.gameState.value) {
                  GameState.initial =>
                    const TGameLoader(title: 'Generating Items...'),
                  GameState.progress =>
                    TGameProgress(gameController: controller),
                  GameState.ended => const SizedBox()
                },
                const Spacer(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => Visibility(
            visible: controller.hideFooterButtons,
            replacement: const SizedBox(),
            child: TSingleGameFooter(controller: controller),
          ),
        ),
      ),
    );
  }
}
