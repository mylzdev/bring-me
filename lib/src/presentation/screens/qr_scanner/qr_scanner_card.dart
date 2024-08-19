import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/config/sizes.dart';
import '../../controllers/home_controller/home_controller.dart';
import '../home/widget/home_qr_card.dart';
import 'qr_scanner.dart';

class QRScannerCard extends StatelessWidget {
  const QRScannerCard({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: THomeQrCard(
            icon: Iconsax.gallery,
            onPressed: () => controller.scanQrFromImage(),
          ),
        ),
        SizedBox(width: TSizes.sm),
        Expanded(
          child: THomeQrCard(
            icon: Icons.qr_code_scanner_rounded,
            onPressed: () => controller.askForCameraPermission(
              callback: () => Get.to(() => const THomeQRScanner()),
            ),
          ),
        ),
      ],
    );
  }
}
