import 'package:flutter/material.dart';

class TElevatedButton extends StatelessWidget {
  const TElevatedButton({
    super.key,
    this.onPressed,
    this.width,
    required this.title,
  });

  final VoidCallback? onPressed;
  final String title;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
