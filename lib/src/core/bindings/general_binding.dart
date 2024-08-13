import 'package:bring_me/src/data/repository/room_repository/room_repository.dart';
import 'package:bring_me/src/presentation/controllers/player_controller/player_controller.dart';
import 'package:get/get.dart';

import '../../data/repository/gemini_repository/gemini_repository.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GeminiRepository());
    Get.put(PlayerController(), permanent: true);
    Get.lazyPut(() => RoomRepository());
  }
}
