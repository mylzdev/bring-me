import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/common/widgets/container/custom_container.dart';
import '../../../../core/config/enums.dart';
import '../../../../core/config/lottie.dart';
import '../../../controllers/room_controller/room_controller.dart';
import 'multi_game_header_content.dart';

class TMultiGameHeader extends StatelessWidget {
  const TMultiGameHeader({
    super.key,
    required this.controller,
  });

  final RoomController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TCustomContainer(
        height: 105,
        padding: EdgeInsets.zero,
        width: double.maxFinite,
        child: !controller.isFinish.value ||
                controller.roomInfo.value.gameState == GameState.ended
            ? switch (controller.roomInfo.value.gameState) {
                GameState.initial => const SizedBox(),
                GameState.progress =>
                  TMultiGameProgress(controller: controller),
                GameState.ended => TMultiGameEnded(
                    // Multi Game State Ends
                    subtitle: controller.roomInfo.value.winnerName ?? 'Draw',
                    title: controller.roomInfo.value.winnerName != null ? 'Winner' : null,
                    shouldPlayPopper: controller.roomInfo.value.winnerName != null,
                  ),
              }
            : TMultiGameEnded(
                // Local Game State Ends
                subtitle: controller.score.value.toString(),
                title: 'Total Score:',
              ),
      ),
    );
  }
}

class TMultiGameEnded extends StatelessWidget {
  const TMultiGameEnded({
    super.key,
    this.title,
    this.subtitle,
    this.shouldPlayPopper = false,
  });

  final String? title;
  final String? subtitle;
  final bool shouldPlayPopper;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        TMultiGameHeaderContent(
          title: title,
          subtitle: subtitle,
        ),
        OverflowBox(
          maxHeight: 200,
          maxWidth: 200,
          child: Lottie.asset(
            LottieAsset.confetti,
            repeat: false,
          ),
        ),
        Positioned(
          left: 0,
          child: Visibility(
            visible: shouldPlayPopper,
            child: Lottie.asset(
              height: 130.h,
              width: 130.w,
              LottieAsset.popper,
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Transform.flip(
            flipX: true,
            child: Visibility(
              visible: shouldPlayPopper,
              child: Lottie.asset(
                height: 130.h,
                width: 130.w,
                LottieAsset.popper,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TMultiGameProgress extends StatelessWidget {
  const TMultiGameProgress({
    super.key,
    required this.controller,
  });

  final RoomController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => switch (controller.itemHuntStatus.value) {
        ItemHuntStatus.initial => TMultiGameHeaderContent(
            title: 'Bring Me',
            subtitle: controller.currentitem,
          ),
        ItemHuntStatus.validationInProgress =>
          const TMultiGameHeaderContent(subtitle: 'Validating'),
        ItemHuntStatus.validationFailure =>
          const TMultiGameHeaderContent(shouldUseLottie: true, isCheck: false),
        ItemHuntStatus.validationSuccess =>
          const TMultiGameHeaderContent(shouldUseLottie: true),
      },
    );
  }
}
