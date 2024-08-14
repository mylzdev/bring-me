import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/common/widgets/avatar/avatar.dart';
import '../../../../data/repository/player_repository/player_avatar_model.dart';
import '../../../controllers/player_controller/player_controller.dart';
import '../../../controllers/room_controller/room_controller.dart';

class TRoomPlayers extends StatelessWidget {
  const TRoomPlayers({
    super.key,
    required this.controller,
  });

  final RoomController controller;

  @override
  Widget build(BuildContext context) {
    final playerController = PlayerController.instance;
    return Obx(
      () => Visibility(
        visible: controller.roomInfo.value.players.length != 1,
        replacement: TAvatar(
          avatar: playerController.playerAvatar,
          height: 120.h,
          width: 120.w,
          name: controller.roomInfo.value.players.first.name,
          icon: Ionicons.star,
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: controller.roomInfo.value.players.length,
          itemBuilder: (context, index) => TAvatar(
            avatar: PlayerAvatarModel
                .avatars[controller.roomInfo.value.players[index].avatarIndex!],
            name: controller.roomInfo.value.players[index].name,
            icon: controller.roomInfo.value.players[index].isLeader
                ? Ionicons.star
                : controller.roomInfo.value.players[index].isReady
                    ? Ionicons.checkmark_circle
                    : Icons.circle_outlined,
          ),
        ),
      ),
    );
  }
}
