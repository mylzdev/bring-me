import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/common/widgets/text/icon_text.dart';
import '../../../controllers/home_controller/home_controller.dart';
import '../../auth/auth.dart';
import '../../auth/avatar_selection.dart';
import '../../leader_board/leader_board.dart';

class THomeFooter extends StatelessWidget {
  const THomeFooter({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TIconText(
          title: 'Board',
          icon: Icons.leaderboard,
          onPressed: () => LeaderBoard.show(),
        ),
        TIconText(
          title: 'Avatar',
          icon: Icons.person,
          onPressed: () => Get.to(
            () => const AvatarSelection(isUpdating: true),
            transition: Transition.downToUp,
          ),
        ),
        TIconText(
          title: 'Name',
          icon: Icons.badge,
          onPressed: () => Get.to(
            () => const AuthenticationScreen(isUpdating: true),
            transition: Transition.downToUp,
          ),
        ),
        TIconText(
          title: 'Info',
          icon: Ionicons.share,
          onPressed: controller.showShareAppDialog,
        ),
      ],
    );
  }
}
