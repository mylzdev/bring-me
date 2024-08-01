import 'dart:async';
import 'dart:math';

import 'package:bring_me/src/core/utils/device/local_storage_key.dart';
import 'package:bring_me/src/core/utils/popups/loader.dart';
import 'package:bring_me/src/data/repository/gemini_repository/gemini_repository.dart';
import 'package:bring_me/src/data/repository/player_repository/player_model.dart';
import 'package:bring_me/src/data/repository/player_repository/player_repository.dart';
import 'package:bring_me/src/presentation/screens/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/config/text_strings.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../core/utils/popups/popups.dart';
import '../../screens/home/home.dart';

class PlayerController extends GetxController {
  static PlayerController get instance => Get.find();

  final _localStorage = GetStorage();
  final _playerRepository = PlayerRepository.instance;

  late RxList<String> generatedUsernames = <String>[].obs;
  final isGeneratingUsernames = true.obs;

  final usernameController = TextEditingController();
  GlobalKey<FormState> usernameFormKey = GlobalKey<FormState>();

  Rx<PlayerModel> playerInfo = PlayerModel.empty().obs;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _playerSubscription;

  @override
  Future<void> onInit() async {
    _playerRepository.username.listen((user) => streamPlayerInfo(user));
    super.onInit();
  }

  @override
  void onClose() {
    _playerSubscription?.cancel();
    super.onClose();
  }

  Future<void> navigateToAuth() async {
    try {
      if (isGeneratingUsernames.value) {
        TFullScreenLoader.openLoadingDialog('Loading');
        await generateUsernames();
      }
      TFullScreenLoader.stopLoading();
      Get.off(() => const AuthenticationScreen());
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }

  Future<void> createUsername() async {
    try {
      if (!usernameFormKey.currentState!.validate()) return;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => TFullScreenLoader.openLoadingDialog('Loading'),
      );

      final playerModel = PlayerModel(name: usernameController.text);
      playerInfo.value = playerModel;
      await _playerRepository.saveUsername(playerModel);

      _localStorage.write(TLocalStorageKey.username, usernameController.text);
      _playerRepository.username.value = usernameController.text;
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      TLoggerHelper.error(e.toString());
      TPopup.errorSnackbar(title: TTexts.ohSnap, message: e.toString());
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => TFullScreenLoader.stopLoading(),
      );
    }
  }

  Future<void> generateUsernames() async {
    try {
      final usernames = await GeminiRepository.instance.generateUsername();
      generatedUsernames.addAll(usernames);
      refreshUsername();
    } catch (e) {
      TLoggerHelper.error(e.toString());
    }
  }

  void refreshUsername() {
    usernameController.text =
        generatedUsernames[Random().nextInt(generatedUsernames.length)].trim();
  }

  void streamPlayerInfo(String username) {
    if (username.isNotEmpty) {
      _playerSubscription =
          _playerRepository.playerStream(username).listen((playerSnapshot) {
        if (playerSnapshot.exists) {
          playerInfo.value = PlayerModel.fromSnapshot(playerSnapshot);
          TLoggerHelper.info('Player info updated');
        } else {
          TLoggerHelper.info('Player document does not exist');
        }
      });
    } else {
      TLoggerHelper.error('Username is empty, cannot stream player info');
    }
  }
}
