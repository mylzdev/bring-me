import 'package:get/get.dart';

import '../home_controller/home_controller.dart';
import 'room_controller.dart';

class RoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RoomController(HomeController.instance, false), permanent: true);
  }
}
