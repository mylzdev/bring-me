import 'package:get/get.dart';

import '../../../core/config/enums.dart';

class MultiGameController extends GetxController {
  static MultiGameController get instance => Get.find();

  Rx<HuntLocation> huntLocation = HuntLocation.indoor.obs;

}