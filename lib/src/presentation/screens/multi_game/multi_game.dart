import 'package:bring_me/src/core/common/widgets/appbar/appbar.dart';
import 'package:bring_me/src/core/common/widgets/container/custom_container.dart';
import 'package:bring_me/src/core/config/colors.dart';
import 'package:bring_me/src/core/config/enums.dart';
import 'package:bring_me/src/core/config/sizes.dart';
import 'package:bring_me/src/core/utils/helpers/helper_functions.dart';
import 'package:bring_me/src/data/repository/player_repository/player_repository.dart';
import 'package:bring_me/src/presentation/controllers/room_controller/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/multi_game_footer.dart';
import 'widgets/multi_game_header.dart';
import 'widgets/placing_badge.dart';

class MultiGameScreen extends GetView<RoomController> {
  const MultiGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        title: Obx(() => Text(THelperFunctions.convertMinutesToTimeFormat(
            controller.timeLeft.value))),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Center(
            child: Column(
              children: [
                TMultiGameHeader(controller: controller),
                SizedBox(height: TSizes.spaceBtwSections),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Placing',
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                SizedBox(height: TSizes.xs),
                Obx(() {
                  var sortedPlayers = controller.roomInfo.value.players.toList()
                    ..sort((a, b) => b.score.compareTo(a.score));
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedPlayers.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        key: ValueKey("player_$index"),
                        width: double.maxFinite,
                        child: Stack(
                          children: [
                            TCustomContainer(
                              borderColor: sortedPlayers[index].name ==
                                      PlayerRepository.instance.username.value
                                  ? TColors.secondary
                                  : TColors.primary,
                              margin: EdgeInsets.symmetric(vertical: TSizes.sm),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(sortedPlayers[index].name),
                                  Text(
                                    '${sortedPlayers[index].score}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  )
                                ],
                              ),
                            ),
                            TPlacingBadge(
                              sortedPlayers: sortedPlayers,
                              index: index,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => controller.roomInfo.value.gameState == GameState.ended
            ? const SizedBox()
            : TMultiGameFooter(controller: controller),
      ),
    );
  }
}
