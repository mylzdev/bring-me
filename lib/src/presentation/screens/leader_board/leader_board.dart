import 'package:bring_me/src/core/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/config/sizes.dart';

class LeaderBoard {
  static void show() {
    Get.bottomSheet(
      enableDrag: false,
      backgroundColor: TColors.dark,
      isScrollControlled: true,
      Container(
        height: Get.height * 0.75,
        padding: EdgeInsets.fromLTRB(
          TSizes.defaultSpace,
          0,
          TSizes.defaultSpace,
          TSizes.defaultSpace,
        ),
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
            SizedBox(
              height: 50.h,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -30.h,
                    child: Container(
                      height: 80.h,
                      width: 80.h,
                      decoration: const BoxDecoration(
                        color: TColors.dark,
                        shape: BoxShape.circle,
                        border: Border(
                          top: BorderSide(
                            color: TColors.primary,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -18.h,
                    child: Container(
                      padding: EdgeInsets.all(TSizes.md),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 45, 45, 45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.leaderboard,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: TSizes.sm),
            Text(
              'Leaderboard',
              style: Get.theme.textTheme.headlineSmall,
            ),
            const Spacer(),
            const Text('Coming Soon'),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
