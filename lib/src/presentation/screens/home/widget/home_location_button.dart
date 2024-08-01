import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/common/widgets/container/custom_container.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/enums.dart';
import '../../../../core/config/sizes.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../../controllers/home_controller/home_controller.dart';

class THomeLocationButton extends StatelessWidget {
  const THomeLocationButton({
    super.key,
    required this.homeController,
    required this.huntLocation,
  });

  final HomeController homeController;
  final HuntLocation huntLocation;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => TCustomContainer(
          onPressed: () => homeController.setHuntLocation(huntLocation),
          borderColor: homeController.huntLocation.value == huntLocation
              ? TColors.primary
              : TColors.darkGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                huntLocation == HuntLocation.indoor
                    ? Iconsax.home
                    : Ionicons.sunny,
              ),
              SizedBox(height: TSizes.spaceBtwItems),
              Text(THelperFunctions.getHuntLocation(huntLocation)),
            ],
          ),
        ),
      ),
    );
  }
}
