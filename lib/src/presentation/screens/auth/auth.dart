import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../core/common/widgets/button/elevated_gradient_button.dart';
import '../../../core/config/sizes.dart';
import '../../../core/utils/validators/validation.dart';
import '../../controllers/player_controller/player_controller.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PlayerController.instance;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Username',
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: TSizes.spaceBtwItems),
            SizedBox(
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: controller.usernameFormKey,
                      child: TextFormField(
                        controller: controller.usernameController,
                        validator: (value) =>
                            TValidator.validateNickname('Username', value),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.refreshUsername(),
                    icon: Icon(Ionicons.dice_outline, size: TSizes.iconLg),
                  ),
                ],
              ),
            ),
            SizedBox(height: TSizes.spaceBtwItems),
            SizedBox(
              width: double.maxFinite,
              child: TGradientElevatedButton(
                text: 'Continue',
                onPressed: () => controller.createUsername(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
