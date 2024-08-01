import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/colors.dart';

/// Manages the network connectivity status and provides methods to check and handle connectivity changes.
class InternetService extends GetxService {
  static InternetService get instance => Get.find();

  final connectivity = Connectivity();
  final _isConnectedClick = false.obs;

  @override
  void onInit() {
    connectivity.onConnectivityChanged.listen(_updateConnectivityStatus);
    super.onInit();
  }

  void _updateConnectivityStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (!(Get.isDialogOpen ?? false)) {
        _showNoInternetDialog();
      }
    }
  }

  Future<bool> isConnected() async {
    try {
      final hasInternet = await connectivity.checkConnectivity();
      if (hasInternet.contains(ConnectivityResult.none)) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void _showNoInternetDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: TColors.darkContainer,
      title: 'Oops, no internet',
      titlePadding: const EdgeInsets.only(top: 24),
      middleText: 'Try to reconnect to the internet',
      contentPadding: const EdgeInsets.symmetric(vertical: 24),
      onWillPop: _pop,
      actions: [
        Obx(() {
          return !_isConnectedClick.value
              ? Center(
                  child: ElevatedButton(
                    onPressed: () => _attemptReconnect(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('Connect'),
                  ),
                )
              : const CircularProgressIndicator.adaptive();
        })
      ],
    );
  }

  Future<bool> _pop() async => false;

  Future<void> _attemptReconnect() async {
    _isConnectedClick.value = true;
    final connected = await isConnected();
    if (connected) {
      _closeNoInternetDialog();
    } else {
      final reconnected = await isConnected();
      if (reconnected) {
        _closeNoInternetDialog();
      }
      await Future.delayed(const Duration(seconds: 1));
      _isConnectedClick.value = false;
    }
  }

  _closeNoInternetDialog() {
    if (Get.isDialogOpen!) {
      _isConnectedClick.value = false;
      Navigator.of(Get.overlayContext!).pop();
    }
  }
}
