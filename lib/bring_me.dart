import 'package:bring_me/src/core/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BringMe extends StatelessWidget {
  const BringMe({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const Scaffold(),
    );
  }
}