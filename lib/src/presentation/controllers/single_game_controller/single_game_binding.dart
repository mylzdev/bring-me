import 'package:get/get.dart';

import '../home_controller/home_controller.dart';
import 'single_game_controller.dart';

class SingleGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SingleGameController(HomeController.instance));
  }
}