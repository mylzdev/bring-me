import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/colors.dart';
import '../../../../data/repository/player_repository/player_model.dart';
import '../../../../data/repository/player_repository/player_repository.dart';

class TPlacingBadge extends StatelessWidget {
  const TPlacingBadge({
    super.key,
    required this.sortedPlayers,
    required this.index,
  });

  final List<PlayerModel> sortedPlayers;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-15.w, -5.h),
      child: ClipPath(
        clipper: StarClipper(7),
        child: Container(
          color: sortedPlayers[index].name ==
                  PlayerRepository.instance.username.value
              ? TColors.secondary
              : TColors.primary,
          height: 45.h,
          width: 45.w,
          child: Center(
            child: Text(
              '${index + 1}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 13.sp, shadows: [
                const Shadow(
                  blurRadius: 20,
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}