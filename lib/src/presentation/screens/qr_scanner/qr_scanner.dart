import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';
import '../../../core/utils/logging/logger.dart';
import '../../controllers/qr_scanner_controller/qr_scanner_binding.dart';
import '../../controllers/qr_scanner_controller/qr_scanner_controller.dart';

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
          child: Center(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Padding(
                      padding: EdgeInsets.all(TSizes.lg),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(TSizes.cardRadiusLg),
                        child: MobileScanner(
                          controller: controller.mobileController,
                          errorBuilder: (p0, p1, p2) {
                            TLoggerHelper.error(p1.errorDetails!.message!);
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  ),
                  QRScannerOverlay(
                    scanAreaWidth: double.maxFinite,
                    scanAreaHeight: 300.h,
                    borderColor: TColors.primary,
                    overlayColor: Colors.transparent,
                  ),
                  const Positioned(
                    bottom: 0,
                    child: Text('Place the QR inside the scanner'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
