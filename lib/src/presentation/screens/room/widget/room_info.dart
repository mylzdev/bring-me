import 'package:bring_me/src/presentation/screens/room/widget/room_qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/common/widgets/container/custom_container.dart';
import '../../../../core/common/widgets/text/icon_text.dart';
import '../../../../core/config/sizes.dart';
import '../../../../core/utils/helpers/helper_functions.dart';
import '../../../controllers/room_controller/room_controller.dart';

class TRoomInfo extends StatelessWidget {
  const TRoomInfo({
    super.key,
    required this.controller,
  });

  final RoomController controller;

  @override
  Widget build(BuildContext context) {
    return TCustomContainer(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.defaultSpace,
      ),
      child: Column(
        children: [
          Text(
            'Room Code',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            controller.roomID,
            style: GoogleFonts.blackHanSans().copyWith(fontSize: 35.sp),
          ),
          SizedBox(height: TSizes.spaceBtwItems),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TIconText(
                icon: Ionicons.location,
                title: THelperFunctions.getHuntLocation(
                    controller.roomInfo.value.huntLocation),
              ),
              TIconText(
                icon: Ionicons.people,
                title: '${controller.roomInfo.value.maxPlayers} players',
              ),
              GestureDetector(
                onTap: () => RoomQR.show(controller),
                child: const TIconText(
                  icon: Icons.qr_code,
                  title: 'QR code',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
