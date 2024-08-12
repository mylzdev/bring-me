import 'package:bring_me/src/core/common/widgets/appbar/appbar.dart';
import 'package:bring_me/src/core/common/widgets/container/custom_container.dart';
import 'package:bring_me/src/core/config/colors.dart';
import 'package:bring_me/src/core/config/enums.dart';
import 'package:bring_me/src/core/config/lottie.dart';
import 'package:bring_me/src/core/config/sizes.dart';
import 'package:bring_me/src/core/utils/helpers/helper_functions.dart';
import 'package:bring_me/src/presentation/controllers/room_controller/room_controller.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'widgets/multi_game_footer.dart';
import 'widgets/multi_game_header.dart';
import 'widgets/placing_badge.dart';

class MultiGameScreen extends GetView<RoomController> {
  const MultiGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => controller.onLeaveRoom(),
      child: Scaffold(
        appBar: TAppbar(
          title: Obx(
            () => Visibility(
              visible: controller.roomInfo.value.gameState == GameState.ended,
              replacement: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    THelperFunctions.convertMinutesToTimeFormat(
                      controller.timeLeft.value,
                    ),
                  ),
                  SizedBox(width: TSizes.xs),
                  Lottie.asset(
                    LottieAsset.clock,
                    height: 40.h,
                    width: 40.w,
                  )
                ],
              ),
              child: const Text('TIME IS UP!'),
            ),
          ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Placing',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Obx(
                        () => Visibility(
                          visible: controller.isFinish.value &&
                              controller.roomInfo.value.gameState !=
                                  GameState.ended,
                          child: AnimatedOpacity(
                            duration: 1.seconds,
                            opacity: controller.waitingForOthersOpacity.value,
                            child: Text(
                              'Waiting for others...',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TSizes.xs),
                  Obx(() {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.sortedPlayer.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          key: ValueKey("player_$index"),
                          width: double.maxFinite,
                          child: Stack(
                            children: [
                              TCustomContainer(
                                borderColor:
                                    controller.sortedPlayer[index].name ==
                                            controller.playerName
                                        ? TColors.secondary
                                        : TColors.primary,
                                margin:
                                    EdgeInsets.symmetric(vertical: TSizes.sm),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.sortedPlayer[index].name,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          RatingBar.readOnly(
                                            size: TSizes.iconMd,
                                            filledIcon: Icons.circle,
                                            emptyIcon: Icons.circle_outlined,
                                            initialRating: controller
                                                .sortedPlayer[index].itemLeft
                                                .toDouble(),
                                            filledColor: TColors.primary,
                                            emptyColor: TColors.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: TSizes.spaceBtwItems),
                                    Text(
                                      '${controller.sortedPlayer[index].score}',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    )
                                  ],
                                ),
                              ),
                              TPlacingBadge(
                                sortedPlayers: controller.sortedPlayer,
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
          () => Visibility(
            visible: controller.roomInfo.value.gameState == GameState.ended
                ? true
                : controller.hideFooterButtons,
            child: TMultiGameFooter(controller: controller),
          ),
        ),
      ),
    );
  }
}
