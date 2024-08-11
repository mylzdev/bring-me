import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/common/widgets/text/icon_text.dart';

class THomeFooter extends StatelessWidget {
  const THomeFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TIconText(title: 'Friends', icon: Ionicons.people),
        TIconText(title: 'Board', icon: Icons.leaderboard),
        TIconText(title: 'User', icon: Icons.person),
        TIconText(title: 'Info', icon: Ionicons.information),
      ],
    );
  }
}
