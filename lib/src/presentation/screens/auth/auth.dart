import 'package:bring_me/src/core/common/widgets/avatar/avatar.dart';
import 'package:bring_me/src/core/common/widgets/button/animated_circle_button.dart';
import 'package:bring_me/src/core/config/colors.dart';
import 'package:bring_me/src/core/config/sizes.dart';
import 'package:bring_me/src/data/repository/player_repository/player_avatar_model.dart';
import 'package:flutter/material.dart';

import '../../../core/common/widgets/appbar/custom_header.dart';
import '../../../core/utils/validators/validation.dart';
import '../../controllers/player_controller/player_controller.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PlayerController.instance;
    return SafeArea(
      child: Scaffold(
        backgroundColor: TColors.darkContainer,
        body: Column(
          children: [
            const TCustomHeader(
              title: 'Your Name',
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
                  controller: controller.usernameController,
                  validator: (value) =>
                      TValidator.validateNickname('Username', value),
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
              onTap: () {
                TCircleButtonController.instance.isButtonTapped();
                PlayerController.instance.createUsername();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// SizedBox(
//               width: double.maxFinite,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Form(
//                       key: controller.usernameFormKey,
//                       child: TextFormField(
//                         controller: controller.usernameController,
//                         validator: (value) =>
//                             TValidator.validateNickname('Username', value),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => controller.refreshUsername(),
//                     icon: Icon(Ionicons.dice_outline, size: TSizes.iconLg),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: TSizes.spaceBtwItems),
//             SizedBox(
//               width: double.maxFinite,
//               child: TGradientElevatedButton(
//                 text: 'Continue',
//                 onPressed: () => controller.createUsername(),
//               ),
//             ),
