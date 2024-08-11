import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../avatar_selection.dart';

class TWelcomeFooter extends StatelessWidget {
  const TWelcomeFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Get.bottomBarHeight + 20,
      left: 0,
      child: GestureDetector(
        onTap: () => Get.to(
          () => const AvatarSelection(),
          transition: Transition.rightToLeft,
        ),
        child: Container(
          width: TSizes.iconLg * 2,
          height: TSizes.iconLg * 2,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: TColors.primary),
          ),
          child: const Icon(
            Ionicons.arrow_forward,
            shadows: [Shadow(blurRadius: 10, color: Colors.white)],
          ),
        ),
      ),
    );
  }
}
