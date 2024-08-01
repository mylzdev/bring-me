import 'package:bring_me/src/core/config/colors.dart';
import 'package:bring_me/src/core/utils/helpers/helper_functions.dart';
import 'package:bring_me/src/presentation/controllers/room_controller/room_binding.dart';
import 'package:bring_me/src/presentation/controllers/room_controller/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/common/widgets/appbar/appbar.dart';
import '../../../core/config/sizes.dart';

class RoomScreen extends GetView<RoomController> {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RoomBinding().dependencies();
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => controller.onLeaveRoom(),
      child: Scaffold(
        appBar: TAppbar(
          title: Text('Room ID: ${controller.roomInfo.value.roomID}'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.qr_code_rounded),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                    'Location: ${THelperFunctions.getHuntLocation(controller.roomInfo.value.huntLocation)}'),
                contentPadding: EdgeInsets.zero,
              ),
              ListTile(
                title:
                    Text('Max User: ${controller.roomInfo.value.maxPlayers}'),
                contentPadding: EdgeInsets.zero,
              ),
              const Text('Players'),
              SizedBox(height: TSizes.spaceBtwItems),
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.roomInfo.value.players.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: TSizes.spaceBtwItems),
                  itemBuilder: (context, index) => Container(
                    color: TColors.darkContainer,
                    child: ListTile(
                      title:
                          Text(controller.roomInfo.value.players[index].name),
                      trailing:
                          controller.roomInfo.value.players[index].isLeader
                              ? const Icon(Iconsax.crown, color: Colors.amber)
                              : controller.roomInfo.value.players[index].isReady
                                  ? const Icon(Icons.check_circle_outline,
                                      color: TColors.success)
                                  : null,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.isRoomLeader) {
                      // Start
                      controller.startGame();
                    } else {
                      // Ready
                      controller.setReady();
                    }
                  },
                  child: Obx(
                      () => Text(controller.isRoomLeader ? 'Start' : 'Ready')),
                ),
              ),
              SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.error,
                    side: BorderSide.none,
                  ),
                  onPressed: () => controller.onLeaveRoom(),
                  child: const Text('Leave'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
