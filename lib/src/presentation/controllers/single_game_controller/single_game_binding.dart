import 'package:bring_me/src/presentation/controllers/home_controller/home_controller.dart';
import 'package:bring_me/src/presentation/controllers/single_game_controller/single_game_controller.dart';
import 'package:get/get.dart';

class SingleGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SingleGameController(HomeController.instance));
  }
}