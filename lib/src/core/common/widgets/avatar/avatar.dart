import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/colors.dart';
import '../../../config/sizes.dart';

class TAvatar extends StatelessWidget {
  const TAvatar({
    super.key,
    required this.avatar,
    this.name = '',
    this.icon,
    this.shouldGlow = false,
    this.textStyle,
    this.height,
    this.width,
    this.margin,
    this.isSelected = true,
    this.borderColor,
  });

  final String avatar;
  final String name;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool shouldGlow;
  final double? height, width;
  final EdgeInsetsGeometry? margin;
  final bool isSelected;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? EdgeInsets.all(TSizes.lg),
      decoration: BoxDecoration(
        color: TColors.darkGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: isSelected ? TColors.primary : Colors.transparent,
        ),
        boxShadow: shouldGlow
            ? const [
                BoxShadow(
                  color: TColors.primary,
                  blurRadius: 10,
                  blurStyle: BlurStyle.outer,
                )
              ]
            : null,
      ),
      padding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: SvgPicture.asset(
              avatar,
              colorFilter: !isSelected
                  ? ColorFilter.mode(
                      Colors.white.withOpacity(0.5),
                      BlendMode.modulate,
                    )
                  : null,
            ),
          ),
          Visibility(
            visible: name != '',
            child: Positioned(
              bottom: -30,
              child: Text(
                name,
                style: textStyle ?? Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Visibility(
            visible: icon != null,
            child: Positioned(
              top: 0,
              left: 0,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: TColors.dark,
                ),
                child: Icon(
                  icon,
                  color: TColors.primary,
                  size: 35.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
