import 'package:bring_me/src/core/common/widgets/button/elevated_gradient_button.dart';
import 'package:bring_me/src/core/utils/popups/popups.dart';
import 'package:bring_me/src/core/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/enums.dart';
import '../../../../core/config/sizes.dart';
import '../../../controllers/home_controller/home_controller.dart';
import 'home_location_button.dart';
import 'home_qr_card.dart';

class THomeBottomSheet {
  static void show({
    required HomeController controller,
    required String title,
    required VoidCallback onPressed,
    bool joinTextFieldVisible = true,
    bool qrVisible = false,
    bool maxPlayerVisible = false,
  }) {
    Get.bottomSheet(
      backgroundColor: TColors.dark,
      enableDrag: false,
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        height: Get.height * 0.5,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TSizes.borderRadiusLg * 3),
            topRight: Radius.circular(TSizes.borderRadiusLg * 3),
          ),
          border: const Border(
            top: BorderSide(color: TColors.primary),
          ),
        ),
        child: Column(
          children: [
            // Title
            Text(
              title,
              style: Theme.of(Get.context!).textTheme.headlineSmall,
            ),
            const Divider(),
            SizedBox(height: TSizes.spaceBtwItems),
            // Room code for Join room
            Visibility(
              visible: !joinTextFieldVisible,
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter room code',
                      style: Theme.of(Get.context!).textTheme.headlineSmall,
                    ),
                    SizedBox(height: TSizes.sm),
                    Form(
                      key: controller.joinRoomState,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: controller.joinRoomTextController,
                              validator: (value) => TValidator.validateRoomCode(
                                  'Room Code', value),
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(hintText: '12345'),
                            ),
                          ),
                          SizedBox(width: TSizes.sm),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: onPressed,
                              child: const Text('Join'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // QR
                    SizedBox(height: TSizes.spaceBtwItems),
                    Text(
                      'Join via QR',
                      style: Theme.of(Get.context!).textTheme.headlineSmall,
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: THomeQrCard(
                              icon: Iconsax.gallery,
                              onPressed: () => TPopup.warningSnackbar(
                                  title: 'Coming Soon',
                                  message: 'This feature will be up soon'),
                            ),
                          ),
                          SizedBox(width: TSizes.sm),
                          Expanded(
                            child: THomeQrCard(
                              icon: Icons.qr_code_scanner_rounded,
                              onPressed: () => TPopup.warningSnackbar(
                                  title: 'Coming Soon',
                                  message: 'This feature will be up soon'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Max Player for room creation
            Visibility(
              visible: maxPlayerVisible,
              child: Column(
                children: [
                  const Text('Max Player'),
                  SizedBox(
                    width: double.maxFinite,
                    child: Obx(
                      () => SfSlider(
                        value: controller.maxPlayers.value,
                        min: 2,
                        max: 4,
                        interval: 1,
                        showLabels: true,
                        stepSize: 1,
                        activeColor: TColors.primary,
                        onChanged: (value) => controller.setMaxUser(value),
                      ),
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
            ),
            // Location cards
            Visibility(
              visible: joinTextFieldVisible,
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    THomeLocationButton(
                      homeController: controller,
                      huntLocation: HuntLocation.indoor,
                    ),
                    SizedBox(width: TSizes.spaceBtwItems),
                    THomeLocationButton(
                      homeController: controller,
                      huntLocation: HuntLocation.outdoor,
                    )
                  ],
                ),
              ),
            ),
            // Button footer
            Visibility(
              visible: joinTextFieldVisible,
              child: Column(
                children: [
                  SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: double.maxFinite,
                    child: TGradientElevatedButton(
                      onPressed: onPressed,
                      text: 'Continue',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
