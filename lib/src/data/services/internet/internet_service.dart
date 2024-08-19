import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/colors.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../presentation/screens/auth/welcome.dart';
import '../../../presentation/screens/home/home.dart';
import '../../repository/player_repository/player_repository.dart';

/// Manages the network connectivity status and provides methods to check and handle connectivity changes.
class InternetService extends GetxService {
  static InternetService get instance => Get.find();

  final connectivity = Connectivity();
  final _isConnectedClick = false.obs;
  bool isFontsLoaded = false;

  @override
  void onInit() {
    connectivity.onConnectivityChanged.listen(_updateConnectivityStatus);
    super.onInit();
  }

  void _updateConnectivityStatus(
      List<ConnectivityResult> connectivityResult) async {
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (!(Get.isDialogOpen ?? false)) {
        TLoggerHelper.info('NO INTERNET');
        showNoInternetDialog();
      }
    } else {
      if (!isFontsLoaded) {
        await GoogleFonts.pendingFonts([
          GoogleFonts.playfair(),
          GoogleFonts.poppins(),
          GoogleFonts.blackHanSans(),
        ]);
        TLoggerHelper.info('FONTS LOADED');
        isFontsLoaded = true;
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

  void showNoInternetDialog({bool shouldRedirectToHome = false}) {
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
                    onPressed: () async {
                      final reconnected = await _attemptReconnect();
                      if (reconnected) {
                        if (shouldRedirectToHome &&
                            PlayerRepository.instance.authUser != null) {
                          _isConnectedClick.value = false;
                          Get.offAll(() => const HomeScreen());
                        } else if (shouldRedirectToHome &&
                            PlayerRepository.instance.authUser == null) {
                          _isConnectedClick.value = false;
                          Get.offAll(() => const WelcomeScreen());
                        } else {
                          _closeNoInternetDialog();
                        }
                      }
                    },
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

  Future<bool> _attemptReconnect() async {
    _isConnectedClick.value = true;
    final connected = await isConnected();
    if (connected) {
      return true;
    } else {
      final reconnected = await isConnected();
      if (reconnected) {
        return true;
      }
      await Future.delayed(const Duration(seconds: 1));
      _isConnectedClick.value = false;
      return false;
    }
  }

  _closeNoInternetDialog() {
    if (Get.isDialogOpen!) {
      _isConnectedClick.value = false;
      Navigator.of(Get.overlayContext!).pop();
    }
  }
}
