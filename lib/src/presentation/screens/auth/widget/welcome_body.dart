import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/text/gradient_text.dart';
import '../../../../core/config/sizes.dart';

class TWelcomeBody extends StatelessWidget {
  const TWelcomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Get.height / 6,
      left: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Play The',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .apply(heightFactor: 1),
          ),
          TGradientText(
            'Classic',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .apply(heightFactor: 1),
          ),
          Text(
            'Game Online',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .apply(heightFactor: 1),
          ),
          SizedBox(height: TSizes.spaceBtwSections),
          ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: Get.width - 2 * TSizes.defaultSpace),
            child: Text(
              'Compete with friends to find and bring requested items in real-time.',
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
