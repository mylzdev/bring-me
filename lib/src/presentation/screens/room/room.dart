import 'package:bring_me/src/presentation/controllers/room_controller/room_binding.dart';
import 'package:bring_me/src/presentation/controllers/room_controller/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/sizes.dart';
import 'widget/room_action_button.dart';
import 'widget/room_info.dart';
import 'widget/room_players.dart';

class RoomScreen extends GetView<RoomController> {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RoomBinding().dependencies();
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => controller.onLeaveRoom(),
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                TRoomInfo(controller: controller),
                const Spacer(),
                TRoomPlayers(controller: controller),
                const Spacer(),
                TRoomActionButton(controller: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
