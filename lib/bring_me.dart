import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'src/core/bindings/general_binding.dart';
import 'src/core/utils/theme/theme.dart';

class BringMe extends StatelessWidget {
  const BringMe({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 853),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        initialBinding: GeneralBinding(),
        debugShowCheckedModeBanner: false,
        theme: TAppTheme.darkTheme,
        home: const Scaffold(),
      ),
    );
  }
}
