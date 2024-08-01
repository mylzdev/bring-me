import 'package:bring_me/src/presentation/controllers/home_controller/home_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/appbar/appbar.dart';
import '../../../core/config/sizes.dart';
import '../../controllers/home_controller/home_controller.dart';
import 'widget/home_bottom_sheet.dart';
import 'widget/home_card.dart';
import 'widget/multiplayer_bottom_sheet.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBinding().dependencies();
    return Scaffold(
      appBar: TAppbar(title: Text(controller.username)),
      body: Padding(
        padding: EdgeInsets.all(TSizes.spaceBtwSections),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200.h,
                child: Row(
                  children: [
                    THomeButton(
                      title: 'Solo',
                      subtitle: 'Play solo with gemini',
                      onPressed: () {
                        controller.isSinglePlayer.value = true;
                        THomeBottomSheet.show(
                          controller: controller,
                          title: 'Single Player',
                          onPressed: controller.playSinglePlayer,
                        );
                      },
                    ),
                    SizedBox(width: TSizes.spaceBtwItems),
                    THomeButton(
                      isPrimary: false,
                      title: 'With frens',
                      subtitle: 'Play with friends',
                      onPressed: () =>
                          THomeMultiplayerBottomSheet.show(controller),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
