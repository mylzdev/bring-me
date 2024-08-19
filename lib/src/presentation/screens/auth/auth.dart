import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/appbar/custom_header.dart';
import '../../../core/common/widgets/avatar/avatar.dart';
import '../../../core/common/widgets/button/animated_circle_button.dart';
import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../core/utils/validators/validation.dart';
import '../../../data/repository/player_repository/player_avatar_model.dart';
import '../../controllers/player_controller/player_controller.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key, this.isUpdating = false});

  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final controller = PlayerController.instance;
    final tmepController = Get.put(TempController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: TColors.darkContainer,
        body: Column(
          children: [
            TCustomHeader(
              title: isUpdating ? 'Change Name' : 'Your Name',
              subTitle: 'Make it unique',
            ),
            TAvatar(
              avatar: PlayerAvatarModel.avatars[controller.avatarIndex.value],
              height: 100,
              width: 100,
              margin: EdgeInsets.zero,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Form(
                key: controller.usernameFormKey,
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .apply(letterSpacingDelta: 2),
                  controller: isUpdating
                      ? tmepController.tempUsernameController
                      : controller.usernameController,
                  validator: (value) => !isUpdating
                      ? TValidator.validateNickname('Username', value)
                      : TValidator.validateUpdateUsername(
                          'Username',
                          value,
                          controller.playername,
                        ),
                  decoration: const InputDecoration(
                    hintText: 'Type here',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColors.darkGrey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColors.primary),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColors.darkGrey),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColors.error),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColors.error),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: TColors.darkGrey),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            TAnimatedCircleButton(
              controller: tmepController,
              onTap: () {
                tmepController.isButtonTapped();
                if (isUpdating) {
                  tmepController.updateName();
                } else {
                  controller.createPlayer();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
