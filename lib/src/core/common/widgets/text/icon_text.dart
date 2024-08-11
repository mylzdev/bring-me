import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/colors.dart';
import '../../../config/sizes.dart';

class TIconText extends StatelessWidget {
  const TIconText({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(TSizes.md / 1.5),
            decoration: BoxDecoration(
              color: TColors.containerPrimary,
              borderRadius: BorderRadius.circular(TSizes.borderRadiusLg * 1.7),
            ),
            child: Icon(
              icon,
              size: 35.h,
            ),
          ),
          SizedBox(height: TSizes.xs),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
