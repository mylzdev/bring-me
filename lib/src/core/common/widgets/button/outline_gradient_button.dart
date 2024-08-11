import 'package:bring_me/src/core/config/sizes.dart';
import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class TOutlineGradientButton extends StatelessWidget {
  const TOutlineGradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.strokeWidth = 1,
  });

  final String text;
  final VoidCallback? onPressed;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return OutlineGradientButton(
      onTap: onPressed,
      inkWell: true,
      padding: EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
      strokeWidth: strokeWidth!,
      radius: Radius.circular(TSizes.buttonRadius),
      gradient: const LinearGradient(
        colors: [
          Color(0xff217BFE),
          Color(0xff078EFB),
          Color(0xffA190FF),
          Color(0xffBD99FE)
        ],
      ),
      child: Center(
          child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      )),
    );
  }
}
