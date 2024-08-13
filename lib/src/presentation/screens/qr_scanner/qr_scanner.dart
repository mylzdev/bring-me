import 'package:bring_me/src/presentation/controllers/qr_scanner_controller/qr_scanner_binding.dart';
import 'package:bring_me/src/presentation/controllers/qr_scanner_controller/qr_scanner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/config/sizes.dart';
import '../../../core/utils/logging/logger.dart';

class THomeQRScanner extends GetView<QrScannerController> {
  const THomeQRScanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    QrScannerBinding().dependencies();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(
            TSizes.defaultSpace * 2,
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: Get.height * 0.4,
                  child: MobileScanner(
                    controller: controller.mobileController,
                    errorBuilder: (p0, p1, p2) {
                      TLoggerHelper.error(p1.errorDetails!.message!);
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
