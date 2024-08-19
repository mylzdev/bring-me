import 'package:permission_handler/permission_handler.dart';

import '../logging/logger.dart';

class TPermissionHandler {
  static Future<bool> requestPermission(
      {required Permission permission}) async {
    try {
      final status = await permission.status;
      if (status.isGranted) {
        TLoggerHelper.info('Permission already granted');
        return true;
      } else if (status.isDenied) {
        if (await permission.request().isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      TLoggerHelper.error(e.toString());
      return false;
    }
  }

  static Future<bool> requestPermissionWithSettings() async => await openAppSettings();
}
