import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/container/custom_container.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/sizes.dart';

class THomePlayerScore extends StatelessWidget {
  const THomePlayerScore({
    super.key,
    required this.icon,
    required this.score,
  });

  final IconData icon;
  final String score;

  @override
  Widget build(BuildContext context) {
    return TCustomContainer(
      height: 35.h,
      padding: EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: TSizes.sm),
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Container(
                width: 50.w,
                decoration: BoxDecoration(
                  color: TColors.secondary,
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                ),
              ),
              SizedBox(width: TSizes.md),
              Text(score),
            ],
          ),
          Positioned(
            left: -20,
            child: Container(
              padding: EdgeInsets.all(TSizes.xs),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: TColors.primary,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Icon(
                  icon,
                  size: 25.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}