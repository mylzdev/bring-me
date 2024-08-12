import 'package:bring_me/src/core/common/widgets/avatar/avatar.dart';
import 'package:bring_me/src/presentation/controllers/home_controller/home_binding.dart';
import 'package:bring_me/src/presentation/controllers/player_controller/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../core/config/sizes.dart';
import '../../controllers/home_controller/home_controller.dart';
import 'widget/home_footer.dart';
import 'widget/home_player_buttons.dart';
import 'widget/home_player_score.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBinding().dependencies();
    final playerController = PlayerController.instance;
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height),
          child: Padding(
            padding: EdgeInsets.all(TSizes.spaceBtwSections),
            child: Column(
              children: [
                SizedBox(height: TSizes.spaceBtwSections),
                // Avatar
                Obx(
                  () => TAvatar(
                    avatar: playerController.playerAvatar,
                    height: 120.h,
                    width: 120.w,
                    name: playerController.playername,
                    shouldGlow: true,
                    isSelected: true,
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .apply(letterSpacingDelta: 1.5),
                  ),
                ),
                SizedBox(height: TSizes.spaceBtwSections),
                // Player scores
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Tooltip(
                        message: 'Single-Player HighScore',
                        child: THomePlayerScore(
                          icon: Icons.person,
                          score: playerController
                              .playerInfo.value.singleGameScore
                              .toString(),
                        ),
                      ),
                      Tooltip(
                        message: 'Multi-Player HighScore',
                        child: THomePlayerScore(
                          icon: Ionicons.people_sharp,
                          score: playerController
                              .playerInfo.value.multiGameScore
                              .toString(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Play buttons
                THomePlayButtons(controller: controller),
                const Spacer(),
                THomeFooter(controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
