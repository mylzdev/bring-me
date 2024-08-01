import 'package:bring_me/src/core/config/sizes.dart';
import 'package:flutter/material.dart';

import 'widget/welcome_body.dart';
import 'widget/welcome_footer.dart';
import 'widget/welcome_header.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: const Stack(
          alignment: Alignment.topCenter,
          fit: StackFit.expand,
          children: [
            TWelcomeHeader(),
            TWelcomeBody(),
            TWelcomeFooter(),
          ],
        ),
      ),
    );
  }
}
