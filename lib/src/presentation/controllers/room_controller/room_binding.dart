import 'package:bring_me/src/presentation/controllers/home_controller/home_controller.dart';
import 'package:bring_me/src/presentation/controllers/room_controller/room_controller.dart';
import 'package:get/get.dart';

class RoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RoomController(HomeController.instance, false), permanent: true);
  }
}
