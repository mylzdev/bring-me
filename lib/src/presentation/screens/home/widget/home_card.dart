import 'package:flutter/material.dart';

import '../../../../core/common/widgets/container/custom_container.dart';
import '../../../../core/config/sizes.dart';

class THomeButton extends StatelessWidget {
  const THomeButton({
    super.key,
    required this.title,
    required this.subtitle,
    this.isPrimary = true,
    this.onPressed,
  });

  final String title, subtitle;
  final bool isPrimary;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TCustomContainer(
        isPrimary: isPrimary,
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: TSizes.xs),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}