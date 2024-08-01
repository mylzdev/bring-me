import 'dart:ui';

import 'package:flutter/material.dart';

class BlurFilter extends StatelessWidget {
  final double blurX;
  final double blurY;
  final Widget child;

  const BlurFilter({
    super.key,
    required this.blurX,
    required this.blurY,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
      ],
    );
  }
}
