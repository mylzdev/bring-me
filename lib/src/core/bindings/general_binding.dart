import 'package:get/get.dart';

import '../../data/repository/gemini_repository/gemini_repository.dart';
import '../../data/repository/room_repository/room_repository.dart';
import '../../presentation/controllers/player_controller/player_controller.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GeminiRepository());
    Get.put(PlayerController(), permanent: true);
    Get.lazyPut(() => RoomRepository());
  }
}
