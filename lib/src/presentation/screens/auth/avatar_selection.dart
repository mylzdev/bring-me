import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/appbar/custom_header.dart';
import '../../../core/common/widgets/avatar/avatar.dart';
import '../../../core/common/widgets/button/animated_circle_button.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../data/repository/player_repository/player_avatar_model.dart';
import '../../controllers/player_controller/player_controller.dart';
import 'auth.dart';

class AvatarSelection extends StatelessWidget {
  const AvatarSelection({super.key, this.isUpdating = false});

  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final controller = PlayerController.instance;
    final avatars = PlayerAvatarModel.avatars;
    return SafeArea(
      child: Scaffold(
        backgroundColor: TColors.darkContainer,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            GridView.builder(
              padding: EdgeInsets.fromLTRB(
                TSizes.md,
                175.h,
                TSizes.md,
                100.h,
              ),
              itemCount: avatars.length,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (_, index) => GestureDetector(
                onTap: () => controller.avatarIndex.value = index,
                child: Obx(
                  () => TAvatar(
                    avatar: avatars[index],
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.all(TSizes.sm * 2),
                    isSelected: controller.avatarIndex.value == index,
                    borderColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            const TCustomHeader(
              title: 'Your Avatar',
              subTitle: 'Pick your favorite one',
            ),
            Positioned(
              bottom: 0,
              child: TAnimatedCircleButton(
                onTap: () {
                  TCircleButtonController.instance.isButtonTapped();
                  if (isUpdating) {
                    controller.updatePlayerAvatar();
                  } else {
                    Get.to(
                      () => const AuthenticationScreen(),
                      transition: Transition.rightToLeft,
                      fullscreenDialog: true,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
