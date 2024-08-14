import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/common/widgets/dialog/custom_dialog.dart';
import '../../../../core/common/widgets/text/icon_text.dart';
import '../../../../core/config/lottie.dart';
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
          icon: Ionicons.information,
          onPressed: () {
            showInfoDialog();
          },
        ),
      ],
    );
  }
}

void showInfoDialog() {
  CustomDialog.show(
      title: 'Bring Me',
      dismissable: true,
      lottie: LottieAsset.gemini,
      hideActionButtons: false,
      lottieBackgroundColor: Colors.transparent,
      lottieSize: 100.h,
      subtitle: 'A fun and engaging game app inspired by the classic game. '
          'This app challenges players to quickly bring the called '
          'item to the acting host which is "Gemini"');
}
