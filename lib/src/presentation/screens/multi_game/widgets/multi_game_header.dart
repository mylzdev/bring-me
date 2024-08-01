import 'package:bring_me/src/core/config/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/container/custom_container.dart';
import '../../../../core/common/widgets/text/gradient_text.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';
import '../../../controllers/room_controller/room_controller.dart';

class TMultiGameHeader extends StatelessWidget {
  const TMultiGameHeader({
    super.key,
    required this.controller,
  });

  final RoomController controller;

  @override
  Widget build(BuildContext context) {
    return TCustomContainer(
      height: 105,
      width: double.maxFinite,
      child: Obx(
        () => switch (controller.itemHuntStatus.value) {
          ItemHuntStatus.initial => TMultiGameHeaderContent(
              title: 'Bring Me',
              subtitle: controller.currentitem,
            ),
          ItemHuntStatus.validationInProgress =>
            const TMultiGameHeaderContent(subtitle: 'Validating'),
          ItemHuntStatus.validationFailure =>
            const TMultiGameHeaderContent(subtitle: 'Failed'),
          ItemHuntStatus.validationSuccess =>
            const TMultiGameHeaderContent(subtitle: 'Success'),
        },
      ),
    );
  }
}

class TMultiGameHeaderContent extends StatelessWidget {
  const TMultiGameHeaderContent(
      {super.key, this.title = '', required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: title != '',
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: TColors.white.withOpacity(0.8),
                    ),
              ),
              SizedBox(height: TSizes.xs),
            ],
          ),
        ),
        TGradientText(
          subtitle,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .apply(letterSpacingDelta: 2.sp),
        ),
      ],
    );
  }
}
