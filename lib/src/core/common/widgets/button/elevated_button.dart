import 'package:flutter/material.dart';

class TElevatedButton extends StatelessWidget {
  const TElevatedButton({
    super.key,
    this.onPressed,
    this.width,
    this.color,
    required this.title,
  });

  final VoidCallback? onPressed;
  final String title;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
