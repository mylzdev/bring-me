import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'src/core/bindings/general_binding.dart';
import 'src/core/config/colors.dart';
import 'src/core/utils/theme/theme.dart';

class BringMe extends StatelessWidget {
  const BringMe({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      backgroundColor: TColors.dark,
      enabled: kReleaseMode, // TODO : add !
      builder: (context) => ScreenUtilInit(
        designSize: const Size(411, 853),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => GetMaterialApp(
          initialBinding: GeneralBinding(),
          debugShowCheckedModeBanner: false,
          theme: TAppTheme.darkTheme,
          home: const Scaffold(),
        ),
      ),
    );
  }
}
