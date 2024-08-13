import 'package:bring_me/src/presentation/controllers/qr_scanner_controller/qr_scanner_controller.dart';
import 'package:get/get.dart';

class QrScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QrScannerController());
  }
}
