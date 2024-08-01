import 'package:flutter/material.dart';

import '../../../config/colors.dart';
import '../../../config/sizes.dart';

class TCustomContainer extends StatelessWidget {
  const TCustomContainer({
    super.key,
    required this.child,
    this.isPrimary = true,
    this.height,
    this.width,
    this.padding,
    this.onPressed,
    this.borderColor,
    this.margin,
  });

  final Widget child;
  final bool isPrimary;
  final double? height, width;
  final EdgeInsetsGeometry? padding, margin;
  final VoidCallback? onPressed;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: isPrimary
            ? const RadialGradient(
                colors: [
                  Color(0xff090C15),
                  Color(0xff0b0d19),
                ],
              )
            : const RadialGradient(
                colors: [
                  Color.fromARGB(255, 24, 12, 15),
                  Color.fromARGB(255, 36, 17, 25),
                ],
              ),
        border: Border.all(
          color: borderColor != null
              ? borderColor!
              : isPrimary
                  ? TColors.primary
                  : TColors.secondary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(
          TSizes.borderRadiusLg,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          onTap: onPressed,
          child: Padding(
            padding: padding ?? EdgeInsets.all(TSizes.defaultSpace),
            child: child,
          ),
        ),
      ),
    );
  }
}
