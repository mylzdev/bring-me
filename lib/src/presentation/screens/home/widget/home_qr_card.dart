import 'package:flutter/material.dart';

import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';

class THomeQrCard extends StatelessWidget {
  const THomeQrCard({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      decoration: BoxDecoration(
        color: TColors.darkContainer,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          onTap: onPressed,
          child: Icon(icon),
        ),
      ),
    );
  }
}
