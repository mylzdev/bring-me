import 'package:flutter/material.dart';

import '../../../../core/config/sizes.dart';
import '../../../controllers/single_game_controller/single_game_controller.dart';

class TSingleGameFooter extends StatelessWidget {
  const TSingleGameFooter({
    super.key,
    required this.controller,
  });

  final SingleGameController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () => controller.skipItem(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: TSizes.md),
            ),
            child: const Text('Skip'),
          ),
          SizedBox(width: TSizes.spaceBtwItems),
          ElevatedButton(
            onPressed: () => controller.validateImage(),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: TSizes.md)),
            child: const Text('Take Photo'),
          )
        ],
      ),
    );
  }
}
