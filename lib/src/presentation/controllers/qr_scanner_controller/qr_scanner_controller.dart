import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/config/text_strings.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../core/utils/popups/loader.dart';
import '../../../core/utils/popups/popups.dart';
import '../../../data/services/photo_picker/photo_picker_service.dart';
import '../home_controller/home_controller.dart';

class QrScannerController extends GetxController with WidgetsBindingObserver {
  static QrScannerController get instance => Get.find();

  final mobileController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    autoStart: false,
  );

  StreamSubscription<BarcodeCapture?>? _subscription;
  final _photoPicker = PhotoPickerService();

  @override
  void onInit() {
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = mobileController.barcodes.listen(_handleBarcode);

    unawaited(mobileController.start());

    super.onInit();
  }

  @override
  void onClose() async {
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Finally, dispose of the controller.
    await mobileController.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mobileController.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        TLoggerHelper.info('message');
        if (mobileController.value.isRunning) {
          // The scanner is already starting, no need to start it again
          break;
        }
        // Resume listening to barcode events and start the scanner
        _subscription = mobileController.barcodes.listen(_handleBarcode);
        unawaited(mobileController.start());
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        if (mobileController.value.isRunning) {
          // Stop the scanner only if it's currently running
          unawaited(mobileController.stop());
        }
        unawaited(_subscription?.cancel());
        _subscription = null;
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  void _handleBarcode(BarcodeCapture barcode) async {
    if (barcode.barcodes.isEmpty) {
      TLoggerHelper.info('EMPTY');
      return;
    }
    try {
      for (final code in barcode.barcodes) {
        TFullScreenLoader.openLoadingDialog('Joining room');

        final String? rawValue = code.rawValue;
        TLoggerHelper.warning('Scanned QR Code: $rawValue');
        await HomeController.instance.joinRoomViaQR(rawValue!);
        unawaited(mobileController.stop());
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      Get.back();
      Get.back();
      unawaited(mobileController.stop());
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
    }
  }

  Future<void> scanQrFromImage() async {
    try {
      final XFile? image = await _photoPicker.pickImage();

      if (image != null) {
        try {
          TFullScreenLoader.openLoadingDialog('Joining room');

          final File imageFile = File(image.path);
          final result = await mobileController.analyzeImage(imageFile.path);

          if (result != null && result.barcodes.isNotEmpty) {
            final qrCode = result.barcodes.first.rawValue;
            await HomeController.instance.joinRoomViaQR(qrCode!);
          } else {
            TLoggerHelper.warning('No QR Code found in the image.');
            TFullScreenLoader.stopLoading();
          }
        } catch (e) {
          TLoggerHelper.error('Error scanning QR code from image: $e');
          TFullScreenLoader.stopLoading();
          TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
        }
      }
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }
}
