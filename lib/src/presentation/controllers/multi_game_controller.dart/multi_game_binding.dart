import 'package:bring_me/src/presentation/controllers/multi_game_controller.dart/multi_game_controller.dart';
import 'package:get/get.dart';

class MultiGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MultiGameController());
  }
}