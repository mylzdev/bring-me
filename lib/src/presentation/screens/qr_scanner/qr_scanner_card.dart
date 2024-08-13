import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/config/sizes.dart';
import '../home/widget/home_qr_card.dart';
import 'qr_scanner.dart';

class QRScannerCard extends StatelessWidget {
  const QRScannerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: THomeQrCard(
            icon: Iconsax.gallery,
            onPressed: () {} // TODO : Separate the qr image scan from qr controller,
          ),
        ),
        SizedBox(width: TSizes.sm),
        Expanded(
          child: THomeQrCard(
            icon: Icons.qr_code_scanner_rounded,
            onPressed: () => Get.to(
              () => const THomeQRScanner(),
            ),
          ),
        ),
      ],
    );
  }
}
