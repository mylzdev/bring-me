import 'package:flutter/material.dart';

import '../../../config/sizes.dart';

class TGradientElevatedButton extends StatelessWidget {
  const TGradientElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          transform: GradientRotation(5.2),
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xff217BFE),
            Color(0xff078EFB),
            Color(0xffA190FF),
            Color(0xffBD99FE)
          ],
        ),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
